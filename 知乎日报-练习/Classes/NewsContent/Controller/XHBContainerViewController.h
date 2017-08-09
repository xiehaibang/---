//
//  XHBContainerViewController.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/4.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHBHomeViewController;

@interface XHBContainerViewController : UIViewController

/** 新闻 id */
@property (assign, nonatomic) NSInteger newsId;

/** 首页对象 */
@property (strong, nonatomic) XHBHomeViewController *homeVC;

@end
