//
//  ViewController.m
//  MuMenuView
//
//  Created by zhangxiaoye on 2018/6/27.
//  Copyright © 2018年 zhangxiaoye. All rights reserved.
//

#import "ViewController.h"
#import "ZXYMenuEntity.h"
#import "ZXYMuMenuView.h"
#import <MJExtension.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"plist"];
    NSArray *date = [NSArray arrayWithContentsOfFile:filePath];
    
    NSArray *menuItems = [ZXYMenuEntity mj_objectArrayWithKeyValuesArray:date];
    
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 200, 400)];
    back.backgroundColor = [UIColor redColor];
    [self.view addSubview:back];
    ZXYMuMenuView *view = [ZXYMuMenuView showMuMenuView:self.view TabArr:menuItems];

    [view AllSelected:NO];

    view.SelectedBlock = ^(NSMutableArray *selectedMenuItems) {

        NSLog(@"这里是全部选中数据\n%@",selectedMenuItems);
    };
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
