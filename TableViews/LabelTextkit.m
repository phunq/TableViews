//
//  LabelTextkit.m
//  DemoTextKit
//
//  Created by phungduythien on 2013-12-12.
//  Copyright (c) 2013 phungduythien. All rights reserved.
//

#import "LabelTextkit.h"
#import <CoreText/CoreText.h>
//#import "Define.h"

@implementation NSStringAttributesObject



@end

@interface LabelTextkit ()

@property(nonatomic, strong) NSSet* lastTouches;
@property(nonatomic, assign) LabelHighlightType labelHighlightType;
@property(nonatomic, strong) TouchReturnBlock   touchReturnBlock;
@property(nonatomic, strong) NSArray            *arrayString;
@property(nonatomic, strong) NSMutableArray     *matches;
@property(nonatomic, strong) UIColor            *colorHighlight;

@property(nonatomic) NSRange highlightedRange;

- (BOOL)didBeginTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex;
- (BOOL)didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex;
- (BOOL)didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex;
- (BOOL)didCancelTouch:(UITouch *)touch;

@end



@implementation LabelTextkit

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point {
    
    ////////
    
    NSMutableAttributedString* optimizedAttributedText = [self.attributedText mutableCopy];
    
    // use label's font and lineBreakMode properties in case the attributedText does not contain such attributes
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, [self.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        //NSLog(@"attrs:%@",attrs);
        
        if (!attrs[(NSString*)kCTFontAttributeName]) {
            
            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:self.font range:NSMakeRange(0, [self.attributedText length])];
        }
        
        if (!attrs[(NSString*)kCTParagraphStyleAttributeName]) {
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:self.lineBreakMode];
            
            [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }];
    
    // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
    [optimizedAttributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
        
        if ([paragraphStyle lineBreakMode] == kCTLineBreakByTruncatingTail) {
            [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        }
        
        [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
        [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
    }];
    
    
    
    ////////
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRect];
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    //////
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    NSLog(@"num lines: %d", numberOfLines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    NSLog(@"characterIndexAtPoint:%d",idx);
    return idx;
}

#pragma mark --

- (CGRect)textRect {
    
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height)/2;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width)/2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    
    return textRect;
}


#pragma mark --

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.lastTouches = touches;
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    
    if (![self didBeginTouch:touch onCharacterAtIndex:index]) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.lastTouches = touches;
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    
    if (![self didMoveTouch:touch onCharacterAtIndex:index]) {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.lastTouches) {
        return;
    }
    
    self.lastTouches = nil;
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    
    
    if (![self didEndTouch:touch onCharacterAtIndex:index]) {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.lastTouches) {
        return;
    }
    
    self.lastTouches = nil;
    
    UITouch *touch = [touches anyObject];
    
    if (![self didCancelTouch:touch]) {
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)cancelCurrentTouch {
    
    if (self.lastTouches) {
        [self didCancelTouch:[self.lastTouches anyObject]];
        self.lastTouches = nil;
    }
}

#pragma mark -
#pragma mark Methods handle

- (BOOL)didBeginTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex
{
    
    if (_labelHighlightType == LabelHighlightTypeBackground) {
        
        [self highlightBackgroundWithIndex:charIndex];
        
    }else if (_labelHighlightType == LabelHighlightTypeText) {
        
        [self highlightLinksWithIndex:charIndex];
        
    }else if (_labelHighlightType == LabelHighlightTypeNone) {
//        [self highlightLinksWithIndex:NSNotFound];
    }
    
    return NO;
}

- (BOOL)didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex
{
    
    if (_labelHighlightType == LabelHighlightTypeBackground) {
        
        [self highlightBackgroundWithIndex:charIndex];
        
    }else if (_labelHighlightType == LabelHighlightTypeText) {
        
        [self highlightLinksWithIndex:charIndex];
        
    }else if (_labelHighlightType == LabelHighlightTypeNone) {
//        [self highlightLinksWithIndex:NSNotFound];
    }
    
    return NO;
}

- (BOOL)didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex
{
    if (_labelHighlightType == LabelHighlightTypeBackground) {
        
        [self highlightBackgroundWithIndex:NSNotFound];
        
        for (int i = 0 ; i < self.matches.count; i++) {
            
            NSStringAttributesObject *obj = _arrayString[i];
            NSValue *value = self.matches[i];
            
            if (obj.isSelect) {
                
                NSRange matchRange = [value rangeValue];
                
                if ([self isIndex:charIndex inRange:matchRange]) {
                    
                    //NSLog(@"charIndex: %d",i);
                    self.touchReturnBlock(i,obj);
                    break;
                }
            }
        }
        
    }else if (_labelHighlightType == LabelHighlightTypeText) {
        
        [self highlightLinksWithIndex:NSNotFound];
        
        for (int i = 0 ; i < self.matches.count; i++) {
            
            NSStringAttributesObject *obj = _arrayString[i];
            
            if (obj.isSelect) {
                
                NSValue *value = self.matches[i];
                NSRange matchRange = [value rangeValue];
                //NSLog(@"charIndex before: %d matchRange:%@",i,NSStringFromRange(matchRange));
                if ([self isIndex:charIndex inRange:matchRange]) {
                    //NSLog(@"charIndex after: %d",i);
                    self.touchReturnBlock(i,obj);
                    break;
                }
            }
        }
        
    }else if (_labelHighlightType == LabelHighlightTypeNone) {
//        [self highlightLinksWithIndex:NSNotFound];
    }
    
    return NO;
}


- (BOOL)didCancelTouch:(UITouch *)touch
{
    if (_labelHighlightType == LabelHighlightTypeBackground) {
        
        [self highlightBackgroundWithIndex:NSNotFound];
        
    }else if (_labelHighlightType == LabelHighlightTypeText) {
        
        [self highlightLinksWithIndex:NSNotFound];
        
    }else if (_labelHighlightType == LabelHighlightTypeNone) {
//        [self highlightLinksWithIndex:NSNotFound];
    }
    return NO;
}

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
    return index > range.location && index < range.location+range.length;
}

- (void)highlightLinksWithIndex:(CFIndex)index {
    
    NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
    
    for (int i = 0 ; i < self.matches.count; i++) {
        
        NSStringAttributesObject *obj = _arrayString[i];
        
        NSValue *value = self.matches[i];
        NSRange matchRange = [value rangeValue];
        
        if (obj.isSelect) {
            if ([self isIndex:index inRange:matchRange]) {
                
                [attributedString addAttribute:NSForegroundColorAttributeName value:_colorHighlight range:matchRange];
            }
            else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:obj.color range:matchRange];
            }

        }
        
    }
    
    self.attributedText = attributedString;
}

- (void)highlightBackgroundWithIndex:(CFIndex)index {
    
    NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
    
    for (int i = 0 ; i < self.matches.count; i++) {
        
        NSStringAttributesObject *obj = _arrayString[i];
        
        NSValue *value = self.matches[i];
        NSRange matchRange = [value rangeValue];
        
        if (obj.isSelect) {
            if ([self isIndex:index inRange:matchRange]) {
                
                [attributedString addAttribute:NSBackgroundColorAttributeName value:_colorHighlight range:matchRange];
            }
            else {
                [attributedString removeAttribute:NSBackgroundColorAttributeName range:matchRange];
            }
            
        }
        
    }
    
    self.attributedText = attributedString;
}

- (void)makeAttributes
{
    if (self.matches) {
        self.matches = nil;
    }
    self.matches = [NSMutableArray array];
    
    if (self.labelHighlightType == LabelHighlightTypeText) {
//        NSLog(@"self.arrayString:%d",self.arrayString.count);
    }
    NSMutableAttributedString* mutableString = [self.attributedText mutableCopy];
    
    
//    NSLog(@"begin makeAttributesAndNSRangWithArrString:%d",_arrayString.count);
    for (int i = 0; i < _arrayString.count; i++) {
        
        __block NSRange rangeResult;
        NSStringAttributesObject *object = _arrayString[i];
        
        NSString *pattern = object.string;
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        //  enumerate matches
        NSRange range = NSMakeRange(0,[self.text length]);
//        NSLog(@"enumeratematches:%d",i);
        [expression enumerateMatchesInString:self.text options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            rangeResult = [result rangeAtIndex:0];
            NSLog(@"i:%d range:%@",i,NSStringFromRange(rangeResult));
            
        }];
        
        [self.matches addObject:[NSValue valueWithRange:rangeResult]];
        [mutableString addAttribute:NSForegroundColorAttributeName value:object.color range:rangeResult];
        [mutableString addAttribute:NSFontAttributeName value:object.font range:rangeResult];
        
    }
    
    //NSLog(@"end makeAttributesAndNSRangWithArrString:matches%d  arrstring:%d",_matches.count, _arrayString.count);
   
    self.attributedText = mutableString;
    
}

#pragma mark - 
#pragma mark Methods Public

- (void)setAttributesTextWithArrayText:(NSArray *)array
{
    self.arrayString = array;
    self.labelHighlightType = LabelHighlightTypeNone;
    //set text with array object
    NSStringAttributesObject *obj = array[0];
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",obj.string];
    for (int i = 1; i < array.count; i++) {
        NSStringAttributesObject *obj = array[i];
        [string appendString:[NSString stringWithFormat:@" %@",obj.string]];
    }
    self.text = string;
    //---end---
    
    [self makeAttributes];
}

- (void)setAttributesTextWithArrayText:(NSArray *)array labelHighlightType:(LabelHighlightType)labelHighlightType withColor:(UIColor *)color touchToReturnSender:(TouchReturnBlock)sender
{
    self.touchReturnBlock = sender;
    self.labelHighlightType = labelHighlightType;
    self.arrayString = array;
    self.colorHighlight = color;
    //set text with array object
    NSStringAttributesObject *obj = array[0];
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",obj.string];
    for (int i = 1; i < array.count; i++) {
        NSStringAttributesObject *obj = array[i];
        [string appendString:[NSString stringWithFormat:@" %@",obj.string]];
    }
    self.text = string;
    //---end---
    
    [self makeAttributes];
}

- (void)setAttributesForTexts:(NSArray *)array labelHighlightType:(LabelHighlightType)labelHighlightType withColor:(UIColor *)color touchToReturnSender:(TouchReturnBlock)sender
{
    self.touchReturnBlock = sender;
    self.labelHighlightType = labelHighlightType;
    self.arrayString = array;
    self.colorHighlight = color;
    
    [self makeAttributes];
}

- (void)setAgainAttributesText:(NSArray *)array
{
    self.arrayString = array;
    self.labelHighlightType = self.labelHighlightType;
    
    [self makeAttributes];
}


@end

