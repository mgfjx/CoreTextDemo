//
//  BasicViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/30.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "BasicViewController.h"

@implementation BasicViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)initRightBarButton:(NSString *)title action:(SEL)action{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:action];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}


@end
