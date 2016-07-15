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
#import "ScanImageViewController.h"

@interface ImageViewController ()<YLImageScrollViewDataSource,YLImageScrollViewDelegate>{
    UIImageView *imageView;
    NSArray *imagesArray;
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
    
    YLImageScrollView *imageScrollView = [[YLImageScrollView alloc] init];
    imageScrollView.frame = CGRectMake(8, 100, self.view.bounds.size.width - 8*2, 250);
    imageScrollView.dataSource = self;
    imageScrollView.delegate = self;
    imageScrollView.backgroundColor = [UIColor colorWithRed:0.101 green:0.492 blue:0.440 alpha:1.000];
    imageScrollView.showPageControl = YES;
    imageScrollView.autoScroll = YES;
    imageScrollView.timeInterval = 2;
    imageScrollView.pageCurrentColor = [UIColor whiteColor];
    imageScrollView.pageTinkColor = [UIColor colorWithRed:0.215 green:0.000 blue:1.000 alpha:.500];
    [self.view addSubview:imageScrollView];
}

- (NSArray<UIImage *> *)imageScrollViewDataSource{
    
    NSArray *imageNames = @[@"sdxl.jpg",@"gtl.jpg",@"lrt.jpg",@"exp.png",@"QRcode.png"];
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *name in imageNames) {
        [images addObject:[UIImage imageNamed:name]];
    }
    imagesArray = [images copy];
    return [images copy];
}

- (void)onClickOnImageIndex:(NSInteger)index{
    
    ScanImageViewController *vc = [[ScanImageViewController alloc] init];
    vc.image = imagesArray[index];
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
