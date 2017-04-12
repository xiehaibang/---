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

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface XHBCatalogViewController () <UITableViewDelegate, UITableViewDataSource>
/* 目录表格 */
@property (weak, nonatomic) IBOutlet UITableView *catalogTableView;

/* 菜单栏 */
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

/* AFN 请求管理者 */
@property (strong, nonatomic) AFHTTPSessionManager *manage;

/* 日报列表的数组 */
@property (strong, nonatomic) NSArray *categories;

@end

/* 将catalogCell的标识符设为常量 */
static NSString * const XHBCatalogId = @"catalog";


@implementation XHBCatalogViewController

#pragma mark - ViewController生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 视图初始化 */
    [self setupView];
    
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
    
    //    /* 将方形图片变成圆形图片 */
    //    CALayer *mask = [CALayer layer];
    //    mask.contents = (id)[[UIImage imageNamed:@"Field_Avatar_Mask"] CGImage];
    //
    //    UIBarButtonItem *barButtonItem = self.navigationItem.leftBarButtonItem;
    //    barButtonItem.customView.layer.mask = mask;
    //    barButtonItem.customView.layer.masksToBounds = YES;
    ////    barButtonItem.customView.layer.cornerRadius = barButtonItem.customView.frame.size.width / 2.0;
    
    /* 设置tabBar的背景颜色 */
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 49)];
    
    backgroundView.backgroundColor = XHBColor(35, 42, 48);
    
    [self.tabBar insertSubview:backgroundView atIndex:0];
    
}


#pragma mark - 加载网络数据
/** 
 * 加载类别目录
 */
- (void)loadCatalog
{
    self.manage = [AFHTTPSessionManager manager];
    
    /* 显示指示器 */
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    /* 发送网络请求 */
    [self.manage GET:@"http://news-at.zhihu.com/api/4/themes" parameters:nil progress:^(NSProgress * downloadProgress) {
        
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        
        /* 加载成功则隐藏指示器 */
        [SVProgressHUD dismiss];
        
        NSLog(@"%@", responseObject[@"others"]);
        
        /* 将json数据转换为模型 */
        self.categories = [XHBNewCatalog mj_objectArrayWithKeyValuesArray:responseObject[@"others"]];
        
        /* 拿到数据以后刷新表格 */
        [self.catalogTableView reloadData];
        
        NSLog(@"%@", self.categories);
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        /* 加载失败则提示用户 */
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}


#pragma mark - UITableViewDataSource 协议
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu", (unsigned long)self.categories.count);
    
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHBCatalogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XHBCatalogId forIndexPath:indexPath];
    
    cell.categoryItem = self.categories[indexPath.row];

    return cell;
}


#pragma mark - UITableViewDelegate 协议
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
