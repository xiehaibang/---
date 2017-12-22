//
//  XHBHomeTopView.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/12.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 声明事件的 block 类型 */
typedef void (^actionBlock)(NSInteger newsId);

@interface XHBHomeTopView : UIView

/** 顶部新闻数组 */
@property (nonatomic, strong) NSArray *topNews;
/** 计时器对象 */
@property (nonatomic, strong) NSTimer *timer;
/** 顶部滚动视图 */
@property (nonatomic, readonly, strong) UIScrollView *carouselScroll;
/** 点击事件的 block */
@property (nonatomic, copy) actionBlock tapActionBlock;


/**
 * 将 XHBHomeTopView 固定在传进来的视图上，并且监听传进来的滚动视图的偏移值
 */
+ (XHBHomeTopView *)attachToView:(UIView *)view observeScrollView:(UIScrollView *)scrollView;

/**
 * 创建计时器
 */
- (void)createTimer;

/**
 * 启动计时器
 */
- (void)startTimer;

/**
 * 停止轮播图的计时器
 */
- (void)stopTimer;

- (void)deleteTimer;

@end
