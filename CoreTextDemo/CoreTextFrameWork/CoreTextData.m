//
//  CoreTextData.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/28.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CoreTextData.h"
#import "CoreTextImageData.h"

@implementation CoreTextData

- (void)setCtFrame:(CTFrameRef)ctFrame{
    if (ctFrame != _ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)dealloc{
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    [self fillImagePosition];
}

- (void)fillImagePosition{
    
    if (self.imageArray.count == 0) {
        return;
    }
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    NSInteger lineCount = lines.count;
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imageIndex = 0;
    
    CoreTextImageData *imageData = self.imageArray[0];
    for(int i = 0; i < lineCount; i++){
        if (imageData == nil) {
            break;
        }
        
        CTLineRef line = (__bridge CTLineRef)(lines[i]);
        NSArray *glyphRuns = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in glyphRuns) {
            CTRunRef run = (__bridge CTRunRef)(runObj);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)([runAttributes objectForKey:(id)kCTRunDelegateAttributeName]);
            if (delegate == nil) {
                continue;
            }
            
            NSDictionary *refDict = (NSDictionary *)CTRunDelegateGetRefCon(delegate);
            if (![refDict isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef path = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(path);
            
            CGRect delegateRect = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            imageData.imagePosition = delegateRect;
            imageIndex ++;
            
            if (imageIndex == self.imageArray.count) {
                imageData = nil;
                break;
            }else{
                imageData = self.imageArray[imageIndex];
            }
            
        }
        
    }
    
}

@end

















