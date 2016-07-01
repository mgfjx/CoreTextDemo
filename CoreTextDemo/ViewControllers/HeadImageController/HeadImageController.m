//
//  HeadImageController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/1.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "HeadImageController.h"

@interface HeadImageController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImageView *imageView;
}

@property (nonatomic, assign) ScreenShotCallBack snapCallBack;
@property (nonatomic, strong) UIImage *currentImage;;

@end

@implementation HeadImageController

+ (void)initWithImage:(UIImage *)image owner:(UIViewController *)controller screenShotCallBack:(ScreenShotCallBack)callBack{
    
    HeadImageController *vc = [[HeadImageController alloc] init];
    vc.snapCallBack = callBack;
    vc.currentImage = image;
    [controller presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.backgroundColor = [UIColor lightGrayColor];
    imgView.image = self.currentImage;
    [self.view addSubview:imgView];
    
    imageView = imgView;
    
}
@end
