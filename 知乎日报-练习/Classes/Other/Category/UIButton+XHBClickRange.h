//
//  UIButton+XHBClickRange.h
//  知乎日报-练习
//
//  Created by 云趣科技 on 2017/12/22.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XHBClickRange)

/**
 根据值来设置范围
 
 @param size 四条边增加的范围的值
 */
- (void)setEnlargeEdge:(CGFloat)size;

/**
 根据边距值来设置范围
 
 @param top 上边距
 @param left 左边距
 @param bottom 下边距
 @param right 右边距
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

@end
