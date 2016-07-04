//
//  InteractiveTransition.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/4.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GestureConfig)();

typedef NS_ENUM(NSInteger, InteractiveTransitionGestureDirection) {//gesture direction
    InteractiveTransitionGestureDirectionLeft = 0,
    InteractiveTransitionGestureDirectionRight ,
    InteractiveTransitionGestureDirectionUp,
    InteractiveTransitionGestureDirectionDown
};

typedef NS_ENUM(NSInteger, InteractiveTransitionType){
    InteractiveTransitionTypePresent = 0,
    InteractiveTransitionTypeDismiss,
    InteractiveTransitionTypePush,
    InteractiveTransitionTypePop
};

@interface InteractiveTransition : UIPercentDrivenInteractiveTransition

/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interaction;
/**促发手势present的时候的config，config中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) GestureConfig presentConifg;
/**促发手势push的时候的config，config中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) GestureConfig pushConifg;

+ (instancetype)interactiveTransitionWithTransitionType:(InteractiveTransitionType)type gesturDirection:(InteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(InteractiveTransitionType)type gesturDirection:(InteractiveTransitionGestureDirection)direction;

- (void)addPanGestureForViewController:(UIViewController *)viewController;
- (void)addSwipeGestureForViewController:(UIViewController *)viewController direction:(UISwipeGestureRecognizerDirection)direction;

@end
