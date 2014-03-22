//
//  FormatsNSStringAttribute.m
//  YouLook
//
//  Created by phungduythien on 12/12/13.
//  Copyright (c) 2013 TienLP. All rights reserved.
//

#import "FormatsNSStringAttribute.h"
#import "Common.h"

@implementation FormatsNSStringAttribute

+ (NSStringAttributesObject *)getStringFormatWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font shadow:(NSShadow *)shadow andObjectId:(NSString *)objectId
{
    NSStringAttributesObject *object = [[NSStringAttributesObject alloc] init];
    object.font = font;
    object.color = color;
    object.string = string;
    object.shadow = shadow;
    object.objectId = objectId;
    
    return object;
}

+ (NSStringAttributesObject *)getStringFormatForTapableLabel: (NSString *)string withObjectId: (NSString *)objectID {
    UIFont *font = FONT_LATO_REGULAR(12);
//    UIColor *color = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIColor *color = [UIColor blueColor];
    
    NSStringAttributesObject *object = [[NSStringAttributesObject alloc] init];
    object.font = font;
    object.color = color;
    object.string = string;
    object.isSelect = YES;
    object.objectId = objectID;
    
    return object;
}

+ (NSStringAttributesObject *)getStringFormatForUsername:(NSString *)string andObjectId:(NSString *)objectId
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    UIColor *color = [UIColor colorWithRed:60/255.0 green:86/255.0 blue:146/255.0 alpha:1.0];
    
    NSStringAttributesObject *object = [[NSStringAttributesObject alloc] init];
    object.font = font;
    object.color = color;
    object.string = string;
    object.isSelect = YES;
    object.objectId = objectId;
    
    return object;
}

+ (NSStringAttributesObject *)getStringFormatForMessage:(NSString *)string
{
    UIFont *font = [UIFont systemFontOfSize:12];
    UIColor *color = [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1.0];
    
    NSStringAttributesObject *object = [[NSStringAttributesObject alloc] init];
    object.font = font;
    object.color = color;
    object.string = string;
    object.isSelect = NO;
    
    
    return object;
}

+ (NSStringAttributesObject *)getStringFormatForForObjectName:(NSString *)string andObjectId:(NSString *)objectId
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    UIColor *color = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
    
    NSStringAttributesObject *object = [[NSStringAttributesObject alloc] init];
    object.font = font;
    object.color = color;
    object.string = string;
    if (objectId != nil) {
        object.isSelect = NO;
        object.objectId = objectId;
    }else {
        object.isSelect = NO;
    }
    
    
    return object;
}

@end
