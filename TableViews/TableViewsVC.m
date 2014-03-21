//
//  TableViewsVC.m
//  TableViews
//
//  Created by Phu Nguyen on 3/21/14.
//  Copyright (c) 2014 Green Global. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TableViewsVC.h"
#import "ViewerDetailsDescriptionCell.h"
#import "ViewerDetailsMoreInfoCell.h"
#import "LabelTextkit.h"
#import "FormatsNSStringAttribute.h"

@interface TableViewsVC () <UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITableView *_tbvViewerDetails;
    __weak IBOutlet UITableView *_tbvCommentList;
}

@end

@implementation TableViewsVC

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
    // Do any additional setup after loading the view from its nib.
    
    [_tbvViewerDetails.layer setMasksToBounds:YES];
    [_tbvViewerDetails.layer setCornerRadius:5.0];
    [_tbvViewerDetails.layer setBorderColor: [UIColor lightGrayColor].CGColor];
    [_tbvViewerDetails.layer setBorderWidth:1.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 88.0;
//    else if (indexPath.row == 1 || indexPath.row == 2)
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tbvViewerDetails) {
        if (indexPath.row == 0) {
            
            static NSString *detailsCellIdentifier = @"ViewerDetailsDescriptionCell";
            ViewerDetailsDescriptionCell *cell = (ViewerDetailsDescriptionCell *) [tableView dequeueReusableCellWithIdentifier:detailsCellIdentifier];
            if (cell == nil) {
                // Load the top-level objects from the custom cell XIB.
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:detailsCellIdentifier owner:self options:nil];
                NSLog(@"top level objects: %@", topLevelObjects);
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            return cell;
        } else if (indexPath.row == 1 || indexPath.row == 2) {
            
            static NSString *moreInfoCellIdentifier = @"ViewerDetailsMoreInfoCell";
            ViewerDetailsMoreInfoCell *cell = (ViewerDetailsMoreInfoCell *) [tableView dequeueReusableCellWithIdentifier:moreInfoCellIdentifier];
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:moreInfoCellIdentifier owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            NSStringAttributesObject *nameObject = [FormatsNSStringAttribute getStringFormatForTapableLabel:@"San Francisco, CA" withObjectId:nil];
            NSArray *array = [NSArray arrayWithObject:nameObject];
            
            [cell.lblContent setAttributesForTexts:array labelHighlightType:LabelHighlightTypeText withColor:[UIColor blueColor] touchToReturnSender:^(NSInteger sender, NSStringAttributesObject *object) {
                NSLog(@"tap on label!");
            }];
            
            return cell;
        }
    }
    
    return nil;
    
}

@end
