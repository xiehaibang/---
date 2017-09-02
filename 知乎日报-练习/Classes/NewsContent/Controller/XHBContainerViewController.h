//
//  XHBContainerViewController.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/4.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBBaseViewController.h"

@class XHBHomeViewController, XHBThemeViewController;

@interface XHBContainerViewController : XHBBaseViewController

/** 新闻 id */
@property (assign, nonatomic) NSInteger newsId;

/** 首页对象 */
@property (weak, nonatomic) XHBHomeViewController *homeVC;

/** 其他主题日报对象 */
@property (weak, nonatomic) XHBThemeViewController *themeVC;

@end
