//
//  XHBRootViewController.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/10.
//  Copyright © 2017年 谢海邦. All rights reserved.
//  root 视图控制器，控制左视图和中间视图

#import <UIKit/UIKit.h>

@interface XHBRootViewController : UIViewController

/** 左边视图 */
@property (nonatomic, strong) UIViewController *leftViewController;
/** 中间视图 */
@property (nonatomic, strong) UIViewController *midViewController;

@end
