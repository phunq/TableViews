//
//  ViewerDetailsDescriptionCell.h
//  TableViews
//
//  Created by Phu Nguyen on 3/21/14.
//  Copyright (c) 2014 Green Global. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LabelTextkit;
@interface ViewerDetailsDescriptionCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet LabelTextkit *lblContent;
@property (nonatomic, weak) IBOutlet UIView *separatorView;

@end
