//
//  UIButton+XHBClickRange.m
//  知乎日报-练习
//
//  Created by 云趣科技 on 2017/12/22.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "UIButton+XHBClickRange.h"
#import <objc/runtime.h>

@implementation UIButton (XHBClickRange)

static char topEdgeKey;
static char leftEdgeKey;
static char bottomEdgeKey;
static char rightEdgeKey;

/**
 根据值来设置范围

 @param size 四条边增加的范围的值
 */
- (void)setEnlargeEdge:(CGFloat)size {
    
    objc_setAssociatedObject(self, &topEdgeKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftEdgeKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomEdgeKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightEdgeKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 根据边距值来设置范围

 @param top 上边距
 @param left 左边距
 @param bottom 下边距
 @param right 右边距
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    
    objc_setAssociatedObject(self, &topEdgeKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftEdgeKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomEdgeKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightEdgeKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 扩大按钮的响应范围

 @return 响应范围
 */
- (CGRect)enlargerRect {
    
    NSNumber *topEdge = objc_getAssociatedObject(self, &topEdgeKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftEdgeKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomEdgeKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightEdgeKey);
    
    if (topEdge && leftEdge && bottomEdge && rightEdge) {
        
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + rightEdge.floatValue + leftEdge.floatValue,
                          self.bounds.size.height + bottomEdge.floatValue + topEdge.floatValue);
    }
    else {
        return self.bounds;
    }
}

#pragma mark - touch事件
/**
 返回当前事件的响应者

 @param point 点击位置
 @param event 点击事件
 @return 响应者
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {

    //获取扩大后的范围
    CGRect rect = [self enlargerRect];
    
    //如果扩大后的范围和原来一样，那就给父类判断
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    
    return CGRectContainsPoint(rect, point) ? self : nil;
}



@end
