//
//  XHBContentViewController.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/6.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBBaseViewController.h"
#import "XHBNewsContentViewController.h"
#import "XHBHomeTopView.h"

@interface XHBHomeViewController : XHBBaseViewController <XHBNewsContentControllerDelegate>

/** 顶部视图 */
@property (strong, nonatomic) XHBHomeTopView *topView;

@end
