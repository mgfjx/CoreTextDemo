//
//  headers.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/29.
//  Copyright © 2016年 XXL. All rights reserved.
//

#ifndef headers_h
#define headers_h

/*
 宏定义
 */
#define NOTIFICATION_IMAGECLICK @"CoreText_ImageClicked"
#define NOTIFICATION_LINKCLICK @"CoreText_LinkClicked"

#import "ScanImageViewController.h"
#import "UIViewController+Dealloc.h"
#import "LinkWebController.h"
#import "BasicViewController.h"
#import "UIView+AddFunc.h"
#import "HeadImageController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>
#import "UnityTool.h"
#import "UIColor+Hex.h"
#import "YLImageScrollView.h"

#define AboveIOS(versionNumber) ([[UIDevice currentDevice].systemVersion floatValue] >= (versionNumber)) 

#endif /* headers_h */
