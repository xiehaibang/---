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
#import "XHBDayNewsTableViewCell.h"
#import "XHBNewsContentViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "UIImageView+WebCache.h"


@interface XHBHomeViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

/** 顶部新闻图片按钮 */
@property (weak, nonatomic) IBOutlet UIButton *topNewsButton;

/** 今日新闻列表视图 */
@property (weak, nonatomic) IBOutlet UITableView *dayNewsTableView;

/** 顶部新闻的轮播图对象 */
@property (strong, nonatomic) UIView *carouselView;

/** 顶部滚动视图 */
@property (strong, nonatomic) UIScrollView *scrollView;

/** 顶部分屏控件 */
@property (strong, nonatomic) UIPageControl *pageControl;

/** 计时器对象 */
@property (strong, nonatomic) NSTimer *timer;

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


@implementation XHBHomeViewController

#pragma mark - 常量
/* 将dayNewsCell的标识符设置为常量 */
static NSString * const XHBDayNewsCell = @"dayNewsCell";

#pragma mark - viewController 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 控件初始化设置 */
    [self setupView];
    
    /* 加载pageControl中的新闻 */
    [self loadTopDayNews];
    
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
- (void)setupView {
    /* 给手机屏幕的宽高赋值 */
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    /* 为tableView队列中的cell注册类 */
    NSString *className = NSStringFromClass([XHBDayNewsTableViewCell class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [self.dayNewsTableView registerNib:nib forCellReuseIdentifier:XHBDayNewsCell];
    
    /* 设置dayNewsTableView的行高 */
    self.dayNewsTableView.rowHeight = 70;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /* 创建导航栏按钮 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImageName:@"Home_Icon" highImageName:@"Home_Icon_Highlight" target:self action:@selector(catalogClick)];
    
    /* 创建 NSTimer 计时器来让轮播图每隔5秒自动滚动 */
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(autoScrollImage) userInfo:nil repeats:YES];
    
    /* 获取当前的消息循环对象 */
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    /* 将计时器对象的优先级设置为和控件的优先级一样 */
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}



#pragma mark - 设置顶部新闻
/** 
 * 创建并设置轮播图
 */
- (void)setupTopNews {
    /* 创建一个 UIView 对象 */
    self.carouselView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
    
    /* 创建并设置滚动视图 */
    [self setupScrollView];
    
    /* 创建并设置分页控件 */
    [self setupPageControl];
    
    /* 将滚动视图添加到轮播图对象中 */
    [self.carouselView addSubview:self.scrollView];
    
    /* 将分页控件添加到轮播图对象中 */
    [self.carouselView addSubview:self.pageControl];
    
}


/**
 * 创建并设置滚动视图 
 */
- (void)setupScrollView {
    /* 创建一个 scrollView 对象 */
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
    
    /* 设置ScrollView的委托对象 */
    self.scrollView.delegate = self;
    
    /* 启用分页 */
    self.scrollView.pagingEnabled = YES;
    
    /* 设置ScrollView的内容视图的大小 */
    self.scrollView.contentSize = CGSizeMake(self.screenWidth * self.topNews.count, self.scrollView.frame.size.height);
    
    /* 设置内容视图的坐标原点 */
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
    /* 隐藏水平滚动控件 */
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    /* 隐藏垂直滚动控件 */
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    /* 将轮播图的图片添加到 scrollView 对象中 */
    for (int i = 0; i < self.topNews.count; i++) {
        
        /* 获取顶部新闻信息 */
        XHBDayNews *topNews = self.topNews[i];
        
        /* 获取图片 */
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.screenWidth * i, 0, self.screenWidth, self.scrollView.frame.size.height)];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:topNews.image]];
        
        /* 添加新闻标题 */
        UILabel *topNewsLabel = [[UILabel alloc] init];
        topNewsLabel.text = topNews.title;
        topNewsLabel.textColor = [UIColor whiteColor];
        topNewsLabel.frame = CGRectMake(10, 150, self.screenWidth - 20, 80);
        
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
}

/**
 * 创建并设置分页控件
 */
- (void)setupPageControl {
    /* 创建一个分页控件 */
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 210, 100, 0)];
    
    /* 设置分页控件的页数 */
    self.pageControl.numberOfPages = self.topNews.count;
    
    //    self.pageControl.selected = YES;
    
    /* 添加动作事件 */
    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
}

/**
 * 自动滚动图片
 */
- (void)autoScrollImage {
    
    /* 获取当前页的页码 */
    NSInteger pageNumber = self.pageControl.currentPage;
    
    /* 若当前页的页码为最后一页，则将它设置为0，否则 + 1 */
    if (pageNumber == self.pageControl.numberOfPages - 1) {
        pageNumber = 0;
    }
    else {
        pageNumber ++;
    }
    
    /* 计算下一页的偏移值 */
    CGFloat offsetX = pageNumber * self.scrollView.frame.size.width;
    
    /* 设置 scrollView 的偏移值 */
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


#pragma mark - 加载网络数据
/**
 * 加载pageControl中的新闻
 */
- (void)loadTopDayNews {
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
        
        [self.dayNewsTableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        /* 提示加载失败信息 */
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}

/** 
 * 加载当日的新闻
 */
- (void)loadDayNews {
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
 * 获取 section 的数量
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/** 
 * 获取cell的数量
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }
    else {
        return self.dayNews.count;
    }
}

/** 
 * 返回封装好的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XHBDayNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XHBDayNewsCell forIndexPath:indexPath];
    
    cell.dayNewsItem = self.dayNews[indexPath.row];
    
    return cell;
}



#pragma mark - UITableViewDelegate 协议
/**
 * 返回指定 section 的头视图的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 220;
    }
    else {
        return 0;
    }
}

/**
 * 返回指定 section 的头视图，调用此方法需要先实现 tableView:heightForHeaderInSection: 方法
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    /* 创建并设置一个轮播图 */
    [self setupTopNews];
    
    return self.carouselView;
}

/**
 * 选中 cell 时调用
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /* 创建一个新闻内容对象 */
    XHBNewsContentViewController *newsContentVC = [[XHBNewsContentViewController alloc] init];
    
    /* 将新闻 id 赋值给 newsContentVC 对象 */
    XHBDayNews *dayNews = self.dayNews[indexPath.row];
    newsContentVC.newsId = dayNews.ID;
    
    /* 获得 rootViewController 的单例 */
//    XHBRootViewController *rootVC = [XHBRootViewController sharedInstance];
    
    /* 取消滑动菜单的手势 */
//    [rootVC removeGesture];
    
    /* 将新创建的新闻内容对象压入 navigationController */
    [self.navigationController pushViewController:newsContentVC animated:YES];
}



#pragma mark - UIScrollViewDelegate协议
/**
 * 当 topNews 视图滚动的时候，获取内容视图的偏移量
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /* 因为 tableView 也是继承 UIScrollView 的对象，所以要判断一下当前的 scrollView 是否是轮播图的 scrollView */
    if ([scrollView isEqual:self.scrollView]) {
        /* 获取内容视图坐标原点与屏幕滚动视图坐标原点的偏移量 */
        CGPoint offset = scrollView.contentOffset;
        self.pageControl.currentPage = offset.x / self.screenWidth;
    }
}

/** 
 * 实现即将开始拖拽的方法
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    /* 因为 tableView 也是继承 UIScrollView 的对象，所以要判断一下当前的 scrollView 是否是轮播图的 scrollView */
    if ([scrollView isEqual:self.scrollView]) {
        /* 停止计时器 */
        [self.timer invalidate];
        
        /* 在调用完 invalidate 的时候要将当前控制器的计时器对象设置为 nil，因为计时器和当前控制器形成了强引用循环，所以不设置为 nil 会导致计时器对象没有销毁，当前控制器也就无法调用 dealloc 方法 */
        self.timer = nil;
    }
    
}

/** 
 * 实现拖拽完毕的方法
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    /* 因为 tableView 也是继承 UIScrollView 的对象，所以要判断一下当前的 scrollView 是否是轮播图的 scrollView */
    if ([scrollView isEqual:self.scrollView]) {
        /* 创建一个新的 NSTimer 计时器来让轮播图每隔5秒自动滚动 */
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(autoScrollImage) userInfo:nil repeats:YES];
        
        /* 获取当前的消息循环对象 */
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        /* 将计时器对象的优先级设置为和控件的优先级一样 */
        [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
}

#pragma mark - UIPageControl动作方法
/** 
 * 当前页改变
 */
- (void)changePage {
    
    [UIView animateWithDuration:0.3 animations:^{
        /* 将偏移量设置为当前页乘以屏幕宽度 */
        NSInteger currentPage = self.pageControl.currentPage;
        self.scrollView.contentOffset = CGPointMake(self.screenWidth * currentPage, 0);
    }];
    
}



#pragma mark - 侧滑菜单动作事件方法
/**
 * 导航栏按钮动作事件 
 */
- (void)catalogClick {
    
    XHBRootViewController *rootVC = [XHBRootViewController sharedInstance];
    
    [rootVC navigationButton];
    
}



#pragma mark - 懒加载
/** 
 * 返回 manager 对象 
 */
- (AFHTTPSessionManager *)manager {
    /* 如果 _manager 为空 */
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}


@end
