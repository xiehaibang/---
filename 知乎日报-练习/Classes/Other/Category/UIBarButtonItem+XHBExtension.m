//
//  UIBarButtonItem+XHBExtension.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/12.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "UIBarButtonItem+XHBExtension.h"

@implementation UIBarButtonItem (XHBExtension)

/** 
 创建有高亮状态的自定义 UIBarButtonItem 
 */
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
    button.size = button.currentBackgroundImage.size;
    
    /* 添加按钮监听事件 */
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

/**
 创建带有标题的 UIBarBuutonItem 
 */
+ (instancetype) initWithImageName:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action
{
    /* 创建自定义按钮 */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    /* 设置按钮的背景图片和标题文字 */
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
//    button.backgroundColor = [UIColor orangeColor];
    
    /* 设置按钮被按下时图片的状态是否应该高亮 */
    button.adjustsImageWhenHighlighted = NO;
    
    /* 设置文字颜色 */
    [button setTitleColor:XHBColor(151, 156, 160) forState:UIControlStateNormal];
    
    /* 修改按钮的图片和标题位置 */
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; //让按钮内容水平左对齐
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    /* 设置按钮大小 */
    button.size = CGSizeMake(120, 40);
    
    /* 添加按钮监听事件 */
    
    return [[self alloc] initWithCustomView:button];
}

@end
