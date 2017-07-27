//
//  XHBNewsContentViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/5/22.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBNewsContentViewController.h"
#import "XHBNewsContent.h"

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

/** 新闻视图 */
//@property (weak, nonatomic) IBOutlet UIWebView *newsWebView;

@property (strong, nonatomic) WKWebView *newsWKWebView;

/** UITabBar 控件 */
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;


@end


@implementation XHBNewsContentViewController

#pragma mark - 常量
/* 新闻的访问地址 */
static NSString * const XHBNewsaddress = @"http://news-at.zhihu.com/api/4/news";

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 隐藏导航栏 */
    self.navigationController.navigationBarHidden = YES;
    
    /* 获取网络的新闻内容 */
    [self loadNewsContent];
    
    
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    /* 创建一个 WKWebView */
    self.newsWKWebView = [[WKWebView alloc] initWithFrame:self.view.frame];
    
    /* 将 WKWebView 添加到当前视图中 */
    [self.view addSubview:self.newsWKWebView];
    
    /* 给 WKWebView 设置委托 */
    self.newsWKWebView.UIDelegate = self;
    self.newsWKWebView.navigationDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 网络请求
/** 
 * 加载新闻内容
 */
- (void)loadNewsContent
{
    /* 设置指示器类型并显示指示器 */
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    /* 在 block 中替换属性的名称，让属性名和网络数据中的 key 相对应 */
    [XHBNewsContent mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID" : @"id"
                 };
        
    }];
    
    /* 拼接新闻请求地址 */
    NSString *newsURL = [XHBNewsaddress stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", self.newsId]];
    
    /* 发送获取新闻内容的网络请求 */
    [self.manager GET:newsURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /* 请求成功时隐藏指示器 */
        [SVProgressHUD dismiss];
        
        self.newsContent = [XHBNewsContent mj_objectWithKeyValues:responseObject];
        
        [self setWebView];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        /* 获取失败，显示提示信息 */
        [SVProgressHUD showErrorWithStatus:@"网络有问题，获取新闻数据失败"];
        
    }];
    
}


#pragma mark - 设置 webView
/**
 * 设置 webView 的显示样式，并且加载新闻内容 
 */
- (void)setWebView
{
    
    /* 发送获取 css 的网络请求 */
    //创建请求访问路径
    NSURL *cssURL = [NSURL URLWithString:[self.newsContent.css firstObject]];
    
    //创建网络请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:cssURL];
    
    //发送网络请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        self.css = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //创建 html 头标签
        NSString *head = [NSString stringWithFormat:@"<head><style type=\"text/css\"> %@ </style></head>", self.css];
        
    
        
        //创建 html
        NSString *html = [head stringByAppendingString:self.newsContent.body];
        
        /* 加载 HTML 内容 */
//        [self.newsWebView loadHTMLString:html baseURL:nil];
        /* 加载 html 语言 */
        [self.newsWKWebView  loadHTMLString:html baseURL:nil];

        [self.newsWKWebView setContentScaleFactor:1.0];
        
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



#pragma mark - 懒加载
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

@end
