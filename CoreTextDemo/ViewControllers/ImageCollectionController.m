//
//  ImageCollectionController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/4.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "ImageCollectionController.h"
#import <Photos/Photos.h>
#import "ScanImageViewController.h"

@interface ImageCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSMutableArray *imagesArr;
    UICollectionView *imageCollectionView;
}

@end

@implementation ImageCollectionController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 2;
    
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collection.delegate   = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor colorWithWhite:0.498 alpha:1.000];
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collection];
    imageCollectionView = collection;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getImageFromAblum];
    });
}

- (void)getImageFromAblum{
    
    //获取自定义相册
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    //遍历自定义相册
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:NO];
    }
    
    PHAssetCollection *cameraRall = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    
    [self enumerateAssetsInAssetCollection:cameraRall original:NO];
    
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original{
    NSLog(@"相册名：%@",assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    imagesArr = [NSMutableArray array];
    
    for (PHAsset *asset in assets) {
        //是否需要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        //从asset中获取图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [imagesArr addObject:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [imageCollectionView reloadData];
            });
        }];
    }
    
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imagesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.image = imagesArr[indexPath.row];
    
    [cell addSubview:imageView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ScanImageViewController *vc = [[ScanImageViewController alloc] init];
    vc.image = imagesArr[indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
