//
//  XHBThemeViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/5/26.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBThemeViewController.h"
#import "XHBDayNewsTableViewCell.h"
#import "XHBThemeDaily.h"
#import "XHBThemeStories.h"
#import "XHBNewsContentViewController.h"
#import "XHBRootViewController.h"
#import "XHBContainerViewController.h"
#import "XHBSessionManager.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface XHBThemeViewController ()<UITableViewDelegate, UITableViewDataSource, XHBNewsContentControllerDelegate>

/** tableView 对象 */
@property (weak, nonatomic) IBOutlet UITableView *themeTableView;

/** 网络请求管理者 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;

/** 主题日报中的文章列表 */
@property (strong, nonatomic) NSArray *stories;

/** 新闻的 id 数组 */
@property (strong, nonatomic) NSArray *newsId;

/** 主题日报的编辑『用户推荐日报』中此项的指是一个空数组，在 App 中的主编栏显示为『许多人』，点击后访问该主题日报的介绍页面，请留意） */
@property (strong, nonatomic) NSArray *editors;

@end

@implementation XHBThemeViewController

#pragma mark - 常量
/* 将dayNewsCell的标识符设置为常量 */
static NSString * const XHBDayNewsCell = @"dayNewsCell";

/* 主题日报内容访问地址 */
static NSString * const dailyAddress = @"http://news-at.zhihu.com/api/4/theme";


#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 加载视图内容 */
    [self setupView];
    
    /* 加载文章列表 */
    [self loadArticleList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 控制器初始化
/**
 * 加载视图内容
 */
- (void)setupView {
    
    /* 为 themeTableView 重用队列中的 cell 注册类 */
    NSString *className = NSStringFromClass([XHBDayNewsTableViewCell class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [self.themeTableView registerNib:nib forCellReuseIdentifier:XHBDayNewsCell];
    
    //设置 tabelView 的行高
    self.themeTableView.rowHeight = 90;
    
    /* 创建导航栏按钮 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImageName:@"News_Arrow" highImageName:@"News_Arrow_Highlight" target:self action:@selector(catalogClick)];
    
}


#pragma mark - 加载数据
/**
 * 加载文章列表 
 */
- (void)loadArticleList {
    
    /* 设置指示器的类型并显示 */
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    /* 在 block 块中替换属性的名称，让属性名和网络数据中的 key 相对象 */
    [XHBThemeStories mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
    
    /* 将文章 id 拼接到地址上 */
//    NSString *articleURL = [dailyAddress stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", (long)self.ID]];
    
    NSString *articleURL = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%lu", (long)self.ID];
    
    //打开网络活动指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    /* 获取数据 */
    [self.manager GET:articleURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        /* 请求成功的时候隐藏指示器 */
        [SVProgressHUD dismiss];
        
        self.stories = [XHBThemeStories mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
        
        self.newsId = [self.stories valueForKeyPath:@"ID"];
        
        
        /* 刷新表格 */
        [self.themeTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        /* 加载失败 */
        [SVProgressHUD showErrorWithStatus:@"数据加载失败！"];
    }];
    
}


#pragma mark - 侧滑菜单动作事件方法
/**
 * 导航栏按钮动作事件
 */
- (void)catalogClick
{
    XHBRootViewController *rootVC = [XHBRootViewController sharedInstance];
    
    [rootVC navigationButton];
    
}


#pragma mark - UITableViewDelegate 协议
/**
 * 选中 cell 时调用
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //创建一个新闻内容容器对象
    XHBContainerViewController *containerVC = [[XHBContainerViewController alloc] init];
    
    //将新闻 id 和本类对象赋值给新闻容器对象
    containerVC.newsId = [[self.newsId objectAtIndex:indexPath.row] integerValue];
    containerVC.themeVC = self;
    
    /* 将新创建的新闻内容对象压入 navigationController */
    [self.navigationController pushViewController:containerVC animated:YES];
    
}

#pragma mark - UITableViewDataSource 协议
/**
 * 返回 section 的数量 
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 * 返回指定 section 的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.stories.count;
}

/**
 * 返回指定行的 cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    XHBDayNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XHBDayNewsCell forIndexPath:indexPath];
    
    cell.themeDailyItem = self.stories[indexPath.row];
    
    return cell;
}



#pragma mark - XHBNewsContentControllerDelegate
/**
 * 通过本条新闻的 id 获取下一条新闻的 id
 */
- (NSInteger)getNextNewsWithNewsId:(NSInteger)newsId {
    
    //获取当前新闻 id 在新闻 id 数组中的位置
    NSInteger idIndex = [self.newsId indexOfObject:[NSNumber numberWithInteger:newsId]];
    
    return [[self.newsId objectAtIndex:++idIndex] integerValue];
}

/**
 * 通过本条新闻的 id 获取上一条新闻的 id
 */
- (NSInteger)getPreviousNewsWithNewsId:(NSInteger)newsId {
    
    //获取当前新闻 id 在新闻 id 数组中的位置
    NSInteger idIndex = [self.newsId indexOfObject:[NSNumber numberWithInteger:newsId]];
    
    if (idIndex == 0) {
        return [[self.newsId objectAtIndex:0] integerValue];
    }
    else {
        return [[self.newsId objectAtIndex:--idIndex] integerValue];
    }
    
}

/**
 * 判断本条新闻是不是第一条新闻
 */
- (BOOL)isFirstNewsWithNewsId:(NSInteger)newsId {
    
    if ([[NSNumber numberWithInteger:newsId] isEqual:self.newsId.firstObject]) {
        return YES;
    }
    
    return NO;
}

/**
 * 判断本条新闻是不是最后一条新闻
 */
- (BOOL)isLastNewsWithNewsId:(NSInteger)newsId {
    
    if ([[NSNumber numberWithInteger:newsId] isEqual:self.newsId.lastObject]) {
        return YES;
    }
    
    return NO;
}



#pragma mark - 懒加载
/**
 * 返回一个 manager 对象
 */
- (AFHTTPSessionManager *)manager {
    
    if (!_manager) {
        _manager = [XHBSessionManager sharedHttpSessionManager];
    }
    
    return _manager;
}

@end
