//
//  UIView+XHBExtension.h
//  百思不得姐-学习
//
//  Created by 谢海邦 on 2016/12/14.
//  Copyright © 2016年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XHBExtension)

/** 在分类中声明 @property，只会生成方法的声明，不会生成方法的实现和带有 '_' 的成员变量 */

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end
