//
//  CTAPIView.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/27.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CTAPIView.h"
#import <CoreText/CoreText.h>

@implementation CTAPIView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    NSString *string = @"'It’s crucial that you ask about training before you accept the job,' said Steve Jeffers, HR director at Meridian Business Support. 'Let’s face it, you won’t want to go in a role and stay there indefinitely – you’re likely to want a promotion at some point. By asking at the interview stages you can understand how you will progress through the company from the offset.'";
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:[UIColor colorWithRed:0.118 green:0.713 blue:0.238 alpha:1.000]};
    
    [attributeStr setAttributes:dic range:NSMakeRange(0, attributeStr.length )];
    
    //设置回调体
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallBack;
    callBacks.getDescent = descentCallBack;
    callBacks.getWidth = widthCallBack;
    
    //创建代理
    NSDictionary *dicPic = @{@"height":@50,@"width":@50};
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (void *)dicPic);
    
    //创建空白占位符
    unichar placeHolderChar= 0xFFFC;
    NSString *placeHolderStr = [NSString stringWithCharacters:&placeHolderChar length:1];
    NSMutableAttributedString *placeHolderAttrStr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    
    [attributeStr insertAttributedString:placeHolderAttrStr atIndex:30];
    
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(0, attributeStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    NSInteger length = attributeStr.length;
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, NULL);
    CTFrameDraw(frame, context);
    
    //绘制图片
    UIImage *image = [UIImage imageNamed:@"exp"];
    CGRect imgFrame = [self calculateImageRectWithFrame:frame];
    CGContextDrawImage(context, imgFrame, image.CGImage);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
    
}

static CGFloat ascentCallBack(void *ref){
    return 10.0;
}

static CGFloat descentCallBack (void * refCon ){
    return 0.0;
}

static CGFloat widthCallBack (void * ref){
    return 10.0;
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
