//
//  WishListViewController.m
//  wedocracy-ios-test-wxiaodong85
//
//  Created by Wu Xiao Dong on 6/20/14.
//  Copyright (c) 2014 Wu Xiao Dong. All rights reserved.
//

#import "WishListViewController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <UIImageView+AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppModel.h"
#import "WishItemCell.h"
#import "WishDetailViewController.h"

@interface WishListViewController () {
    NSIndexPath* selection;
}

@end

@implementation WishListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    __weak WishListViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [AppModel sharedInstance].wishesArray = nil;
        [weakSelf loadWishes];
    }];

    [self loadWishes];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:(UIBarButtonItemStylePlain) target:self action:@selector(editItem:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editItem:(id)sender {
    
    [self setEditing:YES];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:(UIBarButtonItemStylePlain) target:self action:@selector(finishEditing:)]];
}

- (void)finishEditing:(id)sender {
    
    [self setEditing:NO];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:(UIBarButtonItemStylePlain) target:self action:@selector(editItem:)]];
}

- (void)loadWishes {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[AppModel sharedInstance] loadWishesWithSuccessBlock:^(BOOL result) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.tableView.pullToRefreshView stopAnimating];
        });

    } failure:^(NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.tableView.pullToRefreshView stopAnimating];            
        });
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [[AppModel sharedInstance] deleteWish:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        WishDetailViewController* vc = [segue destinationViewController];

        NSDictionary* dic = nil;
        if([AppModel sharedInstance].wishesArray.count > selection.row)
            dic = [AppModel sharedInstance].wishesArray[selection.row][@"Wish"];

        vc.wishDetail = [dic mutableCopy];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selection = indexPath;
    return indexPath;
}

#pragma mark Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AppModel sharedInstance].wishesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WishItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WishItemCell"];

    NSDictionary* dic = nil;
    if([AppModel sharedInstance].wishesArray.count > indexPath.row)
        dic = [AppModel sharedInstance].wishesArray[indexPath.row][@"Wish"];

    if(![dic[@"gift"] isKindOfClass:[NSNull class]])
       cell.itemTitleLabel.text = dic[@"gift"];
    else
        cell.itemTitleLabel.text = @"";

    if(![dic[@"store"] isKindOfClass:[NSNull class]])
      cell.itemStoreLabel.text = dic[@"store"];
    else
        cell.itemStoreLabel.text = @"";

    if(![dic[@"amount"] isKindOfClass:[NSNull class]])
     cell.itemPriceLabel.text = dic[@"amount"];
    else
        cell.itemPriceLabel.text = @"";

    if(![dic[@"photo"] isKindOfClass:[NSNull class]]) {
        NSString* photoUrl = [NSString stringWithFormat:@"http://res.cloudinary.com/hew6ktdno/image/upload/c_fill,h_120,w_120/%@", dic[@"photo"]];
        [cell.thumbImageView setImageWithURL:[NSURL URLWithString:photoUrl]];
    }
    else
        cell.thumbImageView.image = nil;

    return cell;
}

@end
