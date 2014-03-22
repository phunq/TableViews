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
#import "Common.h"

@interface TableViewsVC () <UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITableView *_tbvViewerDetails;
    __weak IBOutlet UITableView *_tbvCommentList;
}

@end

//FIXME: A white space in the top of tableview

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
//    [_tbvViewerDetails.layer setBounds:CGRectMake(0, 0, 320 - 24, 219)];
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
        return 103.0;
    else if (indexPath.row == 1 || indexPath.row == 2)
        return 44.0;
    return 0;
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
            
            // work out the height of title
            
            // work out the y coordination of content
            
            // work out the
            
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
            
            [cell.lblContent setAttributesForTexts:array labelHighlightType:LabelHighlightTypeText withColor:[UIColor grayColor] touchToReturnSender:^(NSInteger sender, NSStringAttributesObject *object) {
                NSLog(@"tap on label!");
            }];
            
            return cell;
        }
    }
    
    return nil;
    
}

#pragma mark - Private methods

- (void)setDescriptionWithString:(NSString *)string withLabel: (LabelTextkit *)label
{
    
    CGSize size = [Common sizeOfString:string inFont:FONT_LATO_LIGHT(13.0) maxWidth:300];
    CGSize sizeHeightRow = [Common sizeOfString:@"gdGDkhgs" inFont:FONT_LATO_LIGHT(13.0) maxWidth:300];
    
    if (size.height> sizeHeightRow.height*5) {
        
        if (label.tag == 0) {
            
        NSString *endString = @"View more";
        NSString *shortenString = [Common shortenString:string withFrame:CGSizeMake(300, sizeHeightRow.height*5) withFont:FONT_LATO_LIGHT(13.0) andEndString:endString];
        
        UIFont *font = FONT_LATO_LIGHT(13.0);
        UIColor *color = [UIColor grayColor];
        NSStringAttributesObject *object = [[NSStringAttributesObject alloc] init];
        object.font = font;
        object.color = color;
        object.string = endString;
        object.isSelect = YES;
        NSArray *arr = @[object];
        
        label.text = [NSString stringWithFormat:@"%@... %@",shortenString,@"View more"];
        
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect rect = CGRectMake(0, 0, 320, 324);
//            _viewHeader.frame = rect;
//            [_tbvMain setTableHeaderView:_viewHeader];
//        }];
        
        [label setAttributesForTexts:arr labelHighlightType:LabelHighlightTypeBackground withColor:[UIColor lightGrayColor] touchToReturnSender:^(NSInteger sender, NSStringAttributesObject *object) {
            label.tag = 1;
            label.text = [NSString stringWithFormat:@"%@",string];
            CGSize sizeFull = [Common sizeOfString:string inFont:FONT_LATO_LIGHT(13.0) maxWidth:300];
            CGRect rectFull = CGRectMake(0, 0, 320, 244);
            rectFull.size.height += sizeFull.height + 5;
//            _viewHeader.frame = rectFull;
//
//            [UIView animateWithDuration:0.3 animations:^{
//                label.text = [NSString stringWithFormat:@"%@",string];
//
//                CGSize sizeFull = [Common sizeOfString:string inFont:FONT_LATO_LIGHT(13.0) maxWidth:300];
//                
//                CGRect rectFull = CGRectMake(0, 0, 320, 244);
//                rectFull.size.height += sizeFull.height + 5;
//                _viewHeader.frame = rectFull;
//                [_tbvMain setTableHeaderView:_viewHeader];
//                
//            }];
//
        }];
        } else if (label.tag == 1) {
            label.tag = 0;
        }
        
    }else {
//        if (_tbvMain && _viewHeader) {
            label.text = string;
//
//            [UIView animateWithDuration:0.3 animations:^{
//                CGRect rectNew = CGRectMake(0, 0, 320, 244);
//                
//                CGSize sizeNew = [Common sizeOfString:string inFont:FONT_LATO_LIGHT(13.0) maxWidth:300];
//                
//                rectNew.size.height += sizeNew.height + 5;
        
//                _viewHeader.frame = rectNew;
//                [_tbvMain setTableHeaderView:_viewHeader];
//            }];
//        }
    }
}

@end
