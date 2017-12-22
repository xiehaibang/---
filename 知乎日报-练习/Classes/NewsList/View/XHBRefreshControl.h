//
//  XHBRefreshControl.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/15.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBRefreshControl : UIView

/** 刷新动画的菊花组件 */
@property (nonatomic, strong) UIActivityIndicatorView *activityView;


/**
 * 获取 XHBRefreshControl 对象，并对传进来的滚动视图进行监听
 */
+ (XHBRefreshControl *)getViewObserveToScrollView:(UIScrollView *)scrollView
                                        target:(id)target
                                        action:(SEL)action;


/**
 * 结束刷新
 */
- (void)endRefresh;

@end
