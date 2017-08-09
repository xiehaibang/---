//
//  XHBNewsFootView.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/7.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBNewsFootView : UIView

/**
 * 将 XHBNewsFootView 固定在传进来的视图上，并且对传进来的滚动视图进行监听
 */
+ (XHBNewsFootView *)attachObserveToScrollView:(UIScrollView *)scrollView
                                        target:(id)target
                                        action:(SEL)action;

@end
