//
//  ViewerDetailsDescriptionCell.m
//  TableViews
//
//  Created by Phu Nguyen on 3/21/14.
//  Copyright (c) 2014 Green Global. All rights reserved.
//

#import "ViewerDetailsDescriptionCell.h"
#import "LabelTextkit.h"
#import "Common.h"

@implementation ViewerDetailsDescriptionCell

- (void)awakeFromNib
{
    // Initialization code
    _lblTitle.font = FONT_LATO_BOLD(14.0);
//    _lblTitle.font = [UIFont fontWithName:@"Lato-Bold" size:14];
//    _lblContent.font = [UIFont fontWithName:@"Lato-Light" size:13];
//    _lblContent.font = FONT_LATO_LIGHT(13.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
