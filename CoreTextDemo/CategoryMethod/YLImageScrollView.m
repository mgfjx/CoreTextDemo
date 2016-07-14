//
//  YLImageScrollView.m
//  CoreTextDemo
//
//  Created by xxl on 16/7/14.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "YLImageScrollView.h"

@interface YLImageScrollView ()<UIScrollViewDelegate>{
    
    UIScrollView *imageScrollView;
    NSMutableArray *imageViews;
    UIPageControl *pageControlView;
    
    NSTimer *_timer;
    NSInteger currentPage;
}

@end

@implementation YLImageScrollView

- (void)dealloc{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

#pragma mark - init viwes
- (void)initViews{
//    if (!self.dataSource) return;
    currentPage = 0;
    _timeInterval = 2.0f;
    _autoScroll = YES;
    _showPageControl = YES;
    imageViews = [NSMutableArray array];
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.backgroundColor = [UIColor colorWithRed:0.086 green:0.500 blue:0.808 alpha:1.000];
    [self addSubview:scroll];
    imageScrollView = scroll;
    
    NSArray *imageArray = [self.dataSource imageScrollViewDataSource];
    
    NSMutableArray *images = [NSMutableArray array];
    NSArray *names = @[@"sdxl.jpg",@"exp.png",@"gtl.jpg",@"lrt.jpg",@"QRcode.png",@"sdxl.jpg",@"exp.png",@"gtl.jpg",@"lrt.jpg",@"QRcode.png",];
    for (int i = 0; i < names.count; i ++) {
        [images addObject:[UIImage imageNamed:names[i]]];
    }
    
    imageArray = [images copy];
    
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = imageArray[i];
        [scroll addSubview:imageView];
        [imageViews addObject:imageView];
    }
    
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = imageViews.count;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    pageControlView = pageControl;
    
}

- (void)autoScrollImage{
    
    currentPage = pageControlView.currentPage;
    currentPage ++;
    pageControlView.currentPage = currentPage;
    
    if (currentPage > imageViews.count - 1) {
        imageScrollView.contentOffset = CGPointMake(0, 0);
    }
    
    if (currentPage == imageViews.count - 1) {
        pageControlView.currentPage = 0;
    }
    
    CGRect visibleRect = CGRectMake(imageScrollView.bounds.size.width*currentPage, 0, imageScrollView.bounds.size.width, imageScrollView.bounds.size.height);
//    [imageScrollView scrollRectToVisible:visibleRect animated:YES];
    if (currentPage > imageViews.count - 1) {
        pageControlView.currentPage = 1;
        [imageScrollView setContentOffset:CGPointMake(imageScrollView.bounds.size.width, 0) animated:YES];
    }else{
        [imageScrollView setContentOffset:CGPointMake(currentPage*imageScrollView.bounds.size.width, 0) animated:YES];
    }
    NSLog(@"%f",currentPage*imageScrollView.bounds.size.width);
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    if (self.autoScroll) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(autoScrollImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        _timer = timer;
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    pageControlView.hidden = !self.showPageControl;
    pageControlView.pageIndicatorTintColor = self.pageTinkColor;
    pageControlView.currentPageIndicatorTintColor = self.pageCurrentColor;
    
    imageScrollView.frame = self.bounds;
    pageControlView.frame = CGRectMake(self.bounds.size.width / 2, self.bounds.size.height - 30, 40, 30);
    
    imageScrollView.contentSize = CGSizeMake(self.bounds.size.width * imageViews.count, self.bounds.size.height);
    
    for (int i = 0; i < imageViews.count; i++) {
        UIImageView *imageView = imageViews[i];
        imageView.frame = CGRectMake(i * imageScrollView.bounds.size.width, 0, imageScrollView.bounds.size.width, imageScrollView.bounds.size.height);
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    pageControlView.currentPage = offset.x / scrollView.width;
    NSLog(@"%@", NSStringFromCGPoint(offset));
    [_timer setFireDate:[NSDate dateWithTimeInterval:1.0f sinceDate:[NSDate date]]];
}

@end
