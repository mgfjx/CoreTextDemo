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
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"snapshot" style:UIBarButtonItemStyleDone target:self action:@selector(snapshot:)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *web = [[UIWebView alloc] init];
    web.frame = self.view.bounds;
    [self.view addSubview:web];
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [web loadRequest:request];
    
}

- (void)snapshot:(id)sender{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.center = self.view.center;
    imageView.image = [self.view snapshotImage];
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:0.25 animations:^{
        imageView.frame = CGRectMake(0, 0, 200, 350);
        imageView.center = self.view.center;
    } completion:nil];
    
}

@end
