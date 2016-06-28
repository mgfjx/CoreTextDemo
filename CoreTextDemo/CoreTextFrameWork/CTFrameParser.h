//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/28.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"

@interface CTFrameParser : NSObject

+ (CoreTextData *)parserContent:(NSString *)content config:(CTFrameParserConfig *)config;

@end
