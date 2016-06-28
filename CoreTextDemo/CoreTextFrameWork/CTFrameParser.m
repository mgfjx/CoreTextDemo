//
//  CTFrameParser.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/28.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CTFrameParser.h"

@implementation CTFrameParser

+ (CoreTextData *)parserAttributeContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config{
    
    NSMutableAttributedString *contentString = [content mutableCopy];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    
    //获取绘制区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL, restrictSize, NULL);
    CGFloat textHeight = coreTextSize.height;
    
    //生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFrameSetter:frameSetter config:config height:textHeight];
    
    //保存到CoretextData实例中
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    return data;
    
}

+ (CoreTextData *)parserContent:(NSString *)content config:(CTFrameParserConfig *)config{
    
    NSDictionary *attributes = [self attributesWithConfig:config];
    
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    
    CoreTextData *data = [self parserAttributeContent:contentString config:config];
    
    return data;
}

+ (NSDictionary *)attributesWithConfig:(CTFrameParserConfig *)config{
    
    CGFloat fonSize = config.fontSize;
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fonSize, NULL);
    
    CGFloat lineSpacing = config.lineSpace;
    
    const CFIndex kNumberOfSettings = 3;
    
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat),&lineSpacing},
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor *textColor = config.textColor;
    
    //属性
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = textColor;
    dict[NSFontAttributeName] = (__bridge id _Nullable)(fontRef);
    dict[NSParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    
    return dict;
}

+ (CTFrameRef)createFrameWithFrameSetter:(CTFramesetterRef)frameSetter config:(CTFrameParserConfig *)config height:(CGFloat)height{
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    
    return frame;
}

#pragma mark - parser localFile
+ (CoreTextData *)parserTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config{
    
    NSAttributedString *content = [self loadTemplateFile:path config:config];
    return [self parserAttributeContent:content config:config];
}

+ (NSAttributedString *)loadTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config{
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *as = [self parserAttributeContentFromDictionary:dict config:config];
                    [result appendAttributedString:as];
                }
            }
        }
        
    }
    return result;
}

+ (NSAttributedString *)parserAttributeContentFromDictionary:(NSDictionary *)dict config:(CTFrameParserConfig *)config{
    
    NSMutableDictionary *attributes = [[self attributesWithConfig:config] mutableCopy];
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    
    if (color) {
        attributes[NSForegroundColorAttributeName] = color;
    }
    
    CGFloat fontSize = [dict[@"fsize"] floatValue];
    if (fontSize > 0) {
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
    }
    
    NSString *content = dict[@"content"];
    
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (UIColor *)colorFromTemplate:(NSString *)colorStr{
    
    if ([colorStr isEqualToString:@"red"]) {
        return [UIColor redColor];
    }else if([colorStr isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    }else if([colorStr isEqualToString:@"black"]) {
        return [UIColor blackColor];
    }
    return nil;
}

@end












