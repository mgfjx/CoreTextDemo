//
//  UIColor+Hex.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/6.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
/**
 @param hexString   NSString e.g:@"0xFC5B13"
 @param alpha		alhpa
 */
+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (instancetype)colorWithHexString:(NSString *)hexString;

@end
