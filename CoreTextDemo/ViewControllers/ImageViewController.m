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
#import "SDImageCache.h"

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
    imageScrollView.dataSource = self;
    imageScrollView.delegate = self;
    imageScrollView.frame = CGRectMake(8, 100, self.view.bounds.size.width - 8*2, 250);
    imageScrollView.backgroundColor = [UIColor colorWithRed:0.101 green:0.492 blue:0.440 alpha:1.000];
    [self.view addSubview:imageScrollView];
    
    imagesArray = @[@"http://a.hiphotos.baidu.com/zhidao/pic/item/3812b31bb051f819b671ef24d8b44aed2e73e70c.jpg",
                    @"http://f.hiphotos.baidu.com/zhidao/pic/item/728da9773912b31b9d5322478418367adab4e1a5.jpg",
                    @"http://f.hiphotos.baidu.com/zhidao/pic/item/54fbb2fb43166d22122ff9fa442309f79052d200.jpg",
                    @"http://b.hiphotos.baidu.com/zhidao/pic/item/8ad4b31c8701a18bbebefe219c2f07082838fe03.jpg",
                    @"http://g.hiphotos.baidu.com/zhidao/pic/item/dcc451da81cb39db48978838d2160924ab18300d.jpg",
                    @"http://f.hiphotos.baidu.com/zhidao/pic/item/960a304e251f95ca0cac7ed8cb177f3e67095207.jpg",
                    @"http://a.hiphotos.baidu.com/zhidao/pic/item/3812b31bb051f819b671ef24d8b44aed2e73e70c.jpg"];
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (NSInteger)imageScrollViewNumberOfViews{
    return imagesArray.count;
}

#pragma mark - YLImageScrollViewDataSource,YLImageScrollViewDelegate
- (UIView *)imageScrollView:(YLImageScrollView *)imageScrollView viewForItemAtIndex:(NSInteger)index{
    UIImageView *v = [[UIImageView alloc] initWithFrame:imageScrollView.bounds];
    [v sd_setImageWithURL:[NSURL URLWithString:imagesArray[index]] placeholderImage:[UIImage imageNamed:@"sdxl.jpg"]];
    return v;
}

- (void)imageScrollView:(YLImageScrollView *)imageScrollView didSelectedItemAtIndex:(NSInteger)index{
    ScanImageViewController *vc = [[ScanImageViewController alloc] init];
    vc.imageUrl = [NSURL URLWithString:imagesArray[index]];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
