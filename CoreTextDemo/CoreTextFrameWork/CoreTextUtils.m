//
//  Utils.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/29.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CoreTextUtils.h"

@implementation CoreTextUtils

+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data{
    
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) {
        return nil;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    CoreTextLinkData *foundLink = nil;
    
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    //翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1, -1);
    
    for (int i = 0; i < count; i++) {
        
        CGPoint lineOrigin = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flipppedRect = [self getLineBounds:line point:lineOrigin];
        CGRect rect = CGRectApplyAffineTransform(flipppedRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            CFIndex offset = CTLineGetStringIndexForPosition(line, relativePoint);
            
            foundLink = [self linkAtIndex:offset linkArray:data.linkArray];
            
            return foundLink;
        }
        
    }
    
    return nil;
}

+ (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point{
    
    CGFloat ascent = 0;
    CGFloat descent = 0;
    CGFloat leading = 0;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    
    CGRect rect = CGRectMake(point.x, point.y - descent, width, height);
    
    return rect;
}

+ (CoreTextLinkData *)linkAtIndex:(CFIndex)index linkArray:(NSArray *)linkArray{
    
    CoreTextLinkData *link = nil;
    for (CoreTextLinkData *data in linkArray) {
        if (NSLocationInRange(index, data.range)) {
            link = data;
            break;
        }
    }
    
    return link;
}

@end
