//
//  XHBNavigationController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/6.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBNavigationController.h"
#import "XHBBaseViewController.h"
#import "XHBRootViewController.h"

#import "AppDelegate.h"


@interface XHBNavigationController ()<UIGestureRecognizerDelegate>

/** 屏幕快照数组 */
@property (strong, nonatomic) NSMutableArray *screenShotArray;

/** 自定义拖动返回手势 */
@property (strong, nonatomic) UIPanGestureRecognizer *backPanGesture;

/** 应用的单例 */
@property (strong, nonatomic) AppDelegate *appdelegate;

@end


#pragma mark - 全局变量
//屏幕的宽高
static CGFloat screenWidth;
static CGFloat screenHeight;


@implementation XHBNavigationController

#pragma mark - 初始化
- (id)initWithRootViewController:(UIViewController *)rootViewController {
    
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {
        /* 初始化屏幕快照的数组 */
        self.screenShotArray = [NSMutableArray array];
        
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        
    }
    
    return self;
}

#pragma mark - 导航控制器的生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /* 将UINavigationBar的背景图片设置为无图片 */
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    /* 设置UInavigationBar下面的细线为无图片 */
    self.navigationBar.shadowImage = [UIImage new];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 屏蔽系统的手势 */
    self.interactivePopGestureRecognizer.enabled = NO;
    
    /* 初始化自定义拖动手势 */
    self.backPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fingerMoveBack:)];
    
    /* 设置自定义手势的代理 */
    self.backPanGesture.delegate = self;
    
    [self.view addGestureRecognizer:self.backPanGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIGestureRecognizerDelegate 方法
/**
 * 向代理询问手势是否应该开始识别
 */
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    /* 若产生手势的视图是当前视图 */
    if (gestureRecognizer.view == self.view) {
        
        XHBBaseViewController *topVC = (XHBBaseViewController *)self.topViewController;
        
        /* 当前的顶部视图控制器是否支持自定义拖动手势 */
        if (!topVC.enablePanGesture) {
            return NO;
        }
        else {
            
            /* 获取手指位移的距离 */
            CGPoint translate = [gestureRecognizer translationInView:self.view];
            
            /* 判断是否只在水平方向位移 */
            if (translate.x != 0 && fabs(translate.y) == 0) {
                return YES;
            }
            else {
                return NO;
            }
        }
    }
    
    return NO;
}

/**
 * 询问代理是否允许两个手势识别器同时识别手势，解决手势冲突
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    /* 若同时识别的其他手势也为 UIPanGestureRecognizer */
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")]) {
        
        UIView *view = otherGestureRecognizer.view;
        
        /* 若手势的视图类型为 UIScrollView */
        if ([view isKindOfClass:NSClassFromString(@"UIScrollView")]) {
            
            UIScrollView *scrollView = (UIScrollView *)view;
            
            /* 若 scrollView 的偏移量为 0 */
            if (scrollView.contentOffset.x == 0) {
                return YES;
            }
            
            return NO;
        }
        
    }
    
    return YES;
}

#pragma mark - 手势响应方法
/**
 * 手指拖动返回
 */
- (void)fingerMoveBack:(UIPanGestureRecognizer *)panGesture {
    
    /* 获取应用的中间视图 */
    XHBBaseViewController *midVC = [XHBRootViewController sharedInstance].midViewController;
    
    /* 若目前在导航控制器里面的 viewController 只有一个，就返回 */
    if (self.viewControllers.count == 1) {
        return;
    }
    
    //拖动手势开始时
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
        //显示屏幕快照的视图
        self.appdelegate.screenShotView.hidden = NO;
    }
    //拖动手势变化时
    else if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        //获取手指位移距离
        CGPoint translate = [panGesture translationInView:self.view];
        
        //如果位移的距离大于或等于10，则让视图跟着移动
        if (translate.x >= 10) {
            
            //让 window 根视图跟着移动
            midVC.view.transform = CGAffineTransformMakeTranslation(translate.x - 10, 0);
        }
    }
    //拖动手势结束时
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        //获取手指位移的距离
        CGPoint translate = [panGesture translationInView:self.view];
        
        //如果拖动的视图位移有 90，就 pop 掉
        if (translate.x >= screenWidth / 2.0) {
            
            [UIView animateWithDuration:0.5 animations:^{
                //让视图消失在视线中
                midVC.view.transform = CGAffineTransformMakeTranslation(screenWidth, 0);
                
            } completion:^(BOOL finished) {
                
                //pop 掉当前拖动的视图
                [self popViewControllerAnimated:NO];
                
                //将 rootVC 的坐标原点还原，并且隐藏屏幕快照视图
                midVC.view.transform = CGAffineTransformIdentity;
                self.appdelegate.screenShotView.hidden = YES;
                
            }];
        }
        else {
            [UIView animateWithDuration:0.5 animations:^{
                
                midVC.view.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
                self.appdelegate.screenShotView.hidden = YES;
                
            }];
        }
    }
}


#pragma mark - 重写 NavigationController push 的方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count == 0) {
        
        return [super pushViewController:viewController animated:animated];
        
    }
    else if (self.viewControllers.count >= 1) { //当导航控制器有了根视图以后
        
        //新建一个基于位图的上下文并设置为当前上下文
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(screenWidth, screenHeight), YES, 0);
        
        //将当前上下文渲染到 window 的 layer 层
        [self.appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        //根据当前的图形上下文的内容返回图像
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //从堆栈顶部删除当前基于位图的图形上下文
        UIGraphicsEndImageContext();
        
        //将获取到的上下文的图像加入到屏幕快照数组中，并将它赋给屏幕快照视图
        [self.screenShotArray addObject:viewImage];
        self.appdelegate.screenShotView.imageView.image = viewImage;
        
        [super pushViewController:viewController animated:animated];
    }
}


#pragma mark - 重写 NavigationController pop 的方法
/**
 * 弹出顶层的控制器
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    //pop 以后就移除上一层视图的屏幕快照
    [self.screenShotArray removeLastObject];
    
    //获取上上层的屏幕快照，如果它存在，则将它赋给屏幕快照视图
    UIImage *image = [self.screenShotArray lastObject];
    
    if (image) {
        self.appdelegate.screenShotView.imageView.image = image;
    }
    
    return [super popViewControllerAnimated:animated];
}

/**
 * 弹出视图控制器，直到指定的视图控制器位于导航堆栈的顶部。
 */
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSArray *viewControllers = [super popToViewController:viewController animated:animated];
    
    //若屏幕快照比弹出的视图控制器多
    if (self.screenShotArray.count > viewControllers.count) {
        
        for (NSInteger i = 0; i < viewControllers.count; i++) {
            [self.screenShotArray removeLastObject];
        }
    }
    else { //若相等，则只剩下 rootViewController，移除所有屏幕快照
        
        [self.screenShotArray removeAllObjects];
        
        return viewControllers;
    }
    
    //获取顶层视图上层的屏幕快照
    UIImage *image = [self.screenShotArray lastObject];
    
    if (image) {
        self.appdelegate.screenShotView.imageView.image = image;
    }
    
    return viewControllers;
}

/**
 * 弹出除了根视图控制器之外的堆栈上的所有视图控制器，并更新显示。
 */
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    
    //移除所有屏幕快照
    [self.screenShotArray removeAllObjects];
    
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark - 懒加载
- (AppDelegate *)appdelegate {
    
    if (!_appdelegate) {
        _appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    return _appdelegate;
}

@end
