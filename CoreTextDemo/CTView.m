//
//  CTView.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/27.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CTView.h"
#import <CoreText/CoreText.h>

@implementation CTView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();//获取上下文
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形的变换矩阵 不做图形变换
    CGContextTranslateCTM(context, 0, self.bounds.size.height);//将画布向上平移一个屏幕的距离
    CGContextScaleCTM(context, 1.0, -1.0);//缩放方法，x轴缩放系数为1，则不变，y轴缩放系数为-1，相当于以x轴为轴旋转180度
    
    NSMutableAttributedString *attribueStr = [[NSMutableAttributedString alloc] initWithString:@"\n这里在测试图文混排，\n我是富文本"];
    
    /*
     设置一个回调结构体，告诉代理该回调那些方法
     */
    CTRunDelegateCallbacks callbacks;//创建一个回调结构体，并设置相关参数
    
    //memset将已开辟的内存空间 callbacks 的首n个字节的值设为0，相当于CTRunDelegateCallbacks内存空间初始化
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;//设置回调版本，默认这个
    callbacks.getAscent = ascentCallBacks;//设置图片顶部距离基线的距离
    callbacks.getDescent = descentCallBacks;//设置图片底部距离基线的距离
    callbacks.getWidth = widthCallBacks;//设置图片的宽度
    
    /*
     创建一个代理
     */
    NSDictionary *dicPic = @{@"height":@20,@"width":@20};//创建一个图片尺寸的字典，初始化代理对象需要
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (void *)dicPic);
    
    //图片插入
    unichar placeHolder = 0xFFFC;//创建空白占位符
    NSString *placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1];//以空白字符生成字符串
    NSMutableAttributedString *placeHolderAttrStr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);//给字符串中的范围中字符串设置代理
    CFRelease(delegate);
    
    [attribueStr insertAttributedString:placeHolderAttrStr atIndex:12];//将占位符插入原富文本
    
    
    //绘制文本
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attribueStr);//一个frame的工厂负责生成frame
    CGMutablePathRef path = CGPathCreateMutable();//创建绘制区域
    CGPathAddRect(path, NULL, self.bounds);//添加绘制尺寸
    NSInteger length = attribueStr.length;
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, NULL);//工厂根据绘制区域及富文本（可选范围，多次设置）设置frame
    CTFrameDraw(frame, context);//根据frame绘制文字
    
    
    //绘制图片
    UIImage *image = [UIImage imageNamed:@"exp"];
    CGRect imgFrame = [self calculateImageRectWithFrame:frame];
    CGContextDrawImage(context, imgFrame, image.CGImage);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
    
}

static CGFloat ascentCallBacks(void *ref){
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}

static CGFloat descentCallBacks(void *ref){
    return 0;
}

static CGFloat widthCallBacks(void *ref){
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}

-(CGRect)calculateImageRectWithFrame:(CTFrameRef)frame{
    
    //绘制图片
    NSArray *arrLines = (NSArray *)CTFrameGetLines(frame);//根据frame获得绘制的线的数组
    NSInteger count = arrLines.count;//获取线的数量
    CGPoint points[count];//建立起点的数组（cgpoint类型为结构体，故用C语言的数组）
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);//获取起点
    
    //遍历获取图片的frame
    for (int i = 0; i < count; i ++) {
        CTLineRef line = (__bridge CTLineRef)(arrLines[i]);
        NSArray *arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);//获取GlyphRun数组（GlyphRun：高效的字符绘制方案）
        for (int j = 0; j < arrGlyphRun.count; j++) {
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];//获取CTRun
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);//获取CTRun属性
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];//获取代理
            if (delegate == nil) {
                continue;
            }
            NSDictionary *dic = CTRunDelegateGetRefCon(delegate);//判断代理字典
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            CGPoint point = points[i];//获取一个起点
            CGFloat ascent;//获取上距
            CGFloat descent;//获取下距
            CGRect boundsRun;//创建一个frame
            boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            boundsRun.size.height = ascent + descent;
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);//获取x偏移量
            boundsRun.origin.x = point.x + xOffset;//point是行起点位置，加上每个字的偏移量得到每个字的x
            boundsRun.origin.y = point.y - descent;//计算原点
            CGPathRef path = CTFrameGetPath(frame);//获取绘制区域
            CGRect colRect = CGPathGetBoundingBox(path);//获取剪裁区域边框
            CGRect imageBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
            
            return imageBounds;
        }
    }
    return CGRectZero;
}

@end
