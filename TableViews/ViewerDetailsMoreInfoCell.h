//
//  ViewerDetailsMoreInfoCell.h
//  TableViews
//
//  Created by Phu Nguyen on 3/21/14.
//  Copyright (c) 2014 Green Global. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LabelTextkit;
@interface ViewerDetailsMoreInfoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imvIcon;
@property (nonatomic, weak) IBOutlet LabelTextkit *lblContent;

@end
