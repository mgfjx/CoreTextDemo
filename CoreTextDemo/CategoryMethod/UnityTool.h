//
//  UnityTool.h
//  CoreTextDemo
//
//  Created by xiexiaolong on 16/7/10.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnityTool : NSObject

+ (void)countDownWithTime:(NSTimeInterval)time timeOutCallBack:(void (^)()) timeOutCallBack timeCountCallBack:(void (^)(int timeLeft)) timeCountCallBack;

@end
