//
//  AppModel.m
//  wedocracy-ios-test-wxiaodong85
//
//  Created by Wu Xiao Dong on 6/20/14.
//  Copyright (c) 2014 Wu Xiao Dong. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

+(instancetype)sharedInstance {
    static AppModel* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppModel alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://wedocracy-ios-test.herokuapp.com/client"]];
        self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/javascript", nil];
    }
    return self;
}

- (void)loadWishesWithSuccessBlock:(void (^)(BOOL result))success
                           failure:(void (^)(NSError *error))failure {

    [self.requestManager GET:@"request_index" parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {

        self.wishesArray = [@[] mutableCopy];

        for (NSDictionary* dic in responseObject[@"wishes"]) {
            if([dic[@"Wish"][@"gift"] isKindOfClass:[NSNull class]] ||
               [dic[@"Wish"][@"gift"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1 || 
               [dic[@"Wish"][@"id"] isKindOfClass:[NSNull class]])
                continue;
            [self.wishesArray addObject:dic];
        }

        success(YES);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        failure(error);
    }];
}

- (void)deleteWish:(NSInteger)index {

    NSString* wishId = self.wishesArray[index][@"Wish"][@"id"];
    [self.requestManager DELETE:[NSString stringWithFormat:@"request_delete/%@", wishId] parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
