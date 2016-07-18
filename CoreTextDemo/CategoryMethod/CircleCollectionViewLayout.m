//
//  CIrcleCollectionViewLayout.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/18.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CircleCollectionViewLayout.h"

@interface CircleCollectionViewLayout ()

@property (nonatomic, strong) NSArray *layoutInfoArr;

@end

@implementation CircleCollectionViewLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    NSMutableArray *layoutInfoArr = [NSMutableArray array];
    
    NSInteger numberOfSection = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < numberOfSection; section ++) {
        NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *sectionInfoArr = [NSMutableArray arrayWithCapacity:numberOfItem];
        for (NSInteger item = 0; item < numberOfItem; item ++) {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            [sectionInfoArr addObject:attributes];
        }
        [layoutInfoArr addObject:[sectionInfoArr copy]];
    }
    
    self.layoutInfoArr = [layoutInfoArr copy];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributesArr = [NSMutableArray array];
    
    [self.layoutInfoArr enumerateObjectsUsingBlock:^(NSArray *subArray, NSUInteger idx, BOOL * _Nonnull stop) {
        [subArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (CGRectIntersectsRect(obj.frame, rect)) {
                [attributesArr addObject:obj];
            }
        }];
    }];
    
    return [attributesArr copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    
    return attributes;
}

@end
