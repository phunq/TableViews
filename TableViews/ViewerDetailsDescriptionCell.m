//
//  ViewerDetailsDescriptionCell.m
//  TableViews
//
//  Created by Phu Nguyen on 3/21/14.
//  Copyright (c) 2014 Green Global. All rights reserved.
//

#import "ViewerDetailsDescriptionCell.h"

@implementation ViewerDetailsDescriptionCell

- (void)awakeFromNib
{
    // Initialization code
    
    _lblTitle.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    _lblContent.font = [UIFont fontWithName:@"Lato-Light" size:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
