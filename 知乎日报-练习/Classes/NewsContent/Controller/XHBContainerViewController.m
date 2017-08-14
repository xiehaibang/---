//
//  XHBContainerViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/4.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBContainerViewController.h"
#import "XHBNewsContentViewController.h"

@interface XHBContainerViewController () <XHBNewsContentControllerDelegate>

/** 容器底层的滚动视图 */
@property (strong, nonatomic) UIScrollView *containerScrollView;

/** 容器上层的滚动视图 */
@property (strong, nonatomic) XHBNewsContentViewController *newsContentVC;

@end

@implementation XHBContainerViewController

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //容器对象视图的设置
    [self setupView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 一些视图的创建和设置
/**
 * 设置容器对象的视图
 */
- (void)setupView {
    //将自动调整滚动视图插入关闭
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
    //初始化 containerScrollView 并设置
    [self setupScrollView];
    
    self.newsContentVC = [self setupNewsContentVC];
    
    [self.containerScrollView addSubview:self.newsContentVC.view];

    
    //将新闻内容页对象添加为容器对象的子对象
    [self addChildViewController:self.newsContentVC];
}

/**
 * 创建并设置一个 scrollView
 */
- (void)setupScrollView {
    
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    //设置 scrollView 的 content 大小
    self.containerScrollView.contentSize = CGSizeMake(screenWidth, screenHeight * 3);
    
    //刚开始显示的位置
    self.containerScrollView.contentOffset = CGPointMake(0, screenHeight);
    
    //关闭滚动指示器
    self.containerScrollView.showsVerticalScrollIndicator = NO;
    self.containerScrollView.showsHorizontalScrollIndicator = NO;
    
    //打开分页效果
    self.containerScrollView.pagingEnabled = YES;
    
    //关闭滚动到内容边界时的反弹效果
    self.containerScrollView.bounces = NO;
    
    //关闭滚动功能
    self.containerScrollView.scrollEnabled = NO;
    
    [self.view addSubview:self.containerScrollView];
}

/**
 * 通过偏移倍数，设置 scrollView 的滚动偏移值
 */
- (void)setupContentOffset:(CGFloat)number {
    
    //创建上一条或者下一条新闻的内容对象
    XHBNewsContentViewController *newsContentVC = [self setupNewsContentVC];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        //将 scrollView 偏移到下一页
        self.containerScrollView.contentOffset = CGPointMake(0, number * screenHeight);
        
    } completion:^(BOOL finished) {
        
        //移除当前容器的子控制器
        [self.newsContentVC removeFromParentViewController];
        
        //移除在当前 containerScrollView 上的 新闻内容视图
        [self.newsContentVC.view removeFromSuperview];
        
        _newsContentVC = nil;
        
        /* 先将 containerScrollView 的视图移回去在将新的新闻内容页添加到 scrollView 上，不然就会有从下又往上偏移的感觉 */
        //将 containerScrollView 的视角移回中间
        self.containerScrollView.contentOffset = CGPointMake(0, screenHeight);
        
        self.newsContentVC = newsContentVC;
        
        [self.containerScrollView addSubview:self.newsContentVC.view];
        
        [self addChildViewController:self.newsContentVC];
    }];
}

/**
 * 创建和设置一个 XHBNewsContentViewController 的对象，然后将它返回
 */
- (XHBNewsContentViewController *)setupNewsContentVC {
    
    XHBNewsContentViewController *newsContentVC = [[XHBNewsContentViewController alloc] init];
    
    newsContentVC.view.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight);
    
    newsContentVC.newsId = self.newsId;
    
    newsContentVC.containerDelegate = self;
    
    if (self.homeVC) {
        newsContentVC.newsListDelegate = (id)self.homeVC;
    }
    else if (self.themeVC) {
        newsContentVC.newsListDelegate = (id)self.themeVC;
    }
    
    
    return newsContentVC;
    
}


#pragma mark - 新闻内容页的代理方法
/**
 * 滚动到下一条新闻
 */
- (void)scrollToNextViewWithNewsId:(NSInteger)newsId {
    
    self.newsId = newsId;
    
    //通过偏移倍数，设置 scrollView 的滚动偏移值
    [self setupContentOffset:2];
}

/**
 * 滚动到上一条新闻
 */
- (void)scrollToPreviousViewWithNewsId:(NSInteger)newsId {
    
    self.newsId = newsId;
    
    //通过偏移倍数，设置 scrollView 的滚动偏移值
    [self setupContentOffset:0];
}


@end
