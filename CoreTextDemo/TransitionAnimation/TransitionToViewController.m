//
//  TransitionToViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/4.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "TransitionToViewController.h"
#import "TransitionAnimationOBJ.h"

@interface TransitionToViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation TransitionToViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.468 green:0.000 blue:0.812 alpha:1.000];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTap:)];
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlerSwipe:)];
    [self.view addGestureRecognizer:swipe];
    
}

- (void)handlerSwipe:(UIGestureRecognizer *)swipe{
    self.fromVC.view.backgroundColor = [UIColor blueColor];
}

- (void)handlerTap:(UIGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self.view];
    if (point.x > self.view.width - 140) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [TransitionAnimationOBJ transitionWithType:TransitionAnimationOBJTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [TransitionAnimationOBJ transitionWithType:TransitionAnimationOBJTypeDismiss];
}

@end
