//
//  XHBContentViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/6.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBContentViewController.h"
#import "XHBRootViewController.h"
#import "XHBCatalogViewController.h"

/* 将屏幕的宽与高定义为宏 */
#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height

@interface XHBContentViewController ()

@end

@implementation XHBContentViewController

#pragma mark - viewController 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 创建导航栏按钮 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImageName:@"Home_Icon" highImageName:@"Home_Icon_Highlight" target:self action:@selector(catalogClick)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 动作事件方法
- (void)catalogClick
{
    /* 移动类别视图 */
    if (self.navigationController.view.frame.origin.x == 0) { //如果左边视图的位置x坐标为0
        [UIView animateWithDuration:1.0 animations:^{
            self.navigationController.view.frame = CGRectMake(230, 0, screenWidth, screenHeight);
        }];
    }else {
        [UIView animateWithDuration:1.0 animations:^{
            self.navigationController.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        }];
    }
    
//    XHBCatalogViewController *catalog = [[XHBCatalogViewController alloc] init];
//    
//    /* 加载新闻类别 */
//    [catalog loadCatalog];
}

@end
