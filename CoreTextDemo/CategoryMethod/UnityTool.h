//
//  UnityTool.h
//  CoreTextDemo
//
//  Created by xiexiaolong on 16/7/10.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimeOutCallBack)();
typedef void(^TimeCountCallBack)(int timeLeft);

@interface UnityTool : NSObject

+ (void)countDownWithTime:(NSTimeInterval)time timeOutCallBack:(TimeOutCallBack) timeOutCallBack timeCountCallBack:(TimeCountCallBack) timeCountCallBack;

@end
