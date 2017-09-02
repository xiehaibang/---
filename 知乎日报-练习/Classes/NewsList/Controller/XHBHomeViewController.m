//
//  XHBContentViewController.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/6.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBHomeViewController.h"
#import "XHBRootViewController.h"
#import "XHBCatalogViewController.h"
#import "XHBDayNews.h"
#import "XHBHomeNews.h"
#import "XHBDayNewsTableViewCell.h"
#import "XHBContainerViewController.h"
#import "XHBNavigationController.h"
#import "XHBRefreshControl.h"
#import "XHBSectionHeadView.h"
#import "XHBSessionManager.h"


#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "UIImageView+WebCache.h"


@interface XHBHomeViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

/** 今日新闻列表视图 */
@property (weak, nonatomic) IBOutlet UITableView *dayNewsTableView;

/** AFN 网络请求管理者 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;

/** 新闻的时间 */
@property (copy, nonatomic) NSString *newsDate;

/** 全部新闻的数组 */
@property (strong, nonatomic) NSMutableArray *homeNewsItems;

/** 今日新闻数组 */
@property (copy, nonatomic) NSArray *dayNews;

/** 今日新闻的新闻 id 数组 */
@property (copy, nonatomic) NSMutableArray *dayNewsId;

/** 顶部新闻数组 */
@property (copy, nonatomic) NSArray *topNews;

/** 盖住导航栏的视图 */
@property (strong, nonatomic) UIView *navBar;

/** 导航栏的标题 */
@property (strong, nonatomic) UILabel *navTitle;

/** 刷新控件 */
@property (strong, nonatomic) XHBRefreshControl *refreshView;

/** 历史新闻是否正在加载的状态 */
@property (assign, nonatomic) BOOL isLoading;

@end


@implementation XHBHomeViewController

#pragma mark - 常量
/* 将dayNewsCell的标识符设置为常量 */
static NSString * const XHBDayNewsCell = @"dayNewsCell";

#pragma mark - viewController 生命周期
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //显示导航栏
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 控件初始化设置 */
    [self setupView];
    
    //加载首页新闻
    [self loadHomeNews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    //移除 tableView 的监听者
    [self.dayNewsTableView removeObserver:self.topView forKeyPath:@"contentOffset"];
    
    //移除计时器
    [self.topView deleteTimer];
}


#pragma mark - 视图初始化设置
/** 
 * 视图初始化设置
 */
- (void)setupView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加轮播图
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(-45);
        //        make.bottom.equalTo(scrollView.mas_top).with.offset(220);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(265);
    }];
    
    //添加导航栏视图
    self.navBar = [[UIView alloc] init];
    self.navBar.backgroundColor = XHBColor(23, 144, 211);
    self.navBar.alpha = 0;
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(55);
    }];
    
    //添加导航栏的按钮
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
                          
    //设置按钮的背景图片
    [navButton setBackgroundImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
    [navButton setBackgroundImage:[UIImage imageNamed:@"Home_Icon_Highlight"] forState:UIControlStateHighlighted];
    
    [navButton addTarget:self action:@selector(catalogClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navButton];
    [navButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.top.equalTo(self.view.mas_top).with.offset(25);
        make.width.and.height.mas_equalTo(20);
    }];
    
    //添加导航栏的标题
    self.navTitle = [[UILabel alloc] init];
    self.navTitle.attributedText = [[NSAttributedString alloc] initWithString:@"今日新闻"
                                                              attributes:@{
                                                                            NSFontAttributeName:[UIFont boldSystemFontOfSize:18],
                                                                            NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                              }];
    [self.view addSubview:self.navTitle];
    [self.navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(25);
    }];
    
    //添加刷新控件
    [self.view addSubview:self.refreshView];
    [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navTitle.mas_centerY);
        make.width.and.height.mas_equalTo(20);
        make.right.equalTo(self.navTitle.mas_left).with.offset(-15);
    }];
    
    [self.refreshView.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.refreshView);
        make.width.and.height.equalTo(self.refreshView.mas_width);
    }];

    
    /* 为tableView队列中的cell注册类 */
    NSString *className = NSStringFromClass([XHBDayNewsTableViewCell class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [self.dayNewsTableView registerNib:nib forCellReuseIdentifier:XHBDayNewsCell];
    
    /* 设置dayNewsTableView的行高 */
    self.dayNewsTableView.rowHeight = 90;
    
    //给 tableView 添加头部视图
    self.dayNewsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 220)];
    
    self.dayNewsTableView.showsVerticalScrollIndicator = NO;
    
}



#pragma mark - 加载网络数据
/**
 * 加载今日新闻，包括顶部的
 */
- (void)loadHomeNews {
    
    /* 在 block 中替换属性的名称，让属性名和网络数据中的 key 相对应 */
    [XHBDayNews mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID" : @"id"
                 };
        
    }];
    
    __weak typeof(self) weakSelf = self;
    
    //打开网络活动指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //发送网络请求
    [self.manager GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        XHBHomeNews *homeNews = [XHBHomeNews mj_objectWithKeyValues:responseObject];
        
        weakSelf.newsDate = homeNews.date;
        
        [weakSelf.homeNewsItems addObject:homeNews];
        
        weakSelf.topNews = [XHBDayNews mj_objectArrayWithKeyValuesArray:homeNews.top_stories];
        
        weakSelf.dayNewsId = [weakSelf.homeNewsItems valueForKeyPath:@"stories.ID"];
        
        /* 刷新表格 */
        [weakSelf.dayNewsTableView reloadData];
        
        //结束刷新
        [weakSelf.refreshView endRefresh];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        //关闭网络活动指示器
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //请求失败
        [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
        
        //结束刷新
        [weakSelf.refreshView endRefresh];
    }];
}

/**
 * 加载以前的新闻
 */
- (void)loadHistoryNews {
    
    /* 在 block 中替换属性的名称，让属性名和网络数据中的 key 相对应 */
    [XHBDayNews mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID" : @"id"
                 };
        
    }];
    
    //判断历史新闻是否正在加载，正在加载就返回
    if (self.isLoading) {
        return;
    }
    
    //将历史新闻的加载状态设置为正在加载
    self.isLoading = YES;
    
    //访问地址
    NSString *newsURL = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/before/%@", self.newsDate];
    
    __weak typeof(self) weakSelf = self;
    
    //打开网络活动指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.manager GET:newsURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        XHBHomeNews *homeNews = [XHBHomeNews mj_objectWithKeyValues:responseObject];
        
        self.newsDate = homeNews.date;
        
        [weakSelf.homeNewsItems addObject:homeNews];
        
        weakSelf.dayNewsId = [weakSelf.homeNewsItems valueForKeyPath:@"stories.ID"];
        
        [weakSelf.dayNewsTableView insertSections:[NSIndexSet indexSetWithIndex:self.homeNewsItems.count - 1] withRowAnimation:UITableViewRowAnimationFade];
        
        /* 刷新表格 */
        [weakSelf.dayNewsTableView reloadData];
        
        //加载完毕，设置历史新闻的正在加载的状态为 NO
        weakSelf.isLoading = NO;
        
        //结束刷新
        [weakSelf.refreshView endRefresh];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //关闭网络活动指示器
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //请求失败
        [SVProgressHUD showErrorWithStatus:@"数据加载失败!"];
        
        //结束刷新
        [weakSelf.refreshView endRefresh];
    }];
}

/** 
 * 更新新闻数据
 */
- (void)updateNews {
    
    //重新加载首页的新闻
    [self loadHomeNews];
}



#pragma mark - UITableViewDataSource 协议
/**
 * 获取 section 的数量
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.homeNewsItems.count;
}

/** 
 * 获取cell的数量
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.homeNewsItems[section] stories] count];
}

/** 
 * 返回封装好的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    XHBDayNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XHBDayNewsCell forIndexPath:indexPath];
    
    cell.dayNewsItem = [self.homeNewsItems[indexPath.section] stories][indexPath.row];
    
    return cell;
}



#pragma mark - UITableViewDelegate 协议
/**
 * 选中 cell 时调用
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XHBDayNews *news = [self.homeNewsItems[indexPath.section] stories][indexPath.row];
    
    [self pushViewNewsContentControllerWithNewsId:news.ID];
    
}

/**
 * 返回 section 的头视图的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    //tableView displayHeaderView 的方法不会在高度为0的 section 执行，所以不能返回0
    return section?35:CGFLOAT_MIN;
}

/**
 * 返回指定 section 的头视图，调用此方法需要先实现 tableView:heightForHeaderInSection: 方法
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XHBSectionHeadView *headView = [XHBSectionHeadView getSectionHeadViewWithTableView:tableView];
    
    XHBHomeNews *homeNews = self.homeNewsItems[section];
    
    headView.date = homeNews.date;
    
    return section?headView:nil;
}

/**
 * 将要显示 section 的头视图时
 */
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    
    if (section == 0) {
        
        [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(55);
        }];
        
        self.navTitle.alpha = 1;
    }
}

/**
 * section 的头部视图结束显示时
 */
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    
    if (section == 0) {
        
        //section 的头部视图在滚动到顶部的时候会悬停在顶部，所以要修改 navBar 的高度并隐藏 navTitle
        [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
        
        self.navTitle.alpha = 0;
    }
}


#pragma mark - UIScrollViewDelegate协议
/**
 * 正在滚动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //上拉加载以前的数据
    if (offsetY > scrollView.contentSize.height - 1.5 * screenHeight) {
        
        [self loadHistoryNews];
    }
    
    if (offsetY <= 0 && offsetY >= -90) {
        self.navBar.alpha = 0;
    }
    else if (offsetY <= 500) {
        self.navBar.alpha = offsetY/200;
    }
}

/**
 * 开始拖拽 
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    //停止轮播图的计时器
    [self.topView stopTimer];
}

/**
 * 停止拖拽
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    //启动计时器
    [self.topView startTimer];

}



#pragma mark - XHBNewsContentControllerDelegate
/**
 * 通过本条新闻的 id 获取下一条新闻的 id
 */
- (NSInteger)getNextNewsWithNewsId:(NSInteger)newsId {
    
    //获取当前新闻 id 在新闻 id 数组中的位置
    NSInteger idIndex = [self.dayNewsId indexOfObject:[NSNumber numberWithInteger:newsId]];
    
    //如果当前 id 等于今日新闻的倒数第二条，就加载历史新闻
    if (idIndex == self.dayNewsId.count - 2) {
        [self loadHistoryNews];
    }
    
    return [[self.dayNewsId objectAtIndex:++idIndex] integerValue];
}

/**
 * 通过本条新闻的 id 获取上一条新闻的 id
 */
- (NSInteger)getPreviousNewsWithNewsId:(NSInteger)newsId {
    
    //获取当前新闻 id 在新闻 id 数组中的位置
    NSInteger idIndex = [self.dayNewsId indexOfObject:[NSNumber numberWithInteger:newsId]];
    
    if (idIndex == 0) {
        return [[self.dayNewsId objectAtIndex:0] integerValue];
    }
    else {
        return [[self.dayNewsId objectAtIndex:--idIndex] integerValue];
    }
    
}

/**
 * 判断本条新闻是不是第一条新闻
 */
- (BOOL)isFirstNewsWithNewsId:(NSInteger)newsId {
    
    if ([[NSNumber numberWithInteger:newsId] isEqual:self.dayNewsId.firstObject]) {
        return YES;
    }
    
    return NO;
}

/**
 * 判断本条新闻是不是最后一条新闻
 */
- (BOOL)isLastNewsWithNewsId:(NSInteger)newsId {
    
    if ([[NSNumber numberWithInteger:newsId] isEqual:self.dayNewsId.lastObject]) {
        return YES;
    }
    
    return NO;
}


#pragma mark - 载入选中新闻
/**
 * 通过新闻 id 载入新闻
 */
- (void)pushViewNewsContentControllerWithNewsId:(NSInteger)newsId {
    
    //创建一个新闻内容容器对象
    XHBContainerViewController *containerVC = [[XHBContainerViewController alloc] init];
    
    //将新闻 id 和本类对象赋值给新闻容器对象
    containerVC.newsId = newsId;
    containerVC.homeVC = self;
    
    /* 将新创建的新闻内容对象压入 navigationController */
    [self.navigationController pushViewController:containerVC animated:YES];
}


#pragma mark - 按钮动作事件方法
/**
 * 导航栏按钮动作事件 
 */
- (void)catalogClick {
    
    XHBRootViewController *rootVC = [XHBRootViewController sharedInstance];
    
    [rootVC navigationButton];
    
}



#pragma mark - setter
- (void)setDayNewsId:(NSMutableArray *)dayNewsId {
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < dayNewsId.count; i++) {
        
        NSArray *array = dayNewsId[i];
        
        [mutableArray addObjectsFromArray:array];
    }
    
    _dayNewsId = mutableArray;
    
}

- (void)setTopNews:(NSArray *)topNews {
    
    _topNews = topNews;
    
    //设置顶部新闻的新闻数组
    self.topView.topNews = self.topNews;
    
    //生成本对象的弱引用
    __weak typeof(self) weakSelf = self;
    
    //设置顶部新闻的点击事件
    self.topView.tapActionBlock = ^(NSInteger newsId) {
        
        [weakSelf pushViewNewsContentControllerWithNewsId:newsId];
    };
    
}


#pragma mark - getter
/** 
 * 返回 manager 对象 
 */
- (AFHTTPSessionManager *)manager {
    /* 如果 _manager 为空 */
    if (!_manager) {
        _manager = [XHBSessionManager sharedHttpSessionManager];
    }
    
    return _manager;
}


- (NSMutableArray *)homeNewsItems {
    
    if (!_homeNewsItems) {
        _homeNewsItems = [[NSMutableArray alloc] init];
    }
    
    return _homeNewsItems;
}

- (XHBHomeTopView *)topView {
    
    if (!_topView) {
        _topView = [XHBHomeTopView attachToView:self.view observeScrollView:self.dayNewsTableView];
        
    }
    
    return _topView;
}

- (XHBRefreshControl *)refreshView {
    
    if (!_refreshView) {
        _refreshView = [XHBRefreshControl getViewObserveToScrollView:self.dayNewsTableView target:self action:@selector(updateNews)];
    }
    
    return _refreshView;
}

@end
