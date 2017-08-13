//
//  XHBNewsHeadView.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/7.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBNewsHeadView : UIView

/**
 * 将 XHBNewsHeadView 固定在传进来的视图上，并且对传进来的滚动视图进行监听
 */
+ (XHBNewsHeadView *)attachObserveToScrollView:(UIScrollView *)scrollView
                                        target:(id)target
                                        action:(SEL)action;

@end
