//
//  XHBScreenShotBackView.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/7/15.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBScreenShotBackView.h"
#import "AppDelegate.h"

#pragma mark - 全局变量
/* 监听标识,需要 c 语言的类型 */
static char listenViewMove[] = "listenViewMove";

/* 遮罩视图的透明度常量 */
static CGFloat maskAlpha = 0.4;

@implementation XHBScreenShotBackView

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //设置视图的背景颜色
        self.backgroundColor = [UIColor blackColor];
        
        /* 初始化屏幕快照的图片和遮罩视图 */
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        
        /* 设置遮罩视图的背景颜色 */
        self.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:maskAlpha];
        
        [self addSubview:self.imageView];
        [self addSubview:self.maskView];
        
        /* 监听 APP 根视图的位移 */
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:listenViewMove];
    }
    
    return self;
}


#pragma mark - 事件触发
/**
 * 监听 APP 根视图触发时的方法
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (context == listenViewMove) {
        
        /* 将位移以后的值取出来 */
        NSValue *value = [change objectForKey:NSKeyValueChangeNewKey];
        CGAffineTransform newTransform = [value CGAffineTransformValue];
        [self showEffectChange:CGPointMake(newTransform.tx, 0)];
    }
}


/**
 * 视图位移的效果
 */
- (void)showEffectChange:(CGPoint)point {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (point.x > 0) {
        /* 让遮罩的透明度随着视图的位移改变 */
        self.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:-point.x / screenWidth * maskAlpha + maskAlpha];
        
        /* 让屏幕快照的缩放随着视图的位移改变 */
//        self.imageView.transform = CGAffineTransformMakeScale(0.95 + (point.x / screenWidth * 0.05), 0.95 + (point.x / screenWidth * 0.05));
    }
}


#pragma mark - 视图销毁
- (void)dealloc {
    
    /* 移除监听者 */
    [[UIApplication sharedApplication].delegate.window.rootViewController.view removeObserver:self forKeyPath:@"transform" context:listenViewMove];
}

@end
