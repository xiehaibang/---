//
//  XHBContentViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/6.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBContentViewController.h"
#import "XHBRootViewController.h"

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
    XHBLogFunc; /* 打印方法名 */
    
    if (self.navigationController.view.frame.origin.x == 0) { //如果左边视图的位置x坐标为0
        [UIView animateWithDuration:1.0 animations:^{
            self.navigationController.view.frame = CGRectMake(200, 0, screenWidth, screenHeight);
        }];
    }else {
        [UIView animateWithDuration:1.0 animations:^{
            self.navigationController.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        }];
    }
}

#pragma mark - UISplitViewControllerDelegate 协议
- (void)splitViewController:(UISplitViewController *)svc
    willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode
{
//    UIViewController *masterViewController = svc.viewControllers[0];
//    UIViewController *detailViewController = svc.viewControllers[1];
//    
//    if ([detailViewController isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *nav = (UINavigationController *)detailViewController;
//        
//        if ([nav.topViewController isKindOfClass:[XHBContentViewController class]]) {
//            <#statements#>
//        }
//    }
    
    NSLog(@"%ld", (long)displayMode);
    
    self.navigationItem.leftBarButtonItem.title = @"目录";
    self.navigationItem.leftItemsSupplementBackButton = true;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return NO;
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
