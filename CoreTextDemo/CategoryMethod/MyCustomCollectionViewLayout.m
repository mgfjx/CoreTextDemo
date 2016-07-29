//
//  MyCustomCollectionViewLayout.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/18.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "MyCustomCollectionViewLayout.h"

@interface MyCustomCollectionViewLayout (){
    
    CGFloat maxWidth;
    CGFloat maxheight;
    CGFloat sumWidth;
    CGFloat sumHeight;
    
    NSInteger currentSection;
    
}

@property (nonatomic, strong) NSArray *layoutInfoArr;
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation MyCustomCollectionViewLayout

- (void)prepareLayout{
    [super prepareLayout];
//    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    maxWidth = 5;
    currentSection = 0;
    sumWidth = 0;
    sumHeight = 0;
    
    NSMutableArray *layoutInfoArr = [NSMutableArray array];
    NSInteger maxNumberOfItems = 0;
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section ++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *subArr = [NSMutableArray arrayWithCapacity:numberOfItems];
        for (NSInteger item = 0; item < numberOfItems; item ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [subArr addObject:attributes];
        }
        if (maxNumberOfItems < numberOfItems) {
            maxNumberOfItems = numberOfItems;
        }
        [layoutInfoArr addObject:[subArr copy]];
    }
    self.layoutInfoArr = [layoutInfoArr copy];
    
    self.contentSize = CGSizeMake(maxNumberOfItems*(self.itemSize.width + self.minimumInteritemSpacing) + self.minimumInteritemSpacing, numberOfSections*(self.itemSize.height + self.minimumLineSpacing) + self.minimumLineSpacing);
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 每一行能容纳多少个item
    NSInteger maxNumOfHeirizon = (NSInteger)floorl((self.collectionView.bounds.size.width - self.minimumInteritemSpacing)/(self.itemSize.width + self.minimumInteritemSpacing));
    //每一列能容纳多少个item
    NSInteger maxNumOfVerty = (NSInteger)floor(self.collectionView.bounds.size.height/(self.itemSize.height + self.minimumLineSpacing));
    
    CGFloat x = (self.itemSize.width + self.minimumInteritemSpacing)*indexPath.row + self.minimumInteritemSpacing;
    CGFloat y = (self.itemSize.height + self.minimumLineSpacing)*indexPath.section + self.minimumLineSpacing;
    
    switch (self.scrollDirection) {
        case MyCustomCollectionViewDirectionVertical: {
            {
                if (currentSection < indexPath.section) {
                    currentSection = indexPath.section;
                    sumHeight += maxheight;
                    maxheight = 0;
                }
                
                NSInteger count = indexPath.row / maxNumOfHeirizon;
                maxheight = count * (self.minimumLineSpacing + self.itemSize.height + self.minimumLineSpacing) + self.itemSize.height + self.minimumLineSpacing;
                y = sumHeight + maxheight - self.itemSize.height - self.minimumLineSpacing;
                
                NSInteger horizonIndex = indexPath.row % maxNumOfHeirizon;
                CGFloat earchPartWidth = (self.collectionView.bounds.size.width - self.minimumInteritemSpacing*2)/maxNumOfHeirizon;
                x = horizonIndex * earchPartWidth + (earchPartWidth - self.itemSize.width)/2 + self.minimumInteritemSpacing;
            }
            break;
        }
        case MyCustomCollectionViewDirectionHorizontal: {
            {
                if (currentSection < indexPath.section) {
                    currentSection = indexPath.section;
                    sumWidth += maxWidth;
                    maxWidth = 0;
                }
                
                NSInteger count = indexPath.row / maxNumOfVerty;
                maxWidth = count * (self.minimumInteritemSpacing + self.itemSize.width + self.minimumInteritemSpacing) + self.itemSize.width + self.minimumInteritemSpacing;
                x = sumWidth + maxWidth - self.itemSize.width - self.minimumInteritemSpacing;
                
                NSInteger verticalIndex = indexPath.row % maxNumOfVerty;
                CGFloat earchPartHeight = self.collectionView.bounds.size.height / maxNumOfVerty;
                y = verticalIndex * earchPartHeight + (earchPartHeight - self.itemSize.height)/2;
                
            }
            break;
        }
    }
    
    attributes.frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
    
    return attributes;
}

- (CGSize)collectionViewContentSize{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
    switch (self.scrollDirection) {
        case MyCustomCollectionViewDirectionVertical: {
            maxWidth = self.collectionView.bounds.size.width;
            maxheight += sumHeight;
            sumHeight = 0;
            break;
        }
        case MyCustomCollectionViewDirectionHorizontal: {
            maxheight = self.collectionView.bounds.size.height;
            maxWidth += sumWidth;
            sumWidth = 0;
            break;
        }
    }
    return CGSizeMake(maxWidth, maxheight);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSMutableArray *layoutAttributeArr = [NSMutableArray array];
    [self.layoutInfoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(NSArray *)obj enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL * _Nonnull stop) {
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                [layoutAttributeArr addObject:attributes];
            }
        }];
    }];
    return layoutAttributeArr;
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems{
    
    NSLog(@"hehe");
    
}

@end
