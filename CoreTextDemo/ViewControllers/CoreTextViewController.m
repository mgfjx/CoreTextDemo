//
//  CoreTextViewController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/30.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "CoreTextViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParserConfig.h"
#import "CTFrameParser.h"


@interface CoreTextViewController ()

@property (nonatomic, strong) CTDisplayView *displayView;

@end

@implementation CoreTextViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Draw" style:UIBarButtonItemStyleDone target:self action:@selector(clickBtn:)];
    self.navigationItem.rightBarButtonItem = item;
    
}


- (void)clickBtn:(id)sender{
    
    if (self.displayView) {
        return;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:scrollView];
    
    CTDisplayView *view = [[CTDisplayView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height)];
    view.backgroundColor = [UIColor colorWithRed:0.902 green:0.951 blue:0.971 alpha:1.000];
    [scrollView addSubview:view];
    self.displayView = view;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"modelData" ofType:nil];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.lineSpace = -1.0f;
    config.width = view.width;
    config.textColor = [UIColor colorWithRed:0.120 green:0.729 blue:0.112 alpha:1.000];
    CoreTextData *data = [CTFrameParser parserTemplateFile:path config:config];
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
