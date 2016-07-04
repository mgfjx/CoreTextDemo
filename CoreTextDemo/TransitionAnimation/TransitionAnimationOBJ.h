//
//  TransitionAnimationOBJ.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/4.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TransitionAnimationOBJType){
    TransitionAnimationOBJTypePresent = 0,
    TransitionAnimationOBJTypeDismiss
};

@interface TransitionAnimationOBJ : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithType:(TransitionAnimationOBJType)type;
- (instancetype)initWithType:(TransitionAnimationOBJType)type;

@end
