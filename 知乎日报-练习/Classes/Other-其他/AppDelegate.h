//
//  AppDelegate.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/5.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBScreenShotBackView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 屏幕快照视图的对象 */
@property (strong, nonatomic) XHBScreenShotBackView *screenShotView;

@end

