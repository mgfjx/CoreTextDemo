//
//  YLImageScrollView.h
//  CoreTextDemo
//
//  Created by xxl on 16/7/14.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLImageScrollView;

@protocol YLImageScrollViewDelegate <NSObject>

- (void)imageScrollView:(YLImageScrollView *)imageScrollView didSelectedItemAtIndex:(NSInteger)index;

@end

@protocol YLImageScrollViewDataSource <NSObject>

- (UIView *)imageScrollView:(YLImageScrollView *)imageScrollView viewForItemAtIndex:(NSInteger)index;
- (NSInteger)imageScrollViewNumberOfViews;

@end

@interface YLImageScrollView : UIView

@property (nonatomic, weak) id<YLImageScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<YLImageScrollViewDelegate> delegate;

@end
