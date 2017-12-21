//
//  XHBSessionManager.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/18.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

@interface XHBSessionManager : NSObject

+ (AFHTTPSessionManager *)sharedHttpSessionManager;

@end
