//
//  XHBRootViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/10.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBRootViewController.h"

@interface XHBRootViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *tapGR;

@end

@implementation XHBRootViewController

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //控制器初始化
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 控制器初始化
- (void)setup
{
    /* 添加子控制器和子视图 */
    [self addChildViewController:self.leftViewController];
    [self.view addSubview:self.leftViewController.view];
    
    [self addChildViewController:self.midViewController];
    [self.view addSubview:self.midViewController.view];
    
    /* 设置leftViewController的大小，和midViewController移动的距离一样大 */
    self.leftViewController.view.frame = CGRectMake(0, 0, 230, [[UIScreen mainScreen] bounds].size.height);
    
    /* 创建一个拖动手势以及手势动作监听事件 */
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    /* 将手势添加到 midView 中 */
    [self.midViewController.view addGestureRecognizer:panGR];
    
    /* 创建一个点击手势以及手势动作监听事件 */
    self.tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    /* 将手势添加到 midView 中 */
    [self.midViewController.view addGestureRecognizer:self.tapGR];
}

#pragma mark - 手势动作事件
/**
 * 计算视图的水平偏移量
 */
- (CGRect)frameWithOffsetX:(CGFloat)offsetX
{
    /* 根据偏移量改变 midViewController 的 view 的水平位置 */
    CGRect frame = self.midViewController.view.frame;
    frame.origin.x += offsetX;
    
    //不让手指拖动的距离大于左边视图的宽度
    if (frame.origin.x > self.leftViewController.view.frame.size.width) {
        frame.origin.x = self.leftViewController.view.frame.size.width;
    }
    //并且不让手指手指向左拖动
    else if (frame.origin.x < 0) {
        frame.origin.x = 0;
    }
    
    return frame;
}

/**
 * 手势拖动的监听方法
 */
- (void)pan:(UIPanGestureRecognizer *)pan
{
    /* 手势变化状态 */
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        /* 获取手势拖动的偏移量 */
        CGPoint offset = [pan translationInView:self.midViewController.view];
        
        self.midViewController.view.frame = [self frameWithOffsetX:offset.x];
        
    }
    /* 手势结束状态 */
    else if (pan.state == UIGestureRecognizerStateEnded) {
        
        /* 手势结束时，中间视图的水平位置 */
        CGFloat midViewX = self.midViewController.view.frame.origin.x;
        CGFloat leftViewWidth = self.leftViewController.view.frame.size.width;
        
        /* 当视图处于小于左边视图宽度一半的位置时，让视图回到原位 */
        if (midViewX > 0 && midViewX < (leftViewWidth / 2.0)) {
            
            //偏移量
            CGFloat offsetX = 0 - midViewX;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.midViewController.view.frame = [self frameWithOffsetX:offsetX];
                
            }];
        }
        
        /* 当视图处于大于左边视图宽度一半的位置时，让左边视图全部显示出来 */
        if (midViewX > (leftViewWidth / 2.0)) {
            
            //偏移量
            CGFloat offsetX = leftViewWidth - midViewX;
            
            [UIView animateWithDuration:0.5 animations:^{
                self.midViewController.view.frame = [self frameWithOffsetX:offsetX];
            }];
            
            self.tapGR.cancelsTouchesInView = YES;
            
        }
    }
    
    /* 将偏移量复位 */
    [pan setTranslation:CGPointZero inView:self.midViewController.view];
}

/**
 * 手势点击的监听方法
 */
- (void)tap:(UITapGestureRecognizer *)tap
{
    /* 让视图回归原位 */
    //midView 当前的位置
    CGFloat midViewX = self.midViewController.view.frame.origin.x;
    
    //偏移量
    CGFloat offsetX = 0 - midViewX;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.midViewController.view.frame = [self frameWithOffsetX:offsetX];
    }];
    
    if (midViewX == 0) {
        self.tapGR.cancelsTouchesInView = NO;
    }
}

@end
