//
//  XHBRootViewController.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/10.
//  Copyright © 2017年 谢海邦. All rights reserved.
//  root 视图控制器，控制左视图和中间视图

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface XHBRootViewController : UIViewController

/** 左边视图 */
@property (strong,nonatomic) UIViewController *leftViewController;
/** 中间视图 */
@property (strong,nonatomic) UIViewController *midViewController;

/** 主题日报的 id */
@property (assign, nonatomic) NSInteger ID;

/** 
 * 初始化方法 
 */
//- (instancetype)init;

/**
 * 获取单例
 */
+ (instancetype)sharedInstance;

/**
 * 切换到首页新闻
 */
- (void)showHomeCategory;

/**
 * 切换到其他主题日报新闻
 */
- (void)showOtherCategory;

@end
