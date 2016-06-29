//
//  LinkWebController.m
//  CoreTextDemo
//
//  Created by 谢小龙 on 16/6/29.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import "LinkWebController.h"

@interface LinkWebController ()

@end

@implementation LinkWebController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *web = [[UIWebView alloc] init];
    web.frame = self.view.bounds;
    [self.view addSubview:web];
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [web loadRequest:request];
    
}

@end
