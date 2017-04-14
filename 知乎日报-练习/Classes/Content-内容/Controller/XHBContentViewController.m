//
//  XHBContentViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/6.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBContentViewController.h"
#import "XHBRootViewController.h"
#import "XHBCatalogViewController.h"

/* 将屏幕的宽与高定义为宏 */
#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height

@interface XHBContentViewController ()

@property (strong, nonatomic) XHBCatalogViewController *leftViewController; //左边视图

@property (assign, nonatomic) float centerX; //中点X坐标
@property (assign, nonatomic) float centerY; //中点Y坐标

@end

@implementation XHBContentViewController

#pragma mark - viewController 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 设置初始中点坐标为屏幕中间 */
    self.centerX = screenWidth / 2.0;
    self.centerY = screenHeight / 2.0;
    
    /* 创建导航栏按钮 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImageName:@"Home_Icon" highImageName:@"Home_Icon_Highlight" target:self action:@selector(catalogClick)];
    
    /* 创建平移手势识别器 */
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveFinger:)];
    
    /* 将手势识别器添加到 view 上 */
    [self.view addGestureRecognizer:panGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 动作事件方法
/**
 * 导航栏按钮动作事件 
 */
- (void)catalogClick
{
    /* 移动类别视图 */
    if (self.navigationController.view.frame.origin.x == 0) { //如果左边视图的位置x坐标为0
        [UIView animateWithDuration:1.0 animations:^{
            self.navigationController.view.frame = CGRectMake(230, 0, screenWidth, screenHeight);
        }];
    }else {
        [UIView animateWithDuration:1.0 animations:^{
            self.navigationController.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        }];
    }
    
}

/**
 * 平移手势事件 
 */
//- (void)moveFinger:(UIPanGestureRecognizer *)pgr
//{
//    /* 手势开始 */
//    if (pgr.state == UIGestureRecognizerStateBegan) {
//        
//    }
//    /* 手势移动中 */
//    else if (pgr.state == UIGestureRecognizerStateChanged) {
//        
//        /* 获取手指拖动的值 */
//        CGPoint translation = [pgr translationInView:self.view];
//        
//        
//        /* 让主界面随着手指的水平移动而移动 */
//        CGRect frame = self.navigationController.view.frame;
////        CGRect frame = self.
//        frame.origin.x += translation.x;
//        self.navigationController.view.frame = frame;
//        
//        NSLog(@"%@", self.navigationController.view);
//        
//        /* 主界面向右移动的距离不能大于左边视图的宽度 */
//        if (self.navigationController.view.frame.origin.x >= self.leftViewController.view.frame.size.width) {
//            frame = self.navigationController.view.frame;
//            frame.origin.x = self.leftViewController.view.frame.size.width;
//            self.navigationController.view.frame = frame;
//        }
//        
//        /* 清空拖移距离，将手指当前的位置设置为手势的起始位置 */
//        [pgr setTranslation:CGPointZero inView:self.view];
//        
//    }
//    /* 手势结束 */
//    else if (pgr.state == UIGestureRecognizerStateEnded) {
//        /* 获取手势结束时主界面左上角的X坐标 */
//        CGFloat midViewX = self.navigationController.view.frame.origin.x;
//        
//        /* 如果手指向右滑动的距离小于左边界面宽度的一半，就让主界面回到原来的位置 */
//        if (midViewX > 0 && midViewX < (self.leftViewController.view.frame.size.width / 2.0)) {
//            
//            [UIView animateWithDuration:0.5 animations:^{
//                CGRect frame = self.navigationController.view.frame;
//                frame.origin.x = 0;
//                self.navigationController.view.frame = frame;
//            }];
//            
//        }
//        
//        /* 如果手指向右滑动的距离大于左边界面宽度的一半，就让左边界面显示出来 */
//        if (midViewX >= (self.leftViewController.view.frame.size.width / 2.0)) {
//            
//            [UIView animateWithDuration:0.5 animations:^{
//                CGRect frame = self.navigationController.view.frame;
//                frame.origin.x = self.leftViewController.view.frame.size.width;
//                self.navigationController.view.frame = frame;
//            }];
//        }
//    }

- (void)moveFinger:(UIPanGestureRecognizer *)recognizer
{
    /* 手势开始 */
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
    }
    /* 手势变化中 */
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        /* 获取手指移动距离的值 */
        CGPoint translation = [recognizer translationInView:self.view];
        
        /* 让主界面的中间点随着手指的移动而移动 */
        float x = self.view.center.x + translation.x;
        
        //不能让主界面向左移动
        if (x < self.centerX) {
            x = self.centerX;
        }
        
        self.navigationController.view.frame = CGRectMake(x, 0, screenWidth, screenHeight);
        
        /* 主界面向右移动的最大距离不能大于左边界面的宽度 */
        if ((self.view.center.x - screenWidth) >= self.leftViewController.view.frame.size.width) {
            x = self.view.center.x + self.leftViewController.view.frame.size.width;
            self.view.center = CGPointMake(x, self.centerY);
        }
        
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
    /* 手势结束 */
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
    }
    
}

@end
