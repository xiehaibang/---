//
//  UIBarButtonItem+XHBExtension.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/12.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "UIBarButtonItem+XHBExtension.h"

@implementation UIBarButtonItem (XHBExtension)

/** 创建自定义 UIBarButtonItem */
+ (instancetype) initWithImageName:(NSString *)imageName
                     highImageName:(NSString *)highImageName
                            target:(id)target
                            action:(SEL)action
{
    /* 创建自定义按钮 */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    /* 设置按钮的背景图片 */
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    
    /* 设置按钮的大小，如果不设置按钮无法显示 */
    CGRect frame;
    frame.size = button.currentBackgroundImage.size;
    button.frame = frame;
    
    /* 添加按钮监听事件 */
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

@end
