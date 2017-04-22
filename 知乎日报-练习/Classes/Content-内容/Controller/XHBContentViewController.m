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
#import "XHBDayNews.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
//#import <SDWebImage/SDImageCache.h>
#import "UIImageView+WebCache.h"

/* 将屏幕的宽与高定义为宏 */
#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height

@interface XHBContentViewController () <UIScrollViewDelegate>
/** 顶部滚动视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/** 顶部分屏控件 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

/** 左边视图 */
@property (strong, nonatomic) XHBCatalogViewController *leftViewController;

/** 中点X坐标 */
@property (assign, nonatomic) float centerX;

/** 中点Y坐标 */
@property (assign, nonatomic) float centerY;

/** AFN 网络请求管理者 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;

/** 顶部新闻数组 */
@property (strong, nonatomic) NSArray *topNews;

/** 今日新闻 */
@property (strong, nonatomic) NSArray *dayNews;

/** 顶部新闻图片 */
@property (strong, nonatomic) UIImageView *imageView;

/** 顶部新闻按钮 */
@property (weak, nonatomic) IBOutlet UIButton *topNewsButton;

@end

@implementation XHBContentViewController

#pragma mark - viewController 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 控件初始化设置 */
    [self setupView];
    
    /* 加载pageControl中的新闻 */
//    [self loadTopDayNews];
    
    [self setupTopNews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 控件初始化设置
/** 控件初始化设置 */
- (void)setupView
{
    /* 设置初始中点坐标为屏幕中间 */
    self.centerX = screenWidth / 2.0;
    self.centerY = screenHeight / 2.0;
    
    /* 创建导航栏按钮 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImageName:@"Home_Icon" highImageName:@"Home_Icon_Highlight" target:self action:@selector(catalogClick)];
    
    /* 创建平移手势识别器 */
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveFinger:)];
    
    /* 将手势识别器添加到 view 上 */
//    [self.view addGestureRecognizer:panGesture];
}



#pragma mark - 给顶部新闻添加内容
/** 设置顶部滚动视图的内容 */
- (void)setupTopNews
{
    /* 设置ScrollView的委托对象 */
    self.scrollView.delegate = self;
    
    /* 设置ScrollView的内容视图的大小 */
    self.scrollView.contentSize = CGSizeMake(screenWidth * 5, 0);
    
    /* 设置内容视图的坐标原点 */
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
    /* 设置scrollView内容视图和边框的距离 */
    self.scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    /* 加载pageControl中的新闻 */
    [self loadTopDayNews];
    
}



#pragma mark - 加载网络数据
/** 加载pageControl中的新闻 */
- (void)loadTopDayNews
{
    /* 显示指示器 */
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];

    /* 发送无参数网络请求 */
    [self.manager GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        /* 请求成功，隐藏指示器 */
        [SVProgressHUD dismiss];
        
        /* 转换数据模型 */
        self.topNews = [XHBDayNews mj_objectArrayWithKeyValuesArray:responseObject[@"top_stories"]];
        
        for (int i = 0; i < self.pageControl.numberOfPages; i++) {
            
            XHBDayNews *topNews = self.topNews[i];
            
            /* 添加图片到ScrollView */
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, self.scrollView.frame.size.height)];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:topNews.image]];
            [self.scrollView addSubview:self.imageView];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        /* 提示加载失败信息 */
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}

/** 加载当日的新闻 */
- (void)loadDayNews
{
    
}



#pragma mark - UIScrollViewDelegate协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /* 获取内容视图坐标原点与屏幕滚动视图坐标原点的偏移量 */
    CGPoint offset = scrollView.contentOffset;
    self.pageControl.currentPage = offset.x / screenWidth;
}



#pragma mark - UIPageControl动作方法
- (IBAction)changePage:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        /* 将偏移量设置为当前页乘以屏幕宽度 */
        NSInteger currentPage = self.pageControl.currentPage;
        self.scrollView.contentOffset = CGPointMake(screenWidth * currentPage, 0);
    }];
}



#pragma mark - 侧滑菜单动作事件方法
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
//- (void)moveFinger:(UIPanGestureRecognizer *)recognizer
//{
//    /* 手势开始 */
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        
//    }
//    /* 手势变化中 */
//    else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        
//        /* 获取手指移动距离的值 */
//        CGPoint translation = [recognizer translationInView:self.view];
//        
//        /* 让主界面的中间点随着手指的移动而移动 */
//        float x = self.view.center.x + translation.x;
//        
//        //不能让主界面向左移动
//        if (x < self.centerX) {
//            x = self.centerX;
//        }
//        
//        self.navigationController.view.frame = CGRectMake(x, 0, screenWidth, screenHeight);
//        
//        /* 主界面向右移动的最大距离不能大于左边界面的宽度 */
//        if ((self.view.center.x - screenWidth) >= self.leftViewController.view.frame.size.width) {
//            x = self.view.center.x + self.leftViewController.view.frame.size.width;
//            self.view.center = CGPointMake(x, self.centerY);
//        }
//        
//        [recognizer setTranslation:CGPointZero inView:self.view];
//    }
//    /* 手势结束 */
//    else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        
//    }
//    
//}



#pragma mark - 存取方法
/** 返回 manager 对象 */
- (AFHTTPSessionManager *)manager
{
    /* 如果 _manager 为空 */
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}

/**
 * 想改变view的frame来实现滑动打开侧滑菜单，但是view只能向左滑
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
//}

@end
