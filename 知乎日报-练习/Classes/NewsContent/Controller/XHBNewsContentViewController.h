//
//  XHBNewsContentViewController.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/5/22.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBBaseViewController.h"

//@class WKWebView;

@protocol XHBNewsContentControllerDelegate <NSObject>

@optional
/**
 * 通知 containerController 滚动到下一条新闻
 */
- (void)scrollToNextViewWithNewsId:(NSInteger)newsId;

/**
 * 通知 containerController 滚动到上一条新闻 
 */
- (void)scrollToPreviousViewWithNewsId:(NSInteger)newsId;

/**
 * 通过本条新闻的 id 获取下一条新闻的 id
 */
- (NSInteger)getNextNewsWithNewsId:(NSInteger)newsId;

/**
 * 通过本条新闻的 id 获取上一条新闻的 id
 */
- (NSInteger)getPreviousNewsWithNewsId:(NSInteger)newsId;

/**
 * 判断本条新闻是不是第一条新闻
 */
- (BOOL)isFirstNewsWithNewsId:(NSInteger)newsId;

/**
 * 判断本条新闻是不是最后一条新闻
 */
- (BOOL)isLastNewsWithNewsId:(NSInteger)newsId;

@end


@interface XHBNewsContentViewController : XHBBaseViewController

/** 新闻 id */
@property (assign, nonatomic) NSInteger newsId;

/** 指向容器的代理对象 */
@property (weak, nonatomic) id<XHBNewsContentControllerDelegate> containerDelegate;

/** 指向首页的代理对象 */
@property (weak, nonatomic) id<XHBNewsContentControllerDelegate> newsListDelegate;


@end
