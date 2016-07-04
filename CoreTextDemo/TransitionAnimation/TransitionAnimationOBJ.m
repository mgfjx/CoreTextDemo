//
//  TransitionAnimationOBJ.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/4.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "TransitionAnimationOBJ.h"

@interface TransitionAnimationOBJ()

@property (nonatomic, assign) TransitionAnimationOBJType type;

@end

@implementation TransitionAnimationOBJ

#pragma mark - inital
+ (instancetype)transitionWithType:(TransitionAnimationOBJType)type{
    return [[TransitionAnimationOBJ alloc] initWithType:type];
}

- (instancetype)initWithType:(TransitionAnimationOBJType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (_type) {
        case TransitionAnimationOBJTypePresent:
            [self animateTransitionPresent:transitionContext];
            break;
        
        case TransitionAnimationOBJTypeDismiss:
            [self animateTransitionDismiss:transitionContext];
            break;
            
        default:
            break;
    }
}

#pragma mark - present animation
- (void)animateTransitionPresent:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //toVC is presentedVC, fromVC is presentingVC
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
//    [containerView addSubview:fromVC.view];
    
    toVC.view.alpha = 0;
    NSLog(@"toVC:%@ ----- fromVC:%@",NSStringFromClass([toVC class]),NSStringFromClass([fromVC class]));
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
       
        fromVC.view.alpha = 0;
        toVC.view.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        
    }];
    
}

#pragma mark - dismiss animation
- (void)animateTransitionDismiss:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //toVC is presentedVC, fromVC is presentingVC
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
//    UIView *toView = [transitionContext containerView].subviews.lastObject;
    NSLog(@"toVC:%@ ----- fromVC:%@",NSStringFromClass([toVC class]),NSStringFromClass([fromVC class]));
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromVC.view.alpha = 0;
        toVC.view.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        
    }];
}

@end
