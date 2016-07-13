//
//  TransitionFromViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/4.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "TransitionFromViewController.h"
#import "TransitionToViewController.h"

@implementation TransitionFromViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initRightBarButton:@"pressent" action:@selector(presentVC)];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.133 green:0.702 blue:0.069 alpha:1.000];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTap:)];
    [self.view addGestureRecognizer:tap];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)changeColor{
    
    self.view.backgroundColor = [UIColor randomColor];
    
    UIColor *color = self.view.backgroundColor;
    
    NSLog(@"%@",color.stringColor);
    
}

- (void)handlerTap:(UIGestureRecognizer *)tap{
    NSLog(@"handlerTap:");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)presentVC{
    
    TransitionToViewController *vc = [[TransitionToViewController alloc] init];
    vc.fromVC = self;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
}

@end
