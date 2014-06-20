//
//  AppModel.h
//  wedocracy-ios-test-wxiaodong85
//
//  Created by Wu Xiao Dong on 6/20/14.
//  Copyright (c) 2014 Wu Xiao Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface AppModel : NSObject

@property (nonatomic, strong) NSMutableArray* wishesArray;
@property (nonatomic, strong) AFHTTPRequestOperationManager* requestManager;

+ (instancetype)sharedInstance;

- (void)loadWishesWithSuccessBlock:(void (^)(BOOL result))success
                           failure:(void (^)(NSError *error))failure;
- (void)deleteWish:(NSInteger)index;
@end
