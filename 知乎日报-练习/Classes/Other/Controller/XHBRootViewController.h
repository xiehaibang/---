//
//  XHBRootViewController.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/10.
//  Copyright © 2017年 谢海邦. All rights reserved.
//  root 视图控制器，控制左视图和中间视图

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "XHBBaseViewController.h"
#import "XHBHomeViewController.h"

/**
 滑动菜单的状态枚举

 - XHBMenuStatusHidden: 隐藏
 - XHBMenuStatusMoving: 正在移动
 - XHBMenuStatusDisplay: 显示
 */
typedef NS_ENUM(NSInteger, XHBMenuStatus) {
    
    XHBMenuStatusHidden,
    XHBMenuStatusMoving,
    XHBMenuStatusDisplay
};


@protocol XHBSlideMenuDelegate <NSObject>

@optional
/**
 滑动菜单状态改变时调用

 @param status 滑动菜单的状态
 */
- (void)menuStatusChangedWithStatus:(XHBMenuStatus)status;

@end


@interface XHBRootViewController : UIViewController

/** 左边视图 */
@property (nonatomic, strong) XHBBaseViewController *leftViewController;
/** 中间视图 */
@property (nonatomic, strong) XHBBaseViewController *midViewController;
/** 首页新闻对象 */
@property (nonatomic, strong) XHBHomeViewController *homeVC;

@property (nonatomic, weak) id <XHBSlideMenuDelegate> delegate;

@property (nonatomic, assign) XHBMenuStatus menuStatus;
/** 主题日报的 id */
@property (nonatomic, assign) NSInteger ID;

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

/**
 * 添加滑动菜单手势
 */
- (void)addGestureForView:(UIView *)view;

/**
 * 移除滑动菜单手势
 */
- (void)removeGesture;

/**
 * 按动导航栏按钮时显示或隐藏导航栏菜单
 */
- (void)navigationButton;

@end
