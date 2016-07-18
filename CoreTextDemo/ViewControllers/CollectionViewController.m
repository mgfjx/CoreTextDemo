//
//  CollectionViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/18.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CollectionViewController.h"
#import "MyCustomCollectionViewLayout.h"

@interface CollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    UICollectionView *currentCollectionView;
    
}

@end

@implementation CollectionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    MyCustomCollectionViewLayout *layout = [[MyCustomCollectionViewLayout alloc] init];
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(85, 85);
    layout.minimumInteritemSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10;
    
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 100, self.view.width - 8*2, self.view.height - 300) collectionViewLayout:layout];
    collection.delegate   = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
//    collection.pagingEnabled = YES;
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collection];
    
    currentCollectionView = collection;
    
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 100;
    }else if(section == 1){
        return 5;
    }
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor randomColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}

@end
