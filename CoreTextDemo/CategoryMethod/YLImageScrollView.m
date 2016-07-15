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
    NSArray *imageViewsArray;
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
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
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
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.backgroundColor = [UIColor colorWithRed:0.086 green:0.500 blue:0.808 alpha:1.000];
    [self addSubview:scroll];
    imageScrollView = scroll;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [scroll addGestureRecognizer:tap];
    
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
    
    imageViewsArray = @[leftImageView,middleImageView,rightImageView];
    
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    pageControlView = pageControl;
}

- (void)tapImage:(UIGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickOnImageIndex:)]) {
        [self.delegate onClickOnImageIndex:currentPage];
    }
}

- (void)autoScrollImage{
    
    UIScrollView *scrollView = imageScrollView;
    CGFloat offset_x = scrollView.contentOffset.x;
    [scrollView setContentOffset:CGPointMake(offset_x + scrollView.bounds.size.width, 0) animated:YES];
}

#pragma mark - view load method

- (void)removeFromSuperview{
    [super removeFromSuperview];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [self configureViews];
    }
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)configureViews{
    [self initFrames];
    
    imagesArray = [self.dataSource imageScrollViewDataSource];
    if (!imagesArray || imagesArray.count == 0) {
        self.userInteractionEnabled = NO;
        return;
    }
    
    pageControlView.hidden = !self.showPageControl;
    pageControlView.pageIndicatorTintColor = self.pageTinkColor;
    pageControlView.currentPageIndicatorTintColor = self.pageCurrentColor;
    pageControlView.numberOfPages = imagesArray.count;
    
    [self setDefaultImage];
    
    if (self.autoScroll) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(autoScrollImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        _timer = timer;
    }
}

- (void)initFrames{
    
    imageScrollView.frame = self.bounds;
    pageControlView.frame = CGRectMake(self.bounds.size.width / 2, self.bounds.size.height - 30, 40, 30);
    
    imageScrollView.contentSize = CGSizeMake(self.bounds.size.width * imageViewsArray.count, self.bounds.size.height);
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = imageViewsArray[i];
        imageView.frame = CGRectMake(i * imageScrollView.bounds.size.width, 0, imageScrollView.bounds.size.width, imageScrollView.bounds.size.height);
    }
    
}

- (void)setDefaultImage{
    
    UIImage *leftImage, *middleImage, *rightImage;
    
    if (imagesArray.count == 1) {
        leftImage = middleImage = rightImage = imagesArray.firstObject;
    }else if (imagesArray.count == 2){
        leftImage = rightImage = imagesArray.lastObject;
        middleImage = imagesArray.firstObject;
    }else{
        leftImage = imagesArray.lastObject;
        middleImage = imagesArray.firstObject;
        rightImage = imagesArray[1];
    }
    
    [imageScrollView setContentOffset:CGPointMake(imageScrollView.bounds.size.width, 0) animated:NO];
    leftImageView.image = leftImage;
    middleImageView.image = middleImage;
    rightImageView.image = rightImage;
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self reloadImage];
    
    [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, 0) animated:NO];
    if (_timer) {
        [_timer setFireDate:[NSDate dateWithTimeInterval:1.0f sinceDate:[NSDate date]]];
    }
    
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
    NSArray *images = imagesArray;
    
    UIScrollView *scrollView = imageScrollView;
    CGFloat offset_x = scrollView.contentOffset.x;
    
    if (offset_x > scrollView.bounds.size.width) {
        currentPage = (currentPage + 1) % images.count;
    }else if(offset_x < scrollView.bounds.size.width){
        currentPage = (currentPage + images.count - 1) % images.count;
    }
    
    middleImageView.image = images[currentPage];
    
    leftImageIndex = (currentPage + images.count - 1) % images.count;
    rightImageIndex = (currentPage + 1) % images.count;
    
    leftImageView.image = images[leftImageIndex];
    rightImageView.image = images[rightImageIndex];
    
    pageControlView.currentPage = currentPage;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
}

@end
