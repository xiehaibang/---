//
//  AppDelegate.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/5.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "AppDelegate.h"
#import "XHBCatalogViewController.h"
#import "XHBHomeViewController.h"
#import "XHBNavigationController.h"
#import "XHBRootViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /* 获取 rootVC 单例 */
    XHBRootViewController *rootVC = [XHBRootViewController sharedInstance];
    
    /* 设置rootViewController为根视图控制器 */
    self.window.rootViewController = rootVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    //设备屏幕的宽高
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    //初始化屏幕快照视图，并将它设置为 window 最上面的视图
    self.screenShotView = [[XHBScreenShotBackView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.window insertSubview:self.screenShotView atIndex:0];
    
    //隐藏屏幕快照视图
    self.screenShotView.hidden = YES;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
