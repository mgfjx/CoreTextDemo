//
//  ViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/27.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "ViewController.h"
#import "CTView.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(220, 100, 100, 200);
    label.numberOfLines = 0;
    [self.view addSubview:label];
    self.label = label;
    
}

- (void)clickBtn:(UIButton *)sender{
    
    CTView *view = [[CTView alloc] initWithFrame:CGRectMake(100, 250, 200, 200)];
    view.backgroundColor = [UIColor colorWithRed:0.902 green:0.951 blue:0.971 alpha:1.000];
    view.insertIndex = 15;
    [self.view addSubview:view];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"'It’s crucial that you ask about training before you accept the job,' said Steve Jeffers, HR director at Meridian Business Support. 'Let’s face it, you won’t want to go in a role and stay there indefinitely – you’re likely to want a promotion at some point. By asking at the interview stages you can understand how you will progress through the company from the offset.'"];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    [attributeStr setAttributes:attributes range:NSMakeRange(0, attributeStr.length)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:0.167 green:0.768 blue:0.067 alpha:1.000] range:NSMakeRange(20, 10)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-Oblique" size:24] range:NSMakeRange(35, 10)];
    [attributeStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, attributeStr.length)];
    
    view.attributeText = attributeStr;
    
}

@end
