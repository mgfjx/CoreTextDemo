//
//  CTFrameParser.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/28.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CTFrameParser.h"
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"

#define FontName @"AmericanTypewriter"

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
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)FontName, fonSize, NULL);
    
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
    
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    
    NSAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray linkArray:linkArray];
    CoreTextData *data = [self parserAttributeContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}

+ (NSAttributedString *)loadTemplateFile:(NSString *)path
                                  config:(CTFrameParserConfig *)config
                              imageArray:(NSMutableArray *)imageArray
                               linkArray:(NSMutableArray *)linkArray{
    
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
                }else if([type isEqualToString:@"img"]){
                    
                    CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = result.length;
                    [imageArray addObject:imageData];
                    
                    //创建空白占位符，并且设置CTRunDelegate信息
                    NSAttributedString *as = [self parserImageDataFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                }else if ([type isEqualToString:@"link"]){
                    
                    NSUInteger startPos = result.length;
                    NSAttributedString *as = [self parserAttributeContentFromDictionary:dict config:config];
                    
                    NSMutableAttributedString *linkStr = [[NSMutableAttributedString alloc] initWithAttributedString:as];
                    [linkStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, linkStr.length)];
                    as = [linkStr copy];
                    [result appendAttributedString:as];
                    
                    //创建CoreTextLinkData
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    
                    CoreTextLinkData *linkData = [[CoreTextLinkData alloc] init];
                    linkData.title = dict[@"content"];
                    linkData.url = dict[@"url"];
                    linkData.range = linkRange;
                    [linkArray addObject:linkData];
                    
                }
            }
        }
        
    }
    return result;
}

+ (NSAttributedString *)parserImageDataFromNSDictionary:(NSDictionary *)imageDict config:(CTFrameParserConfig *)config{
    
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallBack;
    callBacks.getDescent = descentCallBack;
    callBacks.getWidth = widthCallBack;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (void *)imageDict);
    
    //使用0xFFFC作为空白占位符
    unichar placeHolderChar = 0xFFFC;
    NSString *placeHolderStr = [NSString stringWithCharacters:&placeHolderChar length:1];
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *placeHolderAttrStr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    
    return placeHolderAttrStr;
}

+ (NSAttributedString *)parserAttributeContentFromDictionary:(NSDictionary *)dict config:(CTFrameParserConfig *)config{
    
    NSMutableDictionary *attributes = [[self attributesWithConfig:config] mutableCopy];
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    
    if (color) {
        attributes[NSForegroundColorAttributeName] = color;
    }
    
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)FontName, fontSize, NULL);
        attributes[NSFontAttributeName] = (__bridge id _Nullable)(fontRef);
        CFRelease(fontRef);
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
    }else if([colorStr isEqualToString:@"default"]) {
        return [UIColor blackColor];
    }
    
    return nil;
}

#pragma mark - CTRunDelegata 回调
static CGFloat ascentCallBack(void *ref){
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallBack(void *ref){
    return 0;
}

static CGFloat widthCallBack(void *ref){
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}

@end












