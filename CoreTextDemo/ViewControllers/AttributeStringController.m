//
//  AttributeStringController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/30.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "AttributeStringController.h"

@interface AttributeStringController (){
    UILabel *textLabel;
}

@end

@implementation AttributeStringController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initRightBarButton:@"action" action:@selector(clickedBtn:)];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 100, self.view.width - 10*2, self.view.height - 100);
    label.font = [UIFont systemFontOfSize:30];
    label.backgroundColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    textLabel = label;
}

- (void)clickedBtn:(id)sender{
    
    NSMutableAttributedString *mutlAttrStr = [[NSMutableAttributedString alloc] init];
    
    {
        NSString *content = @"Image Background Test";
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:content];
        
        CGSize size = CGSizeMake(20, 20);
        
        UIImage *image = [self imageWithSize:size drawBlock:^(CGContextRef context) {
            UIColor *c0 = [UIColor colorWithRed:0.054 green:0.879 blue:0.000 alpha:1.000];
            UIColor *c1 = [UIColor colorWithRed:0.869 green:1.000 blue:0.030 alpha:1.000];
            [c0 setFill];
            CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
            [c1 setStroke];
            CGContextSetLineWidth(context, 2);
            for (int i = 0; i < size.width * 2; i+= 4) {
                CGContextMoveToPoint(context, i, -2);
                CGContextAddLineToPoint(context, i - size.height, size.height + 2);
            }
            CGContextStrokePath(context);
        }];
        UIColor *imageColor = [UIColor colorWithPatternImage:image];
        
        NSDictionary *dic = @{NSForegroundColorAttributeName:(id)(imageColor)};
        
        [attributeStr setAttributes:dic range:NSMakeRange(0, attributeStr.length)];
        
        [mutlAttrStr appendAttributedString:attributeStr];
        
        textLabel.attributedText = mutlAttrStr;
    }
}

- (UIImage *)imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock {
    if (!drawBlock) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return nil;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
