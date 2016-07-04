//
//  FirstViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/4.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "PresentOneTransition.h"
#import "InteractiveTransition.h"

@interface FirstViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) InteractiveTransition *interactiveDismiss;

@end

@implementation FirstViewController

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
    
    self.view.backgroundColor = [UIColor colorWithRed:0.340 green:0.352 blue:0.887 alpha:1.000];
    
    
    self.title = @"弹性present";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zrx3.jpg"]];
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    imageView.frame = CGRectMake(10, 100, self.view.width - 10 * 2, 60);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或向下滑动dismiss" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(10, 100, self.view.width - 10 * 2, 60);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    
    _interactiveDismiss = [InteractiveTransition interactiveTransitionWithTransitionType:InteractiveTransitionTypeDismiss gesturDirection:InteractiveTransitionGestureDirectionDown];
    [_interactiveDismiss addPanGestureForViewController:self];
//    [_interactiveDismiss addSwipeGestureForViewController:self direction:UISwipeGestureRecognizerDirectionDown];
    
}

- (void)dismissVC{
    if (_delegate && [_delegate respondsToSelector:@selector(presentedControllerPressedDissmiss)]) {
        [_delegate presentedControllerPressedDissmiss];
    }
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _interactiveDismiss.interaction ? _interactiveDismiss : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    InteractiveTransition *interaction = [_delegate interactiveTransitionForPresent];
    return interaction.interaction ? interaction : nil;
}

#pragma makr - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //这里我们初始化presentType
    return [PresentOneTransition transitionWithTransitionType:PresentOneTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    return [PresentOneTransition transitionWithTransitionType:PresentOneTransitionTypeDismiss];
}

@end
