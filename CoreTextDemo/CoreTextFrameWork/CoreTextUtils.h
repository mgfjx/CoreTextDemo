//
//  Utils.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/29.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextLinkData.h"
#import "CoreTextData.h"

@interface CoreTextUtils : NSObject

+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

@end
