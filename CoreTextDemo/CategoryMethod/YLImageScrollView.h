//
//  YLImageScrollView.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/14.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YLImageScrollViewDelegate <NSObject>

@end

@protocol YLImageScrollViewDataSource <NSObject>
@required
  - (NSArray<UIImage *> *)imageScrollViewDataSource;
@end

@interface YLImageScrollView : UIView

@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, weak) id<YLImageScrollViewDelegate  > delegate;
@property (nonatomic, weak) id<YLImageScrollViewDataSource> dataSource;

@property (nonatomic, assign) BOOL showPageControl;
@property (nonatomic, strong) UIColor *pageCurrentColor;
@property (nonatomic, strong) UIColor *pageTinkColor;

@property (nonatomic, strong) NSArray *dataArray;

@end
