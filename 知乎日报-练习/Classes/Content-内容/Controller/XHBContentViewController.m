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
#import "XHBDayNewsTableViewCell.h"
#import "XHBNewsContentViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "UIImageView+WebCache.h"


#pragma mark - 宏定义
/* 将屏幕的宽与高定义为宏 */
#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height


#pragma mark - 常量
/* 将dayNewsCell的标识符设置为常量 */
static NSString * const XHBDayNewsCell = @"dayNewsCell";


@interface XHBContentViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

/** 顶部滚动视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/** 顶部分屏控件 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

/** 顶部新闻图片按钮 */
@property (weak, nonatomic) IBOutlet UIButton *topNewsButton;

/** 顶部新闻标题 */
@property (strong, nonatomic) IBOutlet UILabel *topNewsTitle;

/** 今日新闻列表 */
@property (weak, nonatomic) IBOutlet UITableView *dayNewsTableView;


/** 左边视图 */
//@property (strong, nonatomic) XHBCatalogViewController *leftViewController;

/** AFN 网络请求管理者 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;

/** 顶部新闻数组 */
@property (strong, nonatomic) NSArray *topNews;

/** 今日新闻数组 */
@property (strong, nonatomic) NSArray *dayNews;

/** 顶部新闻图片 */
@property (strong, nonatomic) UIImageView *imageView;

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
    
    /* 加载今日新闻 */
    [self loadDayNews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 视图初始化设置
/** 
 * 视图初始化设置
 */
- (void)setupView
{
    /* 为tableView队列中的cell注册类 */
    NSString *className = NSStringFromClass([XHBDayNewsTableViewCell class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [self.dayNewsTableView registerNib:nib forCellReuseIdentifier:XHBDayNewsCell];
    
    /* 设置dayNewsTableView的行高 */
    self.dayNewsTableView.rowHeight = 70;
    
    /* 创建导航栏按钮 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImageName:@"Home_Icon" highImageName:@"Home_Icon_Highlight" target:self action:@selector(catalogClick)];
    
}



#pragma mark - 给顶部新闻添加内容
/** 
 * 设置顶部滚动视图的内容 
 */
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
/** 
 * 加载pageControl中的新闻 
 */
- (void)loadTopDayNews
{
    /* 显示指示器 */
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];

    /* 在 block 中替换属性的名称，让属性名和网络数据中的 key 相对应 */
    [XHBDayNews mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID" : @"id"
                 };
        
    }];
    
    /* 发送无参数网络请求 */
    [self.manager GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        /* 请求成功，隐藏指示器 */
        [SVProgressHUD dismiss];
        
        /* 转换数据模型 */
        self.topNews = [XHBDayNews mj_objectArrayWithKeyValuesArray:responseObject[@"top_stories"]];
        
        for (int i = 0; i < self.pageControl.numberOfPages; i++) {
            
            /* 获取顶部新闻信息 */
            XHBDayNews *topNews = self.topNews[i];
            
            /* 获取图片 */
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, self.scrollView.frame.size.height)];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:topNews.image]];
            
            /* 添加新闻标题 */
            UILabel *topNewsLabel = [[UILabel alloc] init];
            topNewsLabel.text = topNews.title;
            topNewsLabel.textColor = [UIColor whiteColor];
            topNewsLabel.frame = CGRectMake(10, 150, screenWidth - 20, 80);
            
            //设置标签显示行数，0为显示多行
            topNewsLabel.numberOfLines = 0;
            
            //设置topNewsLabel根据字数自适应高度
            topNewsLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            //设置topNewsLabel的文字对齐方式
            topNewsLabel.textAlignment = NSTextAlignmentLeft;
            
            /* 将新闻标题添加到新闻图片上 */
            [self.imageView addSubview:topNewsLabel];
            
            /* 添加图片到ScrollView */
            [self.scrollView addSubview:self.imageView];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        /* 提示加载失败信息 */
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}

/** 
 * 加载当日的新闻
 */
- (void)loadDayNews
{
    /* 显示指示器 */
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    /* 发送网络请求 */
    [self.manager GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /* 请求成功，隐藏指示器 */
        [SVProgressHUD dismiss];
        
        self.dayNews = [XHBDayNews mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
        
        /* 刷新表格 */
        [self.dayNewsTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        /* 加载失败 */
        [SVProgressHUD showErrorWithStatus:@"数据加载失败！"];
        
    }];
    
}


#pragma mark - UITableViewDataSource 协议
/** 
 * 获取cell的数量
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dayNews.count;
}

/** 
 * 返回封装好的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    XHBDayNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XHBDayNewsCell forIndexPath:indexPath];
    
    cell.dayNewsItem = self.dayNews[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate 协议
/**
 * 选中 cell 时调用
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* 创建一个 tabBarController 对象 */
    XHBNewsContentViewController *newsContentVC = [[XHBNewsContentViewController alloc] init];
    
    /* 将新闻 id 赋值给 newsContentVC 对象 */
    XHBDayNews *dayNews = self.dayNews[indexPath.row];
    newsContentVC.newsId = dayNews.ID;
    
    /* 将新创建的 tabBarController 对象压入 viewControllers */
    [self.navigationController pushViewController:newsContentVC animated:YES];
}



#pragma mark - UIScrollViewDelegate协议
/**
 * 当 topNews 视图滚动的时候，获取内容视图的偏移量
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /* 获取内容视图坐标原点与屏幕滚动视图坐标原点的偏移量 */
    CGPoint offset = scrollView.contentOffset;
    self.pageControl.currentPage = offset.x / screenWidth;
}



#pragma mark - UIPageControl动作方法
/** 
 * 当前页改变
 */
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



#pragma mark - 懒加载
/** 
 * 返回 manager 对象 
 */
- (AFHTTPSessionManager *)manager
{
    /* 如果 _manager 为空 */
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}


@end
