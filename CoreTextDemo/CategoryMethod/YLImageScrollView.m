//
//  YLImageScrollView.m
//  CoreTextDemo
//
//  Created by xxl on 16/7/14.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "YLImageScrollView.h"

#define SET_FRAME(ARTICLEX) x = ARTICLEX.frame.origin.x + increase;\
if(x < 0) x = pageWidth * 2;\
if(x > pageWidth * 2) x = 0.0f;\
[ARTICLEX setFrame:CGRectMake(x, \
ARTICLEX.frame.origin.y,\
ARTICLEX.frame.size.width,\
ARTICLEX.frame.size.height)]

@interface YLImageScrollView ()<UIScrollViewDelegate>{
    
    UIScrollView *imageScrollView;
    NSArray *imageViews;
    NSArray *imagesArray;
    UIPageControl *pageControlView;
    
    NSTimer *_timer;
    NSInteger currentPage;
    
    UIImageView *leftImageView;
    UIImageView *middleImageView;
    UIImageView *rightImageView;
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
    NSArray *names = @[@"sdxl.jpg",@"exp.png",@"gtl.jpg",@"QRcode.png",@"lrt.jpg"];
    for (int i = 0; i < names.count; i ++) {
        [images addObject:[UIImage imageNamed:names[i]]];
    }
    
    imageArray = [images copy];
    imagesArray = imageArray;
    
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        [scroll addSubview:imageView];
        leftImageView = imageView;
    }
    
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        [scroll addSubview:imageView];
        middleImageView = imageView;
    }
    
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        [scroll addSubview:imageView];
        rightImageView = imageView;
    }
    
    imageViews = @[leftImageView,middleImageView,rightImageView];
    
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = names.count;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    pageControlView = pageControl;
    
    [self initFrames];
}

- (void)setDefaultImage{
    
    [imageScrollView setContentOffset:CGPointMake(imageScrollView.bounds.size.width, 0) animated:NO];
    leftImageView.image = imagesArray.lastObject;
    middleImageView.image = imagesArray.firstObject;
    rightImageView.image = imagesArray[1];
    
}

- (void)initFrames{
    
    pageControlView.hidden = !self.showPageControl;
    pageControlView.pageIndicatorTintColor = self.pageTinkColor;
    pageControlView.currentPageIndicatorTintColor = self.pageCurrentColor;
    
    imageScrollView.frame = self.bounds;
    pageControlView.frame = CGRectMake(self.bounds.size.width / 2, self.bounds.size.height - 30, 40, 30);
    
    imageScrollView.contentSize = CGSizeMake(self.bounds.size.width * imageViews.count, self.bounds.size.height);
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = imageViews[i];
        imageView.frame = CGRectMake(i * imageScrollView.bounds.size.width, 0, imageScrollView.bounds.size.width, imageScrollView.bounds.size.height);
    }
    [self setDefaultImage];
}

- (void)autoScrollImage{
    
    UIScrollView *scrollView = imageScrollView;
    CGFloat offset_x = scrollView.contentOffset.x;
    [scrollView setContentOffset:CGPointMake(offset_x + scrollView.bounds.size.width, 0) animated:YES];
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
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self reloadImage];
    
    [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, 0) animated:NO];
    
    [_timer setFireDate:[NSDate dateWithTimeInterval:1.0f sinceDate:[NSDate date]]];
    
    NSLog(@"scrollViewDidEndDecelerating");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self reloadImage];
    [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, 0) animated:NO];
    NSLog(@"scrollViewDidEndScrollingAnimation");
}

#pragma mark - reloadImage
- (void)reloadImage{
    
    NSInteger leftImageIndex, rightImageIndex;
    
    UIScrollView *scrollView = imageScrollView;
    CGFloat offset_x = scrollView.contentOffset.x;
    
    if (offset_x > scrollView.bounds.size.width) {
        currentPage = (currentPage + 1) % imagesArray.count;
    }else if(offset_x < scrollView.bounds.size.width){
        currentPage = (currentPage + imagesArray.count - 1) % imagesArray.count;
    }
    
    middleImageView.image = imagesArray[currentPage];
    
    leftImageIndex = (currentPage + imagesArray.count - 1) % imagesArray.count;
    rightImageIndex = (currentPage + 1) % imagesArray.count;
    
    leftImageView.image = imagesArray[leftImageIndex];
    rightImageView.image = imagesArray[rightImageIndex];
    
    pageControlView.currentPage = currentPage;
}

@end
