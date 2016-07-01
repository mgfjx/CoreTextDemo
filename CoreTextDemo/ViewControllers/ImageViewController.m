//
//  ImageViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/1.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImageView *imageView;
}

@end

@implementation ImageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initRightBarButton:@"选择图片" action:@selector(clickRightBarBtn:)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:imgView];
    
    imageView = imgView;
    
}

- (void)clickRightBarBtn:(id)sender{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    //    self.snapCallBack(nil);
    UIImagePickerController  *m_picker = [[UIImagePickerController alloc] init];
    m_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    m_picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    m_picker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
//    m_picker.allowsEditing = NO;
    m_picker.delegate = self;
    [self presentViewController:m_picker animated:YES completion:NULL];
    
}

#pragma mark - UIImagePickerControllerDelegate

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置图片
    imageView.image = info[UIImagePickerControllerOriginalImage];
}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
//    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
//    
//    imageView.image = image;
    
    
    [HeadImageController initWithImage:image owner:self screenShotCallBack:^(UIImage *image) {
        
        NSLog(@"finishChooseImage");
        
    }];
    
//    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
*/

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
