//
//  ScanImageViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/29.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "ScanImageViewController.h"

@interface ScanImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ScanImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.298 alpha:1.000];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
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
    
}

- (void)tapToDismiss:(id)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
