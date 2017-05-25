//
//  AppDelegate.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/5.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "AppDelegate.h"
#import "XHBCatalogViewController.h"
#import "XHBContentViewController.h"
#import "XHBNavigationController.h"
#import "XHBRootViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /* 创建左边目录模块 */
    XHBCatalogViewController *catalogViewController = [[XHBCatalogViewController alloc] init];
    
    /* 创建右边内容模块 */
    XHBContentViewController *contentViewController = [[XHBContentViewController alloc] init];
    
    /* 将左边的目录模块加入自定义导航控制器 */
    XHBNavigationController *catalogNav = [[XHBNavigationController alloc] initWithRootViewController:catalogViewController];
    
    /* 将右边的内容模块加入自定义导航控制器 */
    XHBNavigationController *contentNav = [[XHBNavigationController alloc] initWithRootViewController:contentViewController];
    
    /* 创建root视图控制器 */
    XHBRootViewController *rootViewController = [[XHBRootViewController alloc] init];
    
    /* 将目录模块和内容模块分别加入左边和中间的视图 */
    rootViewController.leftViewController = catalogNav;
    rootViewController.midViewController = contentNav;
    
    /* 设置rootViewController为根视图控制器 */
    self.window.rootViewController = rootViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
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
