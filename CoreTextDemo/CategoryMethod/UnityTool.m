//
//  UnityTool.m
//  CoreTextDemo
//
//  Created by xiexiaolong on 16/7/10.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "UnityTool.h"

@implementation UnityTool



+ (void)countDownWithTime:(NSTimeInterval)time timeOutCallBack:(void (^)())timeOutCallBack timeCountCallBack:(void (^)(int timeLeft))timeCountCallBack{
    
    __block int timeOut = time;//倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                timeOutCallBack();
            });
        }else{
            
            int seconds = timeOut % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                timeCountCallBack(seconds);
                
            });
            
            timeOut--;
            
        }
        
    });
    
    dispatch_resume(_timer);
    
}



@end
