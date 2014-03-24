//
//  Common.m
//  TableViews
//
//  Created by Phu Nguyen on 3/22/14.
//  Copyright (c) 2014 Green Global. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (CGSize)sizeOfString:(NSString *)string inFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    CGSize size = [string sizeWithFont:font
                     constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

+ (NSString *)shortenString:(NSString *)string withFrame:(CGSize)size withFont:(UIFont *)font andEndString:(NSString *)endString
{
    NSString *stringShorten = nil;
    NSMutableString *subString = [NSMutableString stringWithString:@""];
    NSArray *arr = [string componentsSeparatedByString:@" "];
    for (int i = 0; i < arr.count; i++) {
        [subString appendString:[NSString stringWithFormat:@"%@%@",subString.length?@" ":@"",arr[i]]];
//        NSString *stringCheck = [NSString stringWithFormat:@"%@ %@       ",subString,endString];
        NSString *stringCheck = [NSString stringWithFormat:@"%@... %@",subString,endString];
        if ([self checkContaintSize:size ofString:stringCheck withFont:font]) {
            stringShorten = [NSString stringWithFormat:@"%@",subString];
            
        }else {
            return stringShorten;
            
        }
    }
    return string;
}

+ (BOOL)checkContaintSize:(CGSize)size ofString:(NSString *)string withFont:(UIFont *)font
{
    CGSize sizeString = [self sizeOfString:string inFont:font maxWidth:size.width];
    if (size.height > sizeString.height) {
        return YES;
    }
    
    return NO;
}

@end
