//
//  Common.h
//  TableViews
//
//  Created by Phu Nguyen on 3/21/14.
//  Copyright (c) 2014 Green Global. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FONT_LATO_REGULAR(s) [UIFont fontWithName:@"Lato-Regular" size:s]
#define FONT_LATO_LIGHT(s) [UIFont fontWithName:@"Lato-Light" size:s]

@interface Common : NSObject

+ (CGSize)sizeOfString:(NSString *)string inFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
+ (NSString *)shortenString:(NSString *)string withFrame:(CGSize)size withFont:(UIFont *)font andEndString:(NSString *)endString;
+ (BOOL)checkContaintSize:(CGSize)size ofString:(NSString *)string withFont:(UIFont *)font;

@end
