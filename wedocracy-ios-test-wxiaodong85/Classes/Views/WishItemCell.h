//
//  WishItemCell.h
//  wedocracy-ios-test-wxiaodong85
//
//  Created by Wu Xiao Dong on 6/20/14.
//  Copyright (c) 2014 Wu Xiao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemStoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;

@end
