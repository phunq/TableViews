//
//  LabelTextkit.h
//  DemoTextKit
//
//  Created by phungduythien on 2013-12-12.
//  Copyright (c) 2013 phungduythien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSStringAttributesObject : NSObject

@property (nonatomic, strong) UIFont    *font;
@property (nonatomic, strong) UIColor   *color;
@property (nonatomic, strong) NSShadow  *shadow;
@property (nonatomic, strong) NSString  *string;
@property (nonatomic, strong) NSString  *objectId;

@property (nonatomic, assign) BOOL      isSelect;

@end



typedef enum {
    LabelHighlightTypeNone,
    LabelHighlightTypeBackground,
    LabelHighlightTypeText,
    
}LabelHighlightType;

typedef void (^TouchReturnBlock)(NSInteger sender, NSStringAttributesObject *object);

@interface LabelTextkit : UILabel

- (void)setAttributesTextWithArrayText:(NSArray *)array;
- (void)setAttributesTextWithArrayText:(NSArray *)array labelHighlightType:(LabelHighlightType)labelHighlightType withColor:(UIColor *)color touchToReturnSender:(TouchReturnBlock)sender;
/*How to use methods 'setAttributesTextWithArrayText'
    1.NSArray *arr = @[object1,object2,object3];
    2.LabelTextkit.text = [NSString stringWithFormat:@"%@ %@ %@",object1.string,object2.string,object3.string];
    3.[LabelTextkit setAttributesTextWithArrayText:arr];
*/

/*
 Only set attributes for text, and dont set text string
 */
- (void)setAttributesForTexts:(NSArray *)array labelHighlightType:(LabelHighlightType)labelHighlightType withColor:(UIColor *)color touchToReturnSender:(TouchReturnBlock)sender;
- (void)setAgainAttributesText:(NSArray *)array;

@end
