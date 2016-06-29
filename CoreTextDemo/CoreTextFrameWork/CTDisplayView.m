//
//  CTDisplayView.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/28.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreTextImageData.h"

@interface CTDisplayView()<UIGestureRecognizerDelegate>

@end

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

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupEvents];
        
    }
    return self;
}

- (void)setupEvents{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDetected:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recgnizer{
    
    CGPoint point = [recgnizer locationInView:self];
    for (CoreTextImageData *imageData in self.coreTextData.imageArray) {
        //翻转坐标系，因为imageData中的坐标是Coretext坐标
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        
        if (CGRectContainsPoint(rect, point)) {
            NSLog(@"image clicked");
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_IMAGECLICK object:nil userInfo:@{@"imageName":imageData.name}];
            break;
        }
        
    }
    
}

@end
























