//
//  ViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/27.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:@"Zapfino" size:20],
                          NSForegroundColorAttributeName:[UIColor redColor],
                          NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"0我是一个富文本，9听说我有很多属性，19I will try。32这里清除属性."];
    //设置属性
    [attributeStr setAttributes:dic range:NSMakeRange(0, attributeStr.length)];
    //添加单个属性
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(9, 10)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:NSMakeRange(13, 13)];
    //添加多个属性
    NSDictionary *dicAdd = @{NSBackgroundColorAttributeName:[UIColor yellowColor],NSLigatureAttributeName:@1};
    [attributeStr addAttributes:dicAdd range:NSMakeRange(19, 13)];
    //移除属性
    [attributeStr removeAttribute:NSFontAttributeName range:NSMakeRange(32, 9)];
    
    //label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 400)];
    label.numberOfLines = 0;
    label.attributedText = attributeStr;
    [self.view addSubview:label];
    
}

@end
