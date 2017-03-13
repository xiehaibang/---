//
//  XHBRootViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/10.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBRootViewController.h"

@interface XHBRootViewController ()

@end

@implementation XHBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 添加子控制器和子视图 */
    [self addChildViewController:self.leftViewController];
    [self.view addSubview:self.leftViewController.view];
    
    [self addChildViewController:self.midViewController];
    [self.view addSubview:self.midViewController.view];
    
    /* 设置leftViewController的大小 */
    self.leftViewController.view.frame = CGRectMake(0, 0, 280, [[UIScreen mainScreen] bounds].size.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
