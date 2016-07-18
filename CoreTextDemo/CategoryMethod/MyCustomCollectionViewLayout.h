//
//  MyCustomCollectionViewLayout.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/18.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyCustomCollectionViewDirection){
    MyCustomCollectionViewDirectionVertical = 0,
    MyCustomCollectionViewDirectionHorizontal
};

@interface MyCustomCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) MyCustomCollectionViewDirection scrollDirection;

@end
