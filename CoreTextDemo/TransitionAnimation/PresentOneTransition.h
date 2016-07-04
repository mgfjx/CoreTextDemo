//
//  PresentOneTransition.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/4.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PresentOneTransitionType){
    PresentOneTransitionTypePresent = 0,
    PresentOneTransitionTypeDismiss
};

@interface PresentOneTransition : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(PresentOneTransitionType)type;
- (instancetype)initWithTansitionType:(PresentOneTransitionType)type;

@end
