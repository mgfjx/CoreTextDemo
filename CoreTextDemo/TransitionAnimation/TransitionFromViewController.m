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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 200, 100);
    [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testTimevOut:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

- (void)testTimevOut:(UIButton *)sender{
    
    [UnityTool countDownWithTime:59 timeOutCallBack:^{
        
        [sender setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        sender.userInteractionEnabled = YES;
        
    } timeCountCallBack:^(int timeLeft) {
        
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:1];
        
        [sender setTitle:[NSString stringWithFormat:@"%d",timeLeft] forState:UIControlStateNormal];
        
        [UIView commitAnimations];
        
        sender.userInteractionEnabled = NO;
        
    }];
    
}

- (void)changeColor{
    
    self.view.backgroundColor = [UIColor randomColor];
    
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
