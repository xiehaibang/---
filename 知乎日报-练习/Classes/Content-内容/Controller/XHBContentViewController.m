//
//  XHBContentViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/6.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBContentViewController.h"

@interface XHBContentViewController ()

@end

@implementation XHBContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 设置导航栏按钮 */
    UIButton *catalogButton = [UIButton buttonWithType:UIButtonTypeCustom]; //自定义按钮
    
    [catalogButton setBackgroundImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
