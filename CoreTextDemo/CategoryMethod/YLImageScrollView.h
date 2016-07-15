//
//  YLImageScrollView.h
//  CoreTextDemo
//
//  Created by xxl on 16/7/14.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YLImageScrollViewDelegate <NSObject>
@optional
  - (void)onClickOnImageIndex:(NSInteger)index;
@end

@protocol YLImageScrollViewDataSource <NSObject>
@required
  - (NSArray<UIImage *> *)imageScrollViewDataSource;
@end

@interface YLImageScrollView : UIView

@property (nonatomic, weak) id<YLImageScrollViewDelegate  > delegate;
@property (nonatomic, weak) id<YLImageScrollViewDataSource> dataSource;

@property (nonatomic, assign) BOOL autoScroll;/*auto scroll*/
@property (nonatomic, assign) NSTimeInterval timeInterval;/*auto scroll interval time*/

@property (nonatomic, assign) BOOL showPageControl;/*show page or not*/
@property (nonatomic, strong) UIColor *pageCurrentColor;
@property (nonatomic, strong) UIColor *pageTinkColor;

@property (nonatomic, strong) NSArray *dataArray;

@end
