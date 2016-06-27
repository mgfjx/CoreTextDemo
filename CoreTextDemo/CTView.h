//
//  CTView.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/27.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSAttributedString *attributeText;
@property (nonatomic, assign) NSInteger insertIndex;

@end
