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
 * 获取 XHBNewsFootView 对象，并且对传进来的滚动视图进行监听
 */
+ (XHBNewsFootView *)getViewObserveToScrollView:(UIScrollView *)scrollView
                                        target:(id)target
                                        action:(SEL)action;



@end
