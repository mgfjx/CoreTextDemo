//
//  ImageViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/7/1.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "ImageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageCollectionController.h"

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
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"单张图库", @"多张图片", @"相机", nil];
    [sheet showInView:self.view];
    
}

- (void)selectImageFromAlbum{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    UIImagePickerController  *m_picker = [[UIImagePickerController alloc] init];
    m_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    m_picker.allowsEditing = YES;
    m_picker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage,(NSString *)kUTTypeVideo];
    m_picker.delegate = self;
    
    [self presentViewController:m_picker animated:YES completion:NULL];
    
}

- (void)selectImageFromCamera{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        if(AboveIOS(8.4)) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"当前设备不支持相机%@",[UIDevice currentDevice].systemVersion] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前设备不支持相机" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
    
    UIImagePickerController  *m_picker = [[UIImagePickerController alloc] init];
    m_picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    m_picker.videoMaximumDuration = 15;
    m_picker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    m_picker.allowsEditing = YES;
    m_picker.delegate = self;
    m_picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    [self presentViewController:m_picker animated:YES completion:NULL];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerEditedImage];
        imageView.image = image;
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        
        NSURL *url = info[UIImagePickerControllerMediaURL];
        
        AVPlayerLayer *layer = nil;
        
        if (url) {
            
            AVPlayer *player = [AVPlayer playerWithURL:url];
            layer = [AVPlayerLayer playerLayerWithPlayer:player];
            layer.frame = self.view.bounds;
            [self.view.layer addSublayer:layer];
            
            [player play];
            
        }else{
            if (layer) {
                [layer removeFromSuperlayer];
            }
        }
        
        NSLog(@"%@",url.absoluteString);
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    return;
    /*
    [HeadImageController initWithImage:image owner:self screenShotCallBack:^(UIImage *image) {
        
        NSLog(@"finishChooseImage");
        
    }];
     */
    
}

- (void)selectImagesFromAlbum{
    
    ImageCollectionController *vc = [[ImageCollectionController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
            
        case 1:
            [self selectImagesFromAlbum];
            break;
            
        case 2:
            [self selectImageFromCamera];
            break;
            
        default:
            break;
    }
}

@end
