//
//  NotesCell.h
//  wedocracy-ios-test-wxiaodong85
//
//  Created by Wu Xiao Dong on 6/20/14.
//  Copyright (c) 2014 Wu Xiao Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;

@end
