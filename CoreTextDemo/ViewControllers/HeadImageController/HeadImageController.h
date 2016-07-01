//
//  HeadImageController.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/1.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ScreenShotCallBack)(UIImage *image);

@interface HeadImageController : UIViewController

+ (void)initWithImage:(UIImage *)image owner:(UIViewController *)controller screenShotCallBack:(ScreenShotCallBack)callBack;

@end
