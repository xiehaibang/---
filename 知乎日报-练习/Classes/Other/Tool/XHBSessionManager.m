//
//  XHBSessionManager.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/18.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBSessionManager.h"
#import <AFNetworking/AFNetworking.h>

static AFHTTPSessionManager *manager;

@implementation XHBSessionManager

+ (AFHTTPSessionManager *)sharedHttpSessionManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    
    return manager;
}

@end
