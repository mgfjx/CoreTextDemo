//
//  CTDisplayView.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/28.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreTextImageData.h"

@implementation CTDisplayView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    if (self.coreTextData) {
        CTFrameDraw(self.coreTextData.ctFrame, context);
        for (CoreTextImageData *data in self.coreTextData.imageArray) {
            UIImage *image = [UIImage imageNamed:data.name];
            CGContextDrawImage(context, data.imagePosition, image.CGImage);
        }
    }
    
}

@end
