//
//  XHBNewsContentViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/5/22.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBNewsContentViewController.h"
#import "XHBNewsContent.h"
#import "XHBNewsHeadView.h"
#import "XHBNewsFootView.h"
#import "XHBNewsTopImageView.h"
#import "XHBHomeViewController.h"

#import <WebKit/WebKit.h>

#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJExtension/MJExtension.h>



@interface XHBNewsContentViewController ()<WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate, UITabBarDelegate>

/** 网络请求管理者 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;

/** 新闻内容对象 */
@property (strong, nonatomic) XHBNewsContent *newsContent;

/** 新闻内容样式表 */
@property (strong, nonatomic) NSString *css;

/** 新闻的 html */
@property (strong, nonatomic) NSString *html;

/** 新闻视图 */
@property (strong, nonatomic) WKWebView *newsWKWebView;

/** 新闻头部的图片视图 */
@property (strong, nonatomic) XHBNewsTopImageView *topImage;

/** UITabBar 控件 */
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

/** 第一条新闻的提示 */
@property (strong, nonatomic) UILabel *firstLabel;

/** 最后一条新闻的提示 */
@property (strong, nonatomic) UILabel *lastLabel;

/** 载入上一条新闻的头部视图 */
@property (strong, nonatomic) XHBNewsHeadView *headView;

/** 载入下一条新闻的脚部视图 */
@property (strong, nonatomic) XHBNewsFootView *footView;

@end


@implementation XHBNewsContentViewController

#pragma mark - 常量
/* 新闻的访问地址 */
static NSString * const XHBNewsaddress = @"http://news-at.zhihu.com/api/4/news";

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    //创建并设置显示新闻内容的视图
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 当视图销毁时
 */
- (void)dealloc {
    
    [self.newsWKWebView.scrollView removeObserver:self.headView forKeyPath:@"contentOffset"];
    [self.newsWKWebView.scrollView removeObserver:self.footView forKeyPath:@"contentOffset"];
    [self.newsWKWebView.scrollView removeObserver:self.topImage forKeyPath:@"contentOffset"];
}

#pragma mark - 设置视图
- (void)setupView {

    //创建 WKWebView 的 Configuration 对象
    WKWebViewConfiguration *wkConfiguration = [[WKWebViewConfiguration alloc] init];
    
    //自适应屏幕的 js
    NSString *jsString = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width');document.getElementsByTagName('head')[0].appendChild(meta);";
    
    //将 js 注入
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    //创建用于和 js 交互的对象
    WKUserContentController *wkUserContent = [[WKUserContentController alloc] init];
    
    [wkUserContent addUserScript:wkUserScript];
    
    wkConfiguration.userContentController = wkUserContent;
    
    /* 创建一个 WKWebView */
    self.newsWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, screenHeight - self.tabBar.height - 20) configuration:wkConfiguration];

    self.newsWKWebView.scrollView.contentOffset = CGPointMake(0, 0);
    
    /* 给 WKWebView 设置委托 */
    self.newsWKWebView.UIDelegate = self;
    self.newsWKWebView.navigationDelegate = self;
}

/**
 * 设置 webView 的显示样式，并且加载新闻内容
 */
- (void)setupWebView
{
    /* 加载 html 语言 */
    [self.newsWKWebView  loadHTMLString:self.html baseURL:nil];
    
    [self.newsWKWebView setContentScaleFactor:1.0];
    
    /* 当 newsWKWebView 的数据加载完的时候再将 WKWebView 添加到当前视图中 */
    [self.view addSubview:self.newsWKWebView];
    
}

/**
 * 添加并设置新闻的头部视图
 */
- (void)setupHeadView {
    
        
    //如果当前新闻有图
    if (self.newsContent.image) {
        
        self.topImage.newsContent = self.newsContent;
    }
    
    if ([self.newsListDelegate respondsToSelector:@selector(isFirstNewsWithNewsId:)]) {
        
        //如果是第一条新闻并且有图片
        if ([self.newsListDelegate isFirstNewsWithNewsId:self.newsId] && self.newsContent.image) {
            
            [self.topImage addSubview:self.firstLabel];
            
            //给 firstLabel 添加约束
            [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topImage.mas_top).with.offset(20);
                make.centerX.equalTo(self.topImage.mas_centerX);
            }];
            
        }
        //如果是第一条新闻并且没有图片
        else if ([self.newsListDelegate isFirstNewsWithNewsId:self.newsId] && !self.newsContent.image) {
            
            [self.newsWKWebView.scrollView addSubview:self.firstLabel];
            
            //给 firstLabel 添加约束
            [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.newsWKWebView.scrollView.mas_top).with.offset(-50);
                make.centerX.equalTo(self.newsWKWebView.scrollView.mas_centerX);
            }];
        }
        //如果不是第一条新闻并且有图片
        else if (![self.newsListDelegate isFirstNewsWithNewsId:self.newsId] && self.newsContent.image) {
            
            [self.topImage addSubview:self.headView];
            
            //给 headView 添加约束
            [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topImage.mas_top).with.offset(20);
                make.width.mas_equalTo(screenWidth);
                make.height.mas_equalTo(30);
                make.centerX.equalTo(self.topImage.mas_centerX);
            }];
        }
        //如果不是第一条新闻并且没有图片
        else {
            
            [self.newsWKWebView.scrollView addSubview:self.headView];
            
            //给 headView 添加约束
            [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.newsWKWebView.scrollView.mas_top).with.offset(-50);
                make.centerX.equalTo(self.newsWKWebView.scrollView.mas_centerX);
                make.width.mas_equalTo(screenWidth);
                make.height.mas_equalTo(30);
            }];
        }
        
    }
    
    
}

/** 
 * 添加并设置载入下一条新闻的底部视图
 */
- (void)setupFootView:(CGFloat)webHeight {
    
    //判断一下指向首页的代理对象是否实现了相应的方法
    if ([self.newsListDelegate respondsToSelector:@selector(isLastNewsWithNewsId:)]) {
        
        //判断当前新闻是不是最后一条新闻
        if ([self.newsListDelegate isLastNewsWithNewsId:self.newsId]) {

            
            [self.newsWKWebView.scrollView addSubview:self.lastLabel];
            
            //给 lastLabel 添加约束
            [self.lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.newsWKWebView.scrollView.mas_top).with.offset(webHeight + 20);
                make.centerX.equalTo(self.newsWKWebView.scrollView.mas_centerX);
            }];
            
        }else {
            
            [self.newsWKWebView.scrollView addSubview:self.footView];
            
            //给 footView 添加约束
            [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.newsWKWebView.scrollView.mas_top).with.offset(webHeight + 15);
                make.centerX.equalTo(self.newsWKWebView.scrollView.mas_centerX);
                make.width.mas_equalTo(screenWidth);
                make.height.mas_equalTo(30);
            }];
        }
    }
}



#pragma mark - 加载新闻
/**
 * 加载新闻内容
 */
- (void)loadNewsContent
{
    /* 在 block 中替换属性的名称，让属性名和网络数据中的 key 相对应 */
    [XHBNewsContent mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID" : @"id"
                 };
        
    }];
    
//    __weak typeof(self) weakSelf = self;
    
    /* 拼接新闻请求地址 */
    NSString *newsURL = [XHBNewsaddress stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", (long)self.newsId]];
    
    //打开网络活动指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    /* 发送获取新闻内容的网络请求 */
    [self.manager GET:newsURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //关闭网络活动指示器
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        self.newsContent = [XHBNewsContent mj_objectWithKeyValues:responseObject];
        
        //拼接新闻的整个 html
        self.html = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>", self.newsContent.css[0], self.newsContent.body];
        
        //设置 webView 的显示样式，并且加载新闻内容
        [self setupWebView];
        
        self.newsWKWebView.scrollView.contentOffset = CGPointMake(0, 0);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //关闭活动指示器
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        /* 获取失败，显示提示信息 */
        [SVProgressHUD showErrorWithStatus:@"网络有问题，获取新闻数据失败"];
        
    }];
    
}

/** 
 * 加载上一条新闻 
 */
- (void)loadPreviousNews {
    
    //判断指向新闻内容容器的代理对象是否实现了协议方法
    if ([self.containerDelegate respondsToSelector:@selector(scrollToPreviousViewWithNewsId:)]) {
        
        //判断指向首页的代理对象是否实现了协议方法
        if ([self.newsListDelegate respondsToSelector:@selector(getPreviousNewsWithNewsId:)]) {
            
            //获取上一条新闻 id
            NSInteger previousNewsId = [self.newsListDelegate getPreviousNewsWithNewsId:self.newsId];
            
            //加载上一条新闻
            [self.containerDelegate scrollToPreviousViewWithNewsId:previousNewsId];
        }
        
    }
    
}

/** 
 * 加载下一条新闻 
 */
- (void)loadNextNews {
    
    //判断代理对象是否实现了协议方法
    if ([self.containerDelegate respondsToSelector:@selector(scrollToNextViewWithNewsId:)]) {
        
        //判断指向首页的代理对象是否实现了协议方法
        if ([self.newsListDelegate respondsToSelector:@selector(getNextNewsWithNewsId:)]) {
            
            //获取下一条新闻 id
            NSInteger nextNewsId = [self.newsListDelegate getNextNewsWithNewsId:self.newsId];
            
            //加载下一条新闻
            [self.containerDelegate scrollToNextViewWithNewsId:nextNewsId];
        }
        
    }
    
}


#pragma mark - WKUIDelegate
/**
 * 当视图加载完毕的时候
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation  {
    
    [self setupHeadView];
    
    //获取新闻内容页的长度，然后在下面添加加载下一条新闻的底部视图
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        CGFloat webHeight = [result floatValue];
        
        //添加底部视图
        [self setupFootView:webHeight];
    }];
}



#pragma mark - UITabBarDelegate 协议
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    /* 如果是返回按钮，则返回新闻列表 */
    if (item.tag == 0) {
        [self returnNewsList];
    }
}


#pragma mark - tabBar 按钮动作事件
/**
 * 返回
 */
- (void)returnNewsList {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark - getter
/**
 * 返回一个 AFHTTPSessionManager 的对象
 */
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}

/**
 * 新闻头部的图片视图
 */
- (XHBNewsTopImageView *)topImage {
    
    if (!_topImage) {
        
        _topImage = [XHBNewsTopImageView attachToView:self.view observeScorllView:self.newsWKWebView.scrollView];
    }
    
    return _topImage;
}

/**
 * 设置并返回第一条新闻提示的对象
 */
- (UILabel *)firstLabel {
    
    if (!_firstLabel) {
        
        _firstLabel = [[UILabel alloc] init];
        
        _firstLabel.text = @"已经是第一篇了";
        
        [_firstLabel sizeToFit];
        
        _firstLabel.textColor = [UIColor grayColor];
        
        _firstLabel.font = [UIFont systemFontOfSize:14];
        
    }
    
    return _firstLabel;
}

/**
 * 设置并返回最后一条新闻提示的对象
 */
- (UILabel *)lastLabel {
    
    if (!_lastLabel) {
        _lastLabel = [[UILabel alloc] init];
        
        _lastLabel.text = @"这已经是最后一篇了";
        
        [_lastLabel sizeToFit];
        
        _lastLabel.textColor = [UIColor grayColor];
        
        _lastLabel.font = [UIFont systemFontOfSize:14];
        
    }
    
    return _lastLabel;
}

/** 
 * 返回载入下一条新闻的脚部视图
 */
- (XHBNewsFootView *)footView {
    
    if (!_footView) {
        
        _footView = [XHBNewsFootView attachObserveToScrollView:self.newsWKWebView.scrollView target:self action:@selector(loadNextNews)];
    }
    
    return _footView;
}

/** 
 * 返回载入上一条新闻的头部视图 
 */
- (XHBNewsHeadView *)headView {
    
    if (!_headView) {
        
        _headView = [XHBNewsHeadView attachObserveToScrollView:self.newsWKWebView.scrollView target:self action:@selector(loadPreviousNews)];
    }
    
    return _headView;
}

- (void)setNewsId:(NSInteger)newsId {
    
    _newsId = newsId;
    
    /* 获取网络的新闻内容 */
    [self loadNewsContent];
    
    
    
}



@end
