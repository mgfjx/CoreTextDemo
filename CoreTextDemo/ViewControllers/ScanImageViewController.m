//
//  ScanImageViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/29.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "ScanImageViewController.h"

@interface ScanImageViewController ()<UIGestureRecognizerDelegate>{
    
    CGAffineTransform currentTransform;
    CGPoint currentPoint;
    
}

@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ScanImageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.298 alpha:1.000];
    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:scrollView];
//    self.scrollView = scrollView;
    
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    imgView.backgroundColor = [UIColor colorWithRed:0.082 green:0.360 blue:0.670 alpha:.500];
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (self.imageName) {
        imgView.image = [UIImage imageNamed:self.imageName];
    }
    
    if (self.image) {
        imgView.image = self.image;
    }
    
    if (self.imageUrl) {
        [imgView sd_setImageWithURL:self.imageUrl];
    }
    
    self.imageView = imgView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss:)];
    [self.view addGestureRecognizer:tap];
    
    //image gesture
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageWithPinchGesture:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImageWithPanGesture:)];
    [imgView addGestureRecognizer:pan];
    
}

- (void)tapToDismiss:(id)tap{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)scaleImageWithPinchGesture:(UIPinchGestureRecognizer *)pinch{
    
    CGPoint point = [pinch locationInView:self.imageView];
    CGFloat x = point.x / self.imageView.frame.size.width;
    CGFloat y = point.y / self.imageView.frame.size.height;
    NSLog(@"x = %f, y = %f", x, y);
    self.imageView.layer.anchorPoint = CGPointMake(x, y);
    
    if (pinch.state == UIGestureRecognizerStateBegan) {
        currentTransform = self.imageView.transform;
    }
    
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [self dealWithImageBounces];
//        currentTransform = CGAffineTransformIdentity;
    }
    
    CGFloat scale = pinch.scale;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    self.imageView.transform = newTransform;
    
}

- (void)moveImageWithPanGesture:(UIPanGestureRecognizer *)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        currentPoint = self.imageView.frame.origin;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self dealWithImageBounces];
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self.view];
        self.imageView.frame = CGRectMake(currentPoint.x + point.x, currentPoint.y + point.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    }
    
}

- (void)dealWithImageBounces{
    
    CGFloat x = self.imageView.frame.origin.x;
    CGFloat y = self.imageView.frame.origin.y;
    CGFloat width = self.imageView.frame.size.width;
    CGFloat height = self.imageView.frame.size.height;
    
    if (width >= self.view.frame.size.width || height >= self.view.frame.size.height) {
        
        CGFloat newX = self.imageView.frame.origin.x;
        CGFloat newY = self.imageView.frame.origin.y;
        CGFloat newWidth = self.imageView.frame.size.width;
        CGFloat newHeight = self.imageView.frame.size.height;
        CGRect frame = CGRectZero;
        
        if (x > 0) {
            newX = 0;
            newY = self.imageView.frame.origin.y;
            newWidth = width;
            newHeight = height;
        }
        if(x + width < self.view.frame.size.width){
            newX = - (width - self.view.frame.size.width);
            newY = newY;
            newWidth = width;
            newHeight = height;
        }
        
        if (y > 0) {
            newX = newX;
            newY = 0;
            newWidth = width;
            newHeight = height;
        }
        
        if (y + height < self.view.frame.size.height) {
            newX = newX;
            newY = - (height - self.view.frame.size.height);
            newWidth = width;
            newHeight = height;
        }
        
        frame = CGRectMake(newX, newY, newWidth, newHeight);
        
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.frame = frame;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (touches.count != 2) {
        return;
    }
    
    UITouch *firstTouch = touches.allObjects.firstObject;
    UITouch *secondTouch = touches.allObjects.lastObject;
    
    CGPoint firstPoint = [firstTouch locationInView:self.imageView];
    CGPoint secondPoint = [secondTouch locationInView:self.imageView];
    
    CGPoint point = CGPointMake((firstPoint.x + secondPoint.x) / 2, (firstPoint.y + secondPoint.y) / 2);
    
    self.imageView.layer.anchorPoint = point;
    
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
