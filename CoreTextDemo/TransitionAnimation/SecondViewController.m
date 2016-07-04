//
//  SecondViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/4.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "SecondViewController.h"
#import "PresentOneTransition.h"
#import "InteractiveTransition.h"
#import "FirstViewController.h"

@interface SecondViewController ()<PresentViewControllerDelegate>

@property (nonatomic, strong) InteractiveTransition *interactivePush;

@end

@implementation SecondViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initRightBarButton:@"present" action:@selector(presentVC)];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.388 green:0.901 blue:0.698 alpha:1.000];
    
    self.title = @"弹性present";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zrx3.jpg"]];
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    imageView.frame = CGRectMake(10, 100, self.view.width - 10 * 2, 60);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或者向上滑动present" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(10, 100, self.view.width - 10 * 2, 60);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    
    _interactivePush = [InteractiveTransition interactiveTransitionWithTransitionType:InteractiveTransitionTypePresent gesturDirection:InteractiveTransitionGestureDirectionUp];
    
    typeof(self) weakSelf = self;
    _interactivePush.presentConifg = ^(){
        [weakSelf presentVC];
    };
    [_interactivePush addPanGestureForViewController:self];
//    [_interactivePush addSwipeGestureForViewController:self direction:UISwipeGestureRecognizerDirectionUp];
    
}

- (void)presentVC{
    
    FirstViewController *vc = [[FirstViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)presentedControllerPressedDissmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent{
    return _interactivePush;
}

@end
