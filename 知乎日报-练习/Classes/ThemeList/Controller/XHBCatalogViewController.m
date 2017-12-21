//
//  XHBCatalogViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/6.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBCatalogViewController.h"
#import "XHBCatalogTableViewCell.h"
#import "XHBNewCatalog.h"
#import "XHBThemeViewController.h"
#import "XHBNavigationController.h"
#import "XHBRootViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

#import "AppDelegate.h"

@interface XHBCatalogViewController () <UITableViewDelegate, UITableViewDataSource>
/* 目录表格 */
@property (nonatomic, weak) IBOutlet UITableView *catalogTableView;

/* 菜单栏 */
@property (nonatomic, weak) IBOutlet UIView *topMenuView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topMenuTopConstraint; //菜单栏的顶部约束

/* AFN 请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/* 日报列表的数组 */
@property (nonatomic, strong) NSArray *categories;

@end

/* 将catalogCell的标识符设为常量 */
static NSString * const XHBCatalogId = @"catalog";


@implementation XHBCatalogViewController

#pragma mark - ViewController生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 视图初始化 */
    [self setupView];
    
    /* 加载左边类别数据 */
    [self loadCatalog];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 控件初始化
/** 
 * 视图初始化
 */
- (void)setupView
{
    /* 为队列里的cell注册类 */
    NSString *className = NSStringFromClass([XHBCatalogTableViewCell class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [self.catalogTableView registerNib:nib forCellReuseIdentifier:XHBCatalogId];
    
    /* 设置导航栏按钮 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImageName:@"Menu_Avatar" title:@"请登录" target:self action:nil];
    
    /* 设置tabBar的背景颜色 */
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 64)];
    
    //适配iPhoneX
    if (iPhoneX) {
        self.topMenuTopConstraint.constant = kTopHeight;
    }
    
    backgroundView.backgroundColor = XHBColor(35, 42, 48);
    
//    [self.topMenuView insertSubview:backgroundView atIndex:0];
    
}


#pragma mark - 加载网络数据
/** 
 * 加载类别目录
 */
- (void)loadCatalog
{
    /* 替换属性的名称，让属性名和网络数据中的 key 相对应 */
    [XHBNewCatalog mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"dailyDescription" : @"description"
                 };
    }];
    
    /* 显示指示器 */
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    /* 发送网络请求 */
    [self.manager GET:@"http://news-at.zhihu.com/api/4/themes" parameters:nil progress:^(NSProgress * downloadProgress) {
        
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        
        /* 加载成功则隐藏指示器 */
        [SVProgressHUD dismiss];
        
        /* 将json数据转换为模型 */
        self.categories = [XHBNewCatalog mj_objectArrayWithKeyValuesArray:responseObject[@"others"]];
        
        /* 拿到数据以后刷新表格 */
        [self.catalogTableView reloadData];
        
        /* 默认选中首行 */
        [self.catalogTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        /* 加载失败则提示用户 */
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}


#pragma mark - UITableViewDataSource 协议
/**
 * 获取 section 的数量 
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/**
 * 获取当前段 cell 的数量
 */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else {
        return self.categories.count;
    }
}

/**
 * 返回一个定义好的 cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHBCatalogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XHBCatalogId forIndexPath:indexPath];
    
    /* 单独设置首页的 cell */
    if (indexPath.section == 0) {
        [cell setupHomeCell];
    }
    else {
        cell.categoryItem = self.categories[indexPath.row];
    }

    return cell;
}


#pragma mark - UITableViewDelegate 协议
/**
 * 返回指定 section 的脚视图高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return 0;
    }
}

/**
 * 返回指定 section 的脚视图，调用此方法需要先实现 tableView:heightForHeaderInSection: 方法
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.catalogTableView.frame.size.width, 1)];
        
        view.backgroundColor = [UIColor colorWithRed:27/255.0 green:35/255.0 blue:40/255.0 alpha:1.0];
        
        return view;
    }
    else {
        return nil;
    }
}

/**
 * 选中 cell 时调用
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /* 获取 rootVC 单例 */
    XHBRootViewController *rootVC = [XHBRootViewController sharedInstance];
    
    if (indexPath.section == 0) {
        [rootVC showHomeCategory];
    }
    else {
        XHBNewCatalog *newsCatalog = self.categories[indexPath.row];
        
        /* 将主题日报的新闻 id 赋给 rootVC 对象 */
        rootVC.ID = newsCatalog.ID;
        
        /* 切换到其他主题日报 */
        [rootVC showOtherCategory];
    }
    
}


#pragma mark - 懒加载
/** 
 * 返回一个manager对象
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
