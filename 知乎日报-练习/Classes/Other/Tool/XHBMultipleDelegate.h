//
//  XHBMultipleDelegate.h
//  知乎日报-练习
//
//  Created by 云趣科技 on 2017/12/21.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBMultipleDelegate : NSObject

/**
 添加代理

 @param delegate 需要添加的代理
 */
- (void)addDelegate:(id)delegate;

/**
 移除代理

 @param delegate 需要移除的代理
 */
- (void)removeDelegate:(id)delegate;

@end
