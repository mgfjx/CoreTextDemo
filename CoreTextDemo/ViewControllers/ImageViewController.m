//
//  ImageViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/1.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>{
    UIImageView *imageView;
}

@end

@implementation ImageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initRightBarButton:@"选择图片" action:@selector(selectImage)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:imgView];
    
    imageView = imgView;
    
}

- (void)selectImage{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"图库", @"相机", nil];
    [sheet showInView:self.view];
    
}

- (void)selectImageFromAlbum{
    
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];

//    imageView.image = image;
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    [HeadImageController initWithImage:image owner:self screenShotCallBack:^(UIImage *image) {
        
        NSLog(@"finishChooseImage");
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self selectImageFromAlbum];
            break;
            
        default:
            break;
    }
}

@end
