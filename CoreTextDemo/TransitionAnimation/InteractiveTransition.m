//
//  InteractiveTransition.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/4.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "InteractiveTransition.h"
#import "PresentOneTransition.h"

@interface InteractiveTransition (){
    CGFloat persent;
}

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, assign) InteractiveTransitionType type;
@property (nonatomic, assign) InteractiveTransitionGestureDirection direction;

@end

@implementation InteractiveTransition

+ (instancetype)interactiveTransitionWithTransitionType:(InteractiveTransitionType)type gesturDirection:(InteractiveTransitionGestureDirection)direction{
    return [[InteractiveTransition alloc] initWithTransitionType:type gesturDirection:direction];
}

- (instancetype)initWithTransitionType:(InteractiveTransitionType)type gesturDirection:(InteractiveTransitionGestureDirection)direction{
    self = [super init];
    if (self) {
        _type = type;
        _direction = direction;
    }
    return self;
}

#pragma mark - panGesture
- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    //将传入的控制器保存，因为要利用它触发转场操作
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}

#pragma mark - 手势过渡
- (void)handleTapGesture:(UIPanGestureRecognizer *)panGesture{
    
    //手势百分比
    persent = 0;
    switch (_direction) {
        case InteractiveTransitionGestureDirectionLeft: {
            CGFloat transitionX = - [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
            break;
        }
        case InteractiveTransitionGestureDirectionRight: {
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
            break;
        }
        case InteractiveTransitionGestureDirectionUp: {
            CGFloat transitionY = - [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.height;
            break;
        }
        case InteractiveTransitionGestureDirectionDown: {
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.height;
            break;
        }
    }
    
    NSLog(@"persent:%f",persent);
    
    switch (panGesture.state) {
        
        case UIGestureRecognizerStateBegan: {
            //手势开始的时候标记手势状态，并开始相应的事件，它的作用在使用这个类的时候说明
            self.interaction = YES;
            //手势开始是触发对应的转场操作，方法代码在后面
            [self startGesture];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            //手势过程中，通过updateInteractiveTransition设置转场过程进行的百分比，然后系统会根据百分比自动布局控件，不用我们控制了
            [self updateInteractiveTransition:persent];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作，转场失败
            self.interaction = NO;
            if (persent > 0.3) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
    
}

//触发对应转场操作的代码如下，根据type(type是我自定义的枚举值)我们去判断是触发哪种操作，对于push和present由于要传入需要push和present的控制器，为了解耦，我用block把这个操作交个控制器去做了，让这个手势过渡管理者可以充分被复用
- (void)startGesture{
    switch (_type) {
        case InteractiveTransitionTypePresent:{
            if (_presentConifg) {
                _presentConifg();
            }
        }
            break;
            
        case InteractiveTransitionTypeDismiss:
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
            
            
        case InteractiveTransitionTypePush:{
            if (_pushConifg) {
                _pushConifg();
            }
        }
            break;
        case InteractiveTransitionTypePop:
            [_vc.navigationController popViewControllerAnimated:YES];
            break;
            
    }
}

#pragma mark - Swipe Gesture
- (void)addSwipeGestureForViewController:(UIViewController *)viewController direction:(UISwipeGestureRecognizerDirection)direction{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    self.vc = viewController;
    swipe.direction = direction;
    [viewController.view addGestureRecognizer:swipe];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)swipe{
    
    switch (swipe.state) {
        case UIGestureRecognizerStateEnded: {
            [self startGesture];
            break;
        }
        default:
            break;
    }
    
}


@end
