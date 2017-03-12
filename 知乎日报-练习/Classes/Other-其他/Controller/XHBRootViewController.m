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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
