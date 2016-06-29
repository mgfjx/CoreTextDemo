//
//  ViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/27.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "ViewController.h"
#import "CTView.h"
#import "CTAPIView.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:btn];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Draw" style:UIBarButtonItemStylePlain target:self action:@selector(clickBtn:)];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)clickBtn:(UIButton *)sender{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:scrollView];
    
    CTDisplayView *view = [[CTDisplayView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height)];
    view.backgroundColor = [UIColor colorWithRed:0.902 green:0.951 blue:0.971 alpha:1.000];
    [scrollView addSubview:view];
    
    NSString *content = @"'It’s crucial that you ask about training before you accept the job,' said Steve Jeffers, HR director at Meridian Business Support. 'Let’s face it, you won’t want to go in a role and stay there indefinitely – you’re likely to want a promotion at some point. By asking at the interview stages you can understand how you will progress through the company from the offset.'";
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    [attributeStr setAttributes:attributes range:NSMakeRange(0, attributeStr.length)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:0.167 green:0.768 blue:0.067 alpha:1.000] range:NSMakeRange(20, 10)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-Oblique" size:24] range:NSMakeRange(35, 10)];
    [attributeStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, attributeStr.length)];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"modelData" ofType:nil];
    
    NSString *txtPath = @"/Users/xiexiaolong1/Desktop/sdxl.txt";
    NSString *string = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.lineSpace = -1.0f;
    config.width = view.width;
    config.textColor = [UIColor colorWithRed:0.120 green:0.729 blue:0.112 alpha:1.000];
//    CoreTextData *data = [CTFrameParser parserTemplateFile:path config:config];
    CoreTextData *data = [CTFrameParser parserContent:string config:config];
    view.coreTextData = data;
    
    scrollView.contentSize = CGSizeMake(scrollView.width, data.height);
    view.height = data.height;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coreTextImageClicked:) name:NOTIFICATION_IMAGECLICK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coreTextLinkClicked:) name:NOTIFICATION_LINKCLICK object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)coreTextImageClicked:(NSNotification *)notification{
    
    NSDictionary *info = notification.userInfo;
    
    NSLog(@"%@",info);
    
    ScanImageViewController *vc = [[ScanImageViewController alloc] init];
    vc.imageName = info[@"imageName"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)coreTextLinkClicked:(NSNotification *)notification{
    
    NSDictionary *info = notification.userInfo;
    NSLog(@"%@",info);
    
    LinkWebController *vc = [[LinkWebController alloc] init];
    vc.urlString = info[@"url"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
