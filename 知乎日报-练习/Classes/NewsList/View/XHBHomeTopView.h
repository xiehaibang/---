//
//  XHBHomeTopView.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/12.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBHomeTopView : UIView

/**
 * 将 XHBHomeTopView 固定在传进来的视图上，并且监听传进来的滚动视图的偏移值
 */
+ (XHBHomeTopView *)attachToView:(UIView *)view observeScrollView:(UIScrollView *)scrollView;

@end
