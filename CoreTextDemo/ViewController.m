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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray *titleArray;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArray = @[@"CoreText"];
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - CoreText
- (void)coreTextImplementation{
    
    
    
}

@end
