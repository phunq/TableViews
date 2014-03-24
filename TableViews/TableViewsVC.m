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

#define MAX_WIDTH 286
#define FULL_TEXT @"By some measures, Google's Go programming language is a non-factor in development. Google Trends, which measures general interest in a search term, hardly registers a blip for Go compared to more established programming languages like Java, C++ and JavaScript."
#define TITLE_TEXT @"The following sections help you to get started with blocks using practical examples."

@interface TableViewsVC () <UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITableView *_tbvViewerDetails;
    __weak IBOutlet UITableView *_tbvCommentList;
    
    BOOL _isViewedMore;
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
    
    _isViewedMore = NO;
    
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
    if (indexPath.row == 0) {

        CGSize singleLineSize = [Common sizeOfString:@"hello hello" inFont:FONT_LATO_LIGHT(13.0) maxWidth:MAX_WIDTH];
        CGSize fullTextSize = [Common sizeOfString:FULL_TEXT inFont:FONT_LATO_LIGHT(13.0) maxWidth:MAX_WIDTH];
        int numberOfLines = ceil(fullTextSize.height/singleLineSize.height);
        
        CGSize singleTitleLineSize = [Common sizeOfString:@"hello hello" inFont:FONT_LATO_BOLD(14.0) maxWidth:MAX_WIDTH];
        CGSize fullTitleTextSize = [Common sizeOfString:TITLE_TEXT inFont:FONT_LATO_BOLD(14.0) maxWidth:MAX_WIDTH];
        int numberOfTitleLines = ceil(fullTitleTextSize.height/singleTitleLineSize.height);
        int titleHeight = numberOfTitleLines * singleTitleLineSize.height;
        
        NSLog(@"cell height: %f", titleHeight + singleLineSize.height * 5);
        
        if (!_isViewedMore)
            return titleHeight + singleLineSize.height * 5;
        else
            return titleHeight + singleLineSize.height * (numberOfLines + 1);
        
        
    }
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
            
            CGSize singleTitleLineSize = [Common sizeOfString:@"hello hello" inFont:FONT_LATO_BOLD(14.0) maxWidth:MAX_WIDTH];
            CGSize fullTitleTextSize = [Common sizeOfString:TITLE_TEXT inFont:FONT_LATO_BOLD(14.0) maxWidth:MAX_WIDTH];
            int numberOfTitleLines = ceil(fullTitleTextSize.height/singleTitleLineSize.height);
            
            // adjust the height of the cell
            CGRect labelFrame = cell.lblTitle.frame;
            labelFrame.size.height = (singleTitleLineSize.height + 2) * numberOfTitleLines;
            cell.lblTitle.frame = labelFrame;
            
            cell.lblTitle.text = TITLE_TEXT;
            
            [self setDescriptionWithString:FULL_TEXT withLabel:cell];
            
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
                NSLog(@"tap on label 2!");
            }];
            
            return cell;
        }
    }
    
    return nil;
    
}

#pragma mark - Private methods

//- (void)setDescriptionWithString:(NSString *)string withLabel: (LabelTextkit *)lblContent
- (void)setDescriptionWithString:(NSString *)string withLabel: (ViewerDetailsDescriptionCell *)cell
{
    LabelTextkit *lblContent = cell.lblContent;
    
    int separatorY = 0;

    // work out the number of rows
    CGSize singleLineSize = [Common sizeOfString:@"hello hello" inFont:FONT_LATO_LIGHT(13.0) maxWidth:MAX_WIDTH];
    CGSize fullTextSize = [Common sizeOfString:FULL_TEXT inFont:FONT_LATO_LIGHT(13.0) maxWidth:MAX_WIDTH];
    int numberOfLines = ceil(fullTextSize.height/singleLineSize.height);
    NSString *shortenString = @"";
    
    if (numberOfLines > 4) {        // if number of rows is greater than default
        // get the custom string
        if (_isViewedMore == NO) {
            shortenString = [Common shortenString:FULL_TEXT withFrame:CGSizeMake(MAX_WIDTH, singleLineSize.height * 5) withFont:FONT_LATO_LIGHT(13.0) andEndString:@"View more"];
            
            // adjust the height of the cell
            CGRect labelFrame = lblContent.frame;
            labelFrame.origin.y = cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height;
            labelFrame.size.height = singleLineSize.height * 5 - 5;
            lblContent.frame = labelFrame;
            
            // set attributes for custom string
            NSStringAttributesObject *nameObject1 = [[NSStringAttributesObject alloc] init];
            nameObject1.font = FONT_LATO_LIGHT(13.0);
            nameObject1.color = [UIColor blackColor];
            nameObject1.string = shortenString;
            nameObject1.isSelect = NO;
            
            NSStringAttributesObject *nameObject2 = [[NSStringAttributesObject alloc] init];
            nameObject2.font = FONT_LATO_LIGHT(13.0);
            nameObject2.color = [UIColor lightGrayColor];
            nameObject2.string = @"View more";
            nameObject2.isSelect = YES;
            
            NSArray *array = [NSArray arrayWithObjects:nameObject1, nameObject2, nil];
            lblContent.text = [NSString stringWithFormat:@"%@... %@", shortenString, @"View more"];
//            __weak TableViewsVC *myClass = self;
            
            [lblContent setAttributesForTexts:array labelHighlightType:LabelHighlightTypeText withColor:[UIColor blackColor] touchToReturnSender:^(NSInteger sender, NSStringAttributesObject *object) {
                
                if (_isViewedMore == NO) {
                    _isViewedMore = YES;
                }
                
//                [myClass setDescriptionWithString:FULL_TEXT withLabel:lblContent];
                [_tbvViewerDetails reloadData];
                
            }];
            
            separatorY = cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height + singleLineSize.height * 5 - 1;
            CGRect separatorFrame = cell.separatorView.frame;
            separatorFrame.origin.y = separatorY;
            cell.separatorView.frame = separatorFrame;
            
            NSLog(@"separator y: %d", separatorY);
            
        } else {
            
            shortenString = FULL_TEXT;
            
            // adjust the height of the cell
            CGRect labelFrame = lblContent.frame;
            labelFrame.origin.y = cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height;
            labelFrame.size.height = singleLineSize.height * (numberOfLines + 1) - 5;
            lblContent.frame = labelFrame;
            
            lblContent.font = FONT_LATO_LIGHT(13.0);
            lblContent.text = [NSString stringWithFormat:@"%@", shortenString];
            
            separatorY = 28 + singleLineSize.height * (numberOfLines + 1) - 1;
            CGRect separatorFrame = cell.separatorView.frame;
            separatorFrame.origin.y = separatorY;
            cell.separatorView.frame = separatorFrame;
        }
        
        
        
    } else {        // number of lines
        
        // adjust the height of the cell
        CGRect labelFrame = lblContent.frame;
        labelFrame.origin.y = cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height;
        labelFrame.size.height = singleLineSize.height * (numberOfLines + 1) - 5;
        lblContent.frame = labelFrame;
        
        lblContent.font = FONT_LATO_LIGHT(13.0);
        lblContent.text = FULL_TEXT;
        
        separatorY = 28 + singleLineSize.height * (numberOfLines + 1) - 1;
        CGRect separatorFrame = cell.separatorView.frame;
        separatorFrame.origin.y = separatorY;
        cell.separatorView.frame = separatorFrame;
        
    }
    
    
    
}

@end
