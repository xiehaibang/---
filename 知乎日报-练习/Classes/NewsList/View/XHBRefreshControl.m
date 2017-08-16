//
//  XHBRefreshControl.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/15.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBRefreshControl.h"

@interface XHBRefreshControl ()

/** 传进来的对象 */
@property (assign, nonatomic) id target;

/** 传进来的方法 */
@property (assign, nonatomic) SEL action;

/** 刷新状态 */
@property (assign, nonatomic) BOOL isRefreshing;

/** 隐藏状态 */
@property (assign, nonatomic) BOOL isHidding;

/** 被监听滚动视图的偏移值 */
@property (assign, nonatomic) CGFloat offsetY;

@end

@implementation XHBRefreshControl

/**
 * 获取 XHBRefreshControl 对象，并对传进来的滚动视图进行监听
 */
+ (XHBRefreshControl *)getViewObserveToScrollView:(UIScrollView *)scrollView
                                           target:(id)target
                                           action:(SEL)action {
    
    XHBRefreshControl *refreshView = [[XHBRefreshControl alloc] init];
    
    refreshView.target = target;
    refreshView.action = action;
    
    //设置 refreshView 的背景色为透明
    refreshView.backgroundColor = [UIColor clearColor];
    
    //创建菊花组件
    refreshView.activityView = [[UIActivityIndicatorView alloc] init];
    
    //菊花停止动画时隐藏
    refreshView.activityView.hidesWhenStopped = YES;
    
    //停止菊花动画
    [refreshView.activityView stopAnimating];
    
    [refreshView addSubview:refreshView.activityView];
    
    [scrollView addObserver:refreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return refreshView;
}


/**
 * 监听事件发生时
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    UIScrollView *scrollView = object;
    
    self.offsetY = scrollView.contentOffset.y;
    
    if (self.isHidding && self.offsetY >= 0) {
        
        self.isHidding = NO;
        self.isRefreshing = NO;
        
        [self.activityView stopAnimating];
    }
    
    //如果是正在刷新，就返回
    if (self.isRefreshing) {
        return;
    }
    
    if (self.offsetY < -60 && self.offsetY >= -90 && !scrollView.isDragging) {
        
        self.isRefreshing = YES;
        
        //启动菊花动哈
        [self.activityView startAnimating];
        
        //用 performSelector: 方法会存在内存泄露的危险，因为编译器不知道该对象能不能响应，如果不能，就是不安全的
        //所以可以用 methodForSelector: 方法来获取指定方法的函数指针，在传入 receiver 和 selector 调用这个方法
        ((void (*)(id, SEL))[self.target methodForSelector:self.action])(self.target, self.action);
    }
    
    //让系统自己调用 drawRect:
    [self setNeedsDisplay];
}


/** 
 * 重写 drawRect: 绘制 refreshView，一个圆
 */
- (void)drawRect:(CGRect)rect {
    
    if (self.offsetY >= 0 || self.isRefreshing) {
        return;
    }
    
    //半径
    CGFloat radius = (self.width - 5) * 0.5;
    
    //绘制下面的圆
    CGContextRef belowContext = UIGraphicsGetCurrentContext();
    
    //给当前上下文添加圆弧
    CGContextAddArc(belowContext, self.width * 0.5, self.width * 0.5, radius, 0, M_PI * 2, 0);
    
    [[UIColor lightGrayColor] set];
    
    CGContextStrokePath(belowContext);
    
    //绘制上面的圆
    CGContextRef aboveContext = UIGraphicsGetCurrentContext();
    
    //弧度的终点
    CGFloat endAngle = - M_PI / 30 * self.offsetY - M_PI * 1.5;
    
    CGContextAddArc(aboveContext, self.width * 0.5, self.width * 0.5, radius, - M_PI * 1.5, endAngle, 0);
    
    [[UIColor whiteColor] set];
    
    CGContextStrokePath(aboveContext);
}

/**
 * 结束刷新
 */
- (void)endRefresh {
    
    if (self.offsetY < 0) {
        //如果滚动视图没恢复原位之前就已经加载完数据，就将隐藏状态设置为 YES
        self.isHidding = YES;
    }
    else {
        
        self.isRefreshing = NO;
        
        [self.activityView stopAnimating];
    }
}

@end
