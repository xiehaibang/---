//
//  XHBRootViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/10.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBRootViewController.h"
#import "XHBCatalogViewController.h"
#import "XHBNavigationController.h"
#import "XHBThemeViewController.h"
#import "XHBMultipleDelegate.h"

@interface XHBRootViewController ()<NSCopying>

/** 其他主题日报对象 */
@property (nonatomic, strong) XHBThemeViewController *themeVC;
@property (nonatomic, strong) XHBMultipleDelegate *multipleDelegate;

/** 滑动手势对象 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGR;
/** 点击手势对象 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;

@end

@implementation XHBRootViewController

#pragma mark - 全局变量
/* 创建一个全局静态的单例对象 */
static id sharedInstance = nil;
//滑动菜单动画时间
static CGFloat const animateDuration = 0.3;

#pragma mark - 创建单例
/**
 * 重写 allocWithZone: 方法，让它返回单例
 * 类方法 alloc 会默认调用此方法来创建实例
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:nil];
    });
    
    return sharedInstance;
}

/**
 * 重写初始化方法，让它返回单例
 */
- (instancetype)init {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super init];
        
        /* 如果 self 不为空 */
        if (sharedInstance) {
            
            /* 初始化设置 */
            [self initialSetup];
        }
    });
    
    
    return sharedInstance;
}

/**
 * 返回单例
 */
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /* 在类方法中，self 指的是类，而不是对象 */
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

/**
 * 重写 copyWithZone: 方法，让它返回单例
 */
- (id)copyWithZone:(NSZone *)zone {
    return sharedInstance;
}

/**
 * 返回单例
 */
- (id)mutableCopyWithZone:(NSZone *)zone {
    return sharedInstance;
}



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
/**
 * 初始化设置
 */
- (void)initialSetup {
    /* 创建左边目录模块 */
    XHBCatalogViewController *catalogVC = [[XHBCatalogViewController alloc] init];
    
    /* 创建右边内容模块 */
    self.homeVC = [[XHBHomeViewController alloc] init];
    
    /* 将左边的目录模块加入自定义导航控制器 */
    XHBNavigationController *catalogNav = [[XHBNavigationController alloc] initWithRootViewController:catalogVC];
    
    /* 将右边的内容模块加入自定义导航控制器 */
    XHBNavigationController *homeNav = [[XHBNavigationController alloc] initWithRootViewController:self.homeVC];
    
    /* 将目录模块和内容模块分别加入左边和中间的视图 */
    self.leftViewController = (XHBBaseViewController *)catalogNav;
    self.midViewController = (XHBBaseViewController *)homeNav;
//    self.midViewController = self.homeVC;
}

/**
 * 视图加载时设置 
 */
- (void)setup {
    /* 添加子控制器和子视图 */
    [self addChildViewController:self.leftViewController];
    [self.view addSubview:self.leftViewController.view];
    
    [self addChildViewController:self.midViewController];
    [self.view addSubview:self.midViewController.view];
    [self.midViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    /* 设置leftViewController的大小，和midViewController移动的距离一样大 */
    self.leftViewController.view.frame = CGRectMake(-230, 0, 230, [[UIScreen mainScreen] bounds].size.height);
    
    /* 添加手势 */
    [self addGestureForView:self.homeVC.view];
}



#pragma mark - 手势动作事件
/**
 * 创建和添加手势
 */
- (void)addGestureForView:(UIView *)view {
    /* 创建一个拖动手势以及手势动作监听事件 */
    self.panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    //将拖动手势添加到 homeVC 的视图中
    [view addGestureRecognizer:self.panGR];
    
    /* 创建一个点击手势以及手势动作监听事件 */
    self.tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    //将点击手势添加到 homeVC 的视图中
    [view addGestureRecognizer:self.tapGR];

}

/**
 * 移除手势 
 */
- (void)removeGesture {
//    [self.midViewController.view removeGestureRecognizer:self.panGR];
    [self.homeVC.view removeGestureRecognizer:self.panGR];
    [self.midViewController.view removeGestureRecognizer:self.tapGR];
}

/**
 * 计算视图的水平偏移量
 */
- (CGRect)frameWithOffsetX:(CGFloat)offsetX viewController:(UIViewController *)viewController{
    
    if ([self.midViewController isEqual:viewController]) {
        
        /* 根据偏移量改变 midViewController 的 view 的水平位置 */
        CGRect frame = self.midViewController.view.frame;
        frame.origin.x += offsetX;
        
        //移动的距离不能大于左边视图的宽度
        if (frame.origin.x > self.leftViewController.view.frame.size.width) {
            frame.origin.x = self.leftViewController.view.frame.size.width;
        }
        else if (frame.origin.x < 0) { //完全隐藏以后不移动
            frame.origin.x = 0;
        }
        
        return frame;
    }
    
    /* 根据偏移量改变 leftViewController 的 view 的水平位置 */
    CGRect frame = self.leftViewController.view.frame;
    
    frame.origin.x += offsetX;
    
    //移动的距离不能大于左边视图的宽度
    if (fabs(frame.origin.x) > self.leftViewController.view.frame.size.width) {
        frame.origin.x = 0 - self.leftViewController.view.frame.size.width;
    }
    else if (frame.origin.x > 0) { //完全显示以后不移动
        frame.origin.x = 0;
    }
    
    return frame;
    
}

/**
 * 手势拖动的监听方法
 */
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    WeakSelf(weakSelf);
    
    /* 手势变化状态 */
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        //停止计时器
        [self.homeVC.topView stopTimer];
        
        /* 获取手势拖动的偏移量 */
        CGPoint offset = [pan translationInView:self.midViewController.view];
        
        self.midViewController.view.frame = [self frameWithOffsetX:offset.x viewController:self.midViewController];
        
        self.leftViewController.view.frame = [self frameWithOffsetX:offset.x viewController:self.leftViewController];
        
        self.menuStatus = XHBMenuStatusMoving;
        
        [self menuStatusChange];
    }
    /* 手势结束状态 */
    else if (pan.state == UIGestureRecognizerStateEnded) {
        
        /* 手势结束时，中间视图的水平位置 */
        CGFloat midViewX = self.midViewController.view.frame.origin.x;
        CGFloat leftViewWidth = self.leftViewController.view.frame.size.width;
        
        /* 当视图处于小于左边视图宽度 1/5 的位置时，让视图回到原位 */
        if (midViewX > 0 && midViewX < (leftViewWidth / 5.0)) {
            
            //偏移量
            CGFloat offsetX = 0 - midViewX;
            
            [UIView animateWithDuration:animateDuration animations:^{
                weakSelf.midViewController.view.frame = [weakSelf frameWithOffsetX:offsetX viewController:weakSelf.midViewController];
                
                weakSelf.leftViewController.view.frame = [weakSelf frameWithOffsetX:offsetX viewController:weakSelf.leftViewController];
                
                weakSelf.menuStatus = XHBMenuStatusHidden;

            } completion:^(BOOL finished) {
                [weakSelf menuStatusChange];
            }];
            
        }
        
        /* 当视图处于大于左边视图宽度 1/5 的位置时，让左边视图全部显示出来 */
        if (midViewX > (leftViewWidth / 5.0)) {
            
            //偏移量
            CGFloat offsetX = leftViewWidth - midViewX;
            
            [UIView animateWithDuration:animateDuration animations:^{
                weakSelf.midViewController.view.frame = [weakSelf frameWithOffsetX:offsetX viewController:weakSelf.midViewController];
                
                weakSelf.leftViewController.view.frame = [weakSelf frameWithOffsetX:offsetX viewController:weakSelf.leftViewController];
                
                weakSelf.menuStatus = XHBMenuStatusDisplay;
                
            } completion:^(BOOL finished) {
                [weakSelf menuStatusChange];
                
                //是否取消touch事件的传递，若为YES，只有tap手势能响应事件
                weakSelf.tapGR.cancelsTouchesInView = YES;
            }];

        }
        
        //启动计时器
        [self.homeVC.topView startTimer];
    }
    
    /* 将偏移量复位 */
    [pan setTranslation:CGPointZero inView:self.midViewController.view];
}

/**
 * 手势点击的监听方法
 */
- (void)tap:(UITapGestureRecognizer *)tap {
    
    WeakSelf(weakSelf);
    
    /* 让视图回归原位 */
    //midView 当前的位置
    CGFloat midViewX = self.midViewController.view.frame.origin.x;
    
    //偏移量
    CGFloat offsetX = 0 - midViewX;
    
    [UIView animateWithDuration:animateDuration animations:^{
        weakSelf.midViewController.view.frame = [weakSelf frameWithOffsetX:offsetX viewController:weakSelf.midViewController];
        weakSelf.leftViewController.view.frame = [weakSelf frameWithOffsetX:offsetX viewController:weakSelf.leftViewController];

        weakSelf.menuStatus = XHBMenuStatusHidden;
        
    } completion:^(BOOL finished) {
        [weakSelf menuStatusChange];
    }];
    
    if (midViewX == 0) {
        //是否取消touch事件的传递，若为YES，只有tap手势能响应事件
        self.tapGR.cancelsTouchesInView = NO;
    }
}

/**
 * 按动导航栏按钮时显示或隐藏导航栏菜单
 */
- (void)navigationButton {
    
    WeakSelf(weakSelf);
    
    /* 若导航栏是隐藏的，就将它显示，否则隐藏 */
    if (self.midViewController.view.frame.origin.x == 0) { //显示
        
        [UIView animateWithDuration:animateDuration animations:^{
            weakSelf.midViewController.view.frame = [weakSelf frameWithOffsetX:230 viewController:weakSelf.midViewController];
            weakSelf.leftViewController.view.frame = [weakSelf frameWithOffsetX:230 viewController:weakSelf.leftViewController];
            
            weakSelf.menuStatus = XHBMenuStatusDisplay;

        } completion:^(BOOL finished) {
            [weakSelf menuStatusChange];
            
            //是否取消touch事件的传递，若为YES，只有tap手势能响应事件
            weakSelf.tapGR.cancelsTouchesInView = YES;
        }];
    }
    else { //隐藏
        
        [UIView animateWithDuration:animateDuration animations:^{
            weakSelf.midViewController.view.frame = [weakSelf frameWithOffsetX:-230 viewController:weakSelf.midViewController];
            weakSelf.leftViewController.view.frame = [weakSelf frameWithOffsetX:-230 viewController:weakSelf.leftViewController];
            
            weakSelf.menuStatus = XHBMenuStatusHidden;
            
        } completion:^(BOOL finished) {
            [weakSelf menuStatusChange];
            
            //是否取消touch事件的传递，若为YES，只有tap手势能响应事件
            weakSelf.tapGR.cancelsTouchesInView = NO;
        }];
    }
}


#pragma mark - 菜单状态
/**
 菜单状态改变
 */
- (void)menuStatusChange {
    
    [(id<XHBSlideMenuDelegate>)self.multipleDelegate menuStatusChangedWithStatus:self.menuStatus];
//    if ([self.delegate respondsToSelector:@selector(menuStatusChangedWithStatus:)]) {
//        [self.delegate menuStatusChangedWithStatus:self.menuStatus];
//    }
}


#pragma mark - 切换不同的分类
/**
 * 切换到首页新闻 
 */
- (void)showHomeCategory {
    
    /* 切换的时候将菜单列表的位置复原 */
    if (self.leftViewController.view.frame.origin.x == 0) {
        
        self.leftViewController.view.frame = [self frameWithOffsetX:-230 viewController:self.leftViewController];
        
    }
    
    /* 移除当前控制器和视图 */
//    [self.midViewController removeFromParentViewController];
    [self.midViewController.view removeFromSuperview];
    
    /* 创建首页对象 */
    self.homeVC = [[XHBHomeViewController alloc] init];
    
    /* 将首页对象设置为导航控制器的根控制器 */
    XHBNavigationController *homeNav = [[XHBNavigationController alloc] initWithRootViewController:self.homeVC];
    
    /* 将导航控制器赋给内容模块 */
    self.midViewController = (XHBBaseViewController *)homeNav;
    
    /* 添加首页对象的控制器和视图到当前类的对象中 */
//    [self addChildViewController:self.midViewController];
    [self.view addSubview:self.midViewController.view];
    

    /* 添加手势 */
    [self addGestureForView:self.homeVC.view];
    
}

/**
 * 切换到其他主题日报新闻
 */
- (void)showOtherCategory {
    
    /* 切换的时候将菜单列表的位置复原 */
    if (self.leftViewController.view.frame.origin.x == 0) {
        
        self.leftViewController.view.frame = [self frameWithOffsetX:-230 viewController:self.leftViewController];
        
    }
    
//    [self.midViewController removeFromParentViewController];
    [self.midViewController.view removeFromSuperview];
    
    /* 创建其他主题日报对象 */
    self.themeVC = [[XHBThemeViewController alloc] init];
    
    /* 若主题日报 id 不为空，则将它赋给 themeVC 对象 */
    if (self.ID != NSNotFound) {
        self.themeVC.ID = self.ID;
    }
    
    /* 将其他主题日报对象加入导航控制器 */
    XHBNavigationController *themeNav = [[XHBNavigationController alloc] initWithRootViewController:self.themeVC];
    
    /* 将导航控制器赋给目录模块 */
    self.midViewController = (XHBBaseViewController *)themeNav;
    
    /* 添加首页对象的控制器和视图到当前类的对象中 */
//    [self addChildViewController:self.midViewController];
    [self.view addSubview:self.midViewController.view];
    
    /* 添加手势 */
    [self addGestureForView:self.themeVC.view];
    
}


#pragma mark - setter
- (void)setDelegate:(id<XHBSlideMenuDelegate>)delegate {
    
    [self.multipleDelegate addDelegate:delegate];
    
    _delegate = delegate;
}

#pragma mark - 懒加载
- (XHBHomeViewController *)homeVC {
    
    if (!_homeVC) {
        _homeVC = [[XHBHomeViewController alloc] init];
    }
    
    return _homeVC;
}

- (XHBThemeViewController *)themeVC {
    
    if (!_themeVC) {
        _themeVC = [[XHBThemeViewController alloc] init];
    }
    
    return _themeVC;
}

- (XHBMultipleDelegate *)multipleDelegate {
    
    if (!_multipleDelegate) {
        _multipleDelegate = [[XHBMultipleDelegate alloc] init];
    }
    
    return _multipleDelegate;
}

@end
