//
//  ImageViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/1.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "ImageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageCollectionController.h"

@interface ImageViewController ()<YLImageScrollViewDataSource>{
    UIImageView *imageView;
}

@end

@implementation ImageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self initRightBarButton:@"选择图片" action:@selector(selectImage)];
    
    YLImageScrollView *imageScrollView = [[YLImageScrollView alloc] initWithFrame:CGRectMake(8, 100, self.view.bounds.size.width - 8*2, 250)];
    imageScrollView.dataSource = self;
    imageScrollView.backgroundColor = [UIColor colorWithRed:0.101 green:0.492 blue:0.440 alpha:1.000];
    imageScrollView.showPageControl = YES;
    imageScrollView.pageCurrentColor = [UIColor whiteColor];
    imageScrollView.pageTinkColor = [UIColor colorWithRed:0.215 green:0.000 blue:1.000 alpha:.500];
    [self.view addSubview:imageScrollView];
}

- (NSArray<UIImage *> *)imageScrollViewDataSource{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        [images addObject:[UIImage imageNamed:@"sdxl"]];
    }
    
    return images;
}

@end
