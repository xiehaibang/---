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


#pragma mark - 常量
/* 新闻的访问地址 */
static NSString * const XHBNewsaddress = @"http://news-at.zhihu.com/api/4/news";



@interface XHBNewsContentViewController ()<WKUIDelegate, UIWebViewDelegate>

/** 网络请求管理者 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;

/** 新闻内容对象 */
@property (strong, nonatomic) XHBNewsContent *newsContent;

/** 新闻视图 */
@property (weak, nonatomic) IBOutlet UIWebView *newsWebView;

@end

@implementation XHBNewsContentViewController

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 隐藏导航栏 */
    self.navigationController.navigationBarHidden = YES;
    
    /* 获取网络的新闻内容 */
    [self loadNewsContent];
    
    NSLog(@"body 的内容\n%@", self.newsContent.body);
    
    
    
    
//    /* 创建一个 WKWebView */
//    WKWebView *newsWebView = [[WKWebView alloc] initWithFrame:self.view.frame];
//    
//    /* 将 WKWebView 添加到当前视图中 */
//    [self.view addSubview:newsWebView];
//    
//    /* 给 WKWebView 设置委托 */
//    newsWebView.UIDelegate = self;
//    
//    /* 加载 html 语言 */
//    [newsWebView loadHTMLString:self.newsContent.body baseURL:nil];
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
    
//    /* 创建请求对象 */
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:newsURL]];
//    
//    /* 发送异步网络请求 */
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        
//        if (connectionError) {
//            NSLog(@"请求错误\n%@", connectionError);
//        }
//        
//        /* 请求成功时隐藏指示器 */
//        [SVProgressHUD dismiss];
//        
//        self.newsContent = [XHBNewsContent mj_objectWithKeyValues:data];
//        
//        [self.newsWebView loadHTMLString:self.newsContent.body baseURL:nil];
//        
//    }];
    
    /* 发送网络请求 */
    [self.manager GET:newsURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /* 请求成功时隐藏指示器 */
        [SVProgressHUD dismiss];
        
        self.newsContent = [XHBNewsContent mj_objectWithKeyValues:responseObject];
        
        [self.newsWebView loadHTMLString:self.newsContent.body baseURL:nil];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
