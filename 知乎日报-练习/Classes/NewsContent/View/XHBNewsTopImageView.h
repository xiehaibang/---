//
//  XHBNewsTopImageView.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/9.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBNewsContent.h"

@interface XHBNewsTopImageView : UIView

/** 新闻内容对象 */
@property (strong, nonatomic) XHBNewsContent *newsContent;

/**
 * 将 XHBNewsTopImageView 固定在传进来的视图上，并且监听传进来的滚动视图的偏移值
 */
+ (XHBNewsTopImageView *)attachToView:(UIView *)view observeScorllView:(UIScrollView *)scrollView;


@end
