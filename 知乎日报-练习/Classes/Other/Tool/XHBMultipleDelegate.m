//
//  XHBMultipleDelegate.m
//  知乎日报-练习
//
//  Created by 云趣科技 on 2017/12/21.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBMultipleDelegate.h"
#import <objc/runtime.h>

@interface XHBMultipleDelegate ()

@property (nonatomic, strong) NSHashTable *delegates; //代理数组，NSHashTable会自动将添加进来的对象保持弱引用
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation XHBMultipleDelegate

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        _delegates = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        
        //信号总量为1
        _semaphore = dispatch_semaphore_create(1);
    }
    
    return self;
}

#pragma mark - 代理对象的增删改查
- (void)addDelegate:(id)delegate {
    //信号总量 -1, 如果 -1 后信号为 -1，就一直等待(阻塞当前访问的线程)
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    [self.delegates addObject:delegate];
    
    //信号总量 +1, 如果前一个值为 -1 则唤醒等待的线程
    dispatch_semaphore_signal(self.semaphore);
}

- (void)removeDelegate:(id)delegate {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    [self.delegates removeObject:delegate];
    dispatch_semaphore_signal(self.semaphore);
}


#pragma mark - runtime 方法转发
/**
 返回方法签名，若方法签名不为nil，调用forwardInvocation: 方法。
 否则调用异常方法

 @param aSelector 方法的选择器
 @return 方法签名对象
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    NSMethodSignature *result = nil;
    
    //所有代理遵守的是同一个协议，所以方法签名也一样，找到一个返回就可以
    for (id delegate in self.delegates) {
        if ([delegate respondsToSelector:aSelector]) {
            
            //获取 delegate 的 aSelector 的方法签名
            result = [delegate methodSignatureForSelector:aSelector];
            
            if (result) {
                dispatch_semaphore_signal(self.semaphore);
                return result;
            }
        }
    }
    
    dispatch_semaphore_signal(self.semaphore);
    
    NSLog(@"没有找到方法签名");
    
    return nil;
}

/**
 将消息转发给其他对象

 @param anInvocation 调用转发对象
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    for (id delegate in self.delegates) {
        
        //看看delegate是否实现了要调用的方法，有些可能没有实现
        if ([delegate respondsToSelector:anInvocation.selector]) {
            
            //因为是异步来调用方法转发，所以要复制 invocation，不然可能会被替换掉
            NSInvocation *invocation = [self duplicateInvocation:anInvocation];
            invocation.target = delegate;
            
            //使用异步方法来调用，所有代理都能够及时响应
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [invocation invoke];
            });
        }
    }
    
    dispatch_semaphore_signal(self.semaphore);
}

/**
 复制 Invocation 对象并返回复制后的对象

 @param invocation 要复制的 invocation 对象
 @return 复制后的 invocation 对象
 */
- (NSInvocation *)duplicateInvocation:(NSInvocation *)invocation {
    
    NSMethodSignature *methodSignature = invocation.methodSignature;
    
    //根据方法签名创建一个 Invocation 对象，新创建的 invocation 对象要添加 selector 和 参数才能调用
    NSInvocation *dupInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    dupInvocation.selector = invocation.selector;
    
    //传进来的 invocation 对象的参数数量
    NSInteger count = methodSignature.numberOfArguments;
    
    for (NSInteger i = 2; i < count; i++) {
        void *value;
        //获取参数
        [invocation getArgument:&value atIndex:i];
        [dupInvocation setArgument:&value atIndex:i];
    }
    
    //持有参数的引用，因为有可能会在调用前被释放掉
    [dupInvocation retainArguments];
    
    return dupInvocation;
}

@end
