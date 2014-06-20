//
//  WishDetailViewController.m
//  wedocracy-ios-test-wxiaodong85
//
//  Created by Wu Xiao Dong on 6/20/14.
//  Copyright (c) 2014 Wu Xiao Dong. All rights reserved.
//

#import "WishDetailViewController.h"
#import "GiftCell.h"
#import "IsCashCell.h"
#import "PhotoCell.h"
#import "NotesCell.h"
#import <UIImageView+AFNetworking.h>
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>

@interface WishDetailViewController ()

@end

@implementation WishDetailViewController

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

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:(UIBarButtonItemStylePlain) target:self action:@selector(editItem:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editItem:(id)sender {

    self.tableView.allowsMultipleSelection = NO;
    self.tableView.allowsSelection = YES;

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:(UIBarButtonItemStylePlain) target:self action:@selector(finishEditing:)]];
}

- (void)finishEditing:(id)sender {

    self.tableView.allowsMultipleSelection = NO;
    self.tableView.allowsSelection = NO;

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:(UIBarButtonItemStylePlain) target:self action:@selector(editItem:)]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat cellHeights[] = {-1,
                         44,
                         44,
                         44,
                         80
                         -1,
                         44,
                         44,
                        44,
                        300};

    if(indexPath.row == 0) {

        NSString* gift = @"";
        if(![self.wishDetail[@"gift"] isKindOfClass:[NSNull class]])
            gift = self.wishDetail[@"gift"];
        CGRect rect = [gift boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
                                         context:nil];
        return rect.size.height + 42;

    } else if(indexPath.row == 5) {

        NSString* notes = @"";
        if(![self.wishDetail[@"notes"] isKindOfClass:[NSNull class]])
            notes = self.wishDetail[@"notes"];
        CGRect rect = [notes boundingRectWithSize:CGSizeMake(184, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                         context:nil];
        return rect.size.height + 30;

    }

    return cellHeights[indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray* cellIds = @[@[@"GiftCell", @"gift"],
                         @[@"IsCashCell", @"is_cash"],
                         @[@"", @"amount"],
                         @[@"", @"store"],
                         @[@"", @"item_url"],  // Item URL
                         @[@"NotesCell", @"notes"],
                         @[@"", @"created"],   // Created Date
                         @[@"", @"modified"],   // Modified Date
                         @[@"PhotoCell", @"photo"]
                         ];

    UITableViewCell* cell = nil;

    if([cellIds[indexPath.row][0] isEqualToString:@""]) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue2) reuseIdentifier:@"TwoValueCell"];
        cell.textLabel.text = [cellIds[indexPath.row][1] capitalizedString];
        if(![self.wishDetail[cellIds[indexPath.row][1]] isKindOfClass:[NSNull class]])
            cell.detailTextLabel.text = self.wishDetail[cellIds[indexPath.row][1]];
        else
            cell.detailTextLabel.text = nil;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIds[indexPath.row][0]];
    }

    if(indexPath.row == 0)
        [self buildGiftCell:cell];
    else if(indexPath.row == 1)
        [self buildIsCashCell:cell];
    else if(indexPath.row == 8)
        [self buildPhotoCell:cell];
    else if(indexPath.row == 5)
        [self buildNotesCell:cell];

    return cell;
}

- (void)buildGiftCell:(UITableViewCell*)cell {

    GiftCell* giftCell = (GiftCell*)cell;
    if(![self.wishDetail[@"gift"] isKindOfClass:[NSNull class]])
        giftCell.giftTitleLabel.text = self.wishDetail[@"gift"];
    else
        giftCell.giftTitleLabel.text = nil;
}

- (void)buildIsCashCell:(UITableViewCell*)cell {

    IsCashCell* cashCell = (IsCashCell*)cell;
    if(![self.wishDetail[@"is_cash"] isKindOfClass:[NSNull class]])
        [cashCell.isCashSwitch setOn:[self.wishDetail[@"is_cash"] boolValue]];
    else
        [cashCell.isCashSwitch setOn:NO];
}

- (void)buildPhotoCell:(UITableViewCell*)cell {

    PhotoCell* photoCell = (PhotoCell*)cell;
    if(![self.wishDetail[@"photo"] isKindOfClass:[NSNull class]]) {
        NSString* photoUrl = [NSString stringWithFormat:@"http://res.cloudinary.com/hew6ktdno/image/upload/c_fill,h_600,w_600/%@", self.wishDetail[@"photo"]];

        [photoCell.photoImageView setImageWithURL:[NSURL URLWithString:photoUrl]];
    } else {
        photoCell.photoImageView.image = nil;
    }
}

- (void)buildNotesCell:(UITableViewCell*)cell {

    NotesCell* noteCell = (NotesCell*)cell;
    if(![self.wishDetail[@"notes"] isKindOfClass:[NSNull class]]) {
        noteCell.notesTextView.text = self.wishDetail[@"notes"];
        noteCell.notesLabel.text = self.wishDetail[@"notes"];
    }
    else {
        noteCell.notesTextView.text = nil;
        noteCell.notesLabel.text = nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:
            [self editGiftTitle];
            break;
        case 2:
            [self editAmount];
            break;
        case 3:
            [self editStore];
            break;
        case 4:
            [self editItemUrl];
            break;
        case 5:
            [self editNotes];
            break;
        case 1:
        case 6:
        case 7:
            [tableView reloadData];
            break;
        default:
            break;
    }
}

- (void)editGiftTitle {

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"New gift title?"
                                message:self.wishDetail[@"gift"]
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"Cancel" action:^{
        // Handle "Cancel"
        
    }]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"Save" action:^{
        // Handle "Save"
        self.wishDetail[@"gift"] = [alertView textFieldAtIndex:0];
    }], nil];

    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    [alertView show];
}

- (void)editAmount {
    
}

- (void)editStore {
    
}


- (void)editItemUrl {

}

- (void)editNotes {
    
}

@end
