//
//  FormatsNSStringAttribute.h
//  YouLook
//
//  Created by phungduythien on 12/12/13.
//  Copyright (c) 2013 TienLP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LabelTextkit.h"

@interface FormatsNSStringAttribute : NSObject

+ (NSStringAttributesObject *)getStringFormatWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font shadow:(NSShadow *)shadow andObjectId:(NSString *)objectId;
+ (NSStringAttributesObject *)getStringFormatForTapableLabel: (NSString *)string withObjectId: (NSString *)objectID;
+ (NSStringAttributesObject *)getStringFormatForUsername:(NSString *)string andObjectId:(NSString *)objectId;
+ (NSStringAttributesObject *)getStringFormatForMessage:(NSString *)string;
+ (NSStringAttributesObject *)getStringFormatForForObjectName:(NSString *)string andObjectId:(NSString *)objectId;



@end
