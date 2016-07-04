//
//  FirstViewController.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/4.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "BasicViewController.h"

@protocol PresentViewControllerDelegate <NSObject>

- (void)presentedControllerPressedDissmiss;
- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent;

@end

@interface FirstViewController : BasicViewController

@property (nonatomic, weak) id<PresentViewControllerDelegate> delegate;

@end
