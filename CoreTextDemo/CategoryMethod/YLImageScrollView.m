//
//  YLImageScrollView.m
//  CoreTextDemo
//
//  Created by xxl on 16/7/14.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "YLImageScrollView.h"

#define CollectionCell_Identifier @"Cell"

@interface YLImageScrollView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>{
    
    UICollectionView *ylCollectionView;
    
}

@end

@implementation YLImageScrollView

- (void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - view method 
- (void)removeFromSuperview{
    [super removeFromSuperview];
    
    
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self initViews];
    }
}

#pragma mark - init views
- (void)initViews{
    
    CGRect frame = self.bounds;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collection.delegate   = self;
    collection.dataSource = self;
    collection.pagingEnabled = YES;
    collection.bounces = NO;
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionCell_Identifier];
    [self addSubview:collection];
    
    ylCollectionView = collection;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource ? [self.dataSource imageScrollViewNumberOfViews] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCell_Identifier forIndexPath:indexPath];
    UIView *view = [self.dataSource imageScrollView:self viewForItemAtIndex:indexPath.row];
    [cell.contentView addSubview:view];
    
    cell.backgroundColor = [UIColor randomColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageScrollView:didSelectedItemAtIndex:)]) {
        [self.delegate imageScrollView:self didSelectedItemAtIndex:indexPath.row];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offset_x = scrollView.contentOffset.x;
    
    if (offset_x >= (6*self.bounds.size.width)) {
        [ylCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

@end
