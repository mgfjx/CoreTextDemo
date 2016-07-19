//
//  CIrcleCollectionViewLayout.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/18.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CircleCollectionViewLayout.h"

@interface CircleCollectionViewLayout (){
    CGFloat angle;
    CGFloat averageAngle;
    CGFloat radius;
    CGPoint radiusOrigin;
}

@property (nonatomic, strong) NSArray *layoutInfoArr;

@end

@implementation CircleCollectionViewLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        
        angle = 0.0f;
        radius = 150;
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    
    NSMutableArray *layoutInfoArr = [NSMutableArray array];
    
    NSInteger numberOfSection = [self.collectionView numberOfSections];
    
    /*
    for (NSInteger section = 0; section < numberOfSection; section ++) {
        NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *sectionInfoArr = [NSMutableArray arrayWithCapacity:numberOfItem];
        for (NSInteger item = 0; item < numberOfItem; item ++) {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            [sectionInfoArr addObject:attributes];
        }
        [layoutInfoArr addObject:[sectionInfoArr copy]];
    }
     */
    
    self.layoutInfoArr = [layoutInfoArr copy];
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    averageAngle = 2*M_PI/numberOfItems;
    
    radiusOrigin = CGPointMake(self.collectionView.width/2, self.collectionView.height/2);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attrArr = [NSMutableArray array];
    
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        
        UICollectionViewLayoutAttributes *a = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [attrArr addObject:a];
    }
    
    return [attrArr copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat currentAngle = indexPath.row * averageAngle;
    CGFloat x = cos(currentAngle)*radius + radiusOrigin.x;
    CGFloat y = sin(currentAngle)*radius + radiusOrigin.y;
    
    attributes.frame = CGRectMake(0, 0, 30, 30);
    attributes.center = CGPointMake(x, y);
    
    return attributes;
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

@end
