//
//  CoreTextLinkData.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/29.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextLinkData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSRange range;

@end
