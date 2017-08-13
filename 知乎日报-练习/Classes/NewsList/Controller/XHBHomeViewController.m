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
#import "XHBContainerViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "UIImageView+WebCache.h"


@interface XHBHomeViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

/** 今日新闻列表视图 */
@property (weak, nonatomic) IBOutlet UITableView *dayNewsTableView;

/** 计时器对象 */
@property (strong, nonatomic) NSTimer *timer;

/** AFN 网络请求管理者 */
@property (strong, nonatomic) AFHTTPSessionManager *manager;

/** 今日新闻数组 */
@property (copy, nonatomic) NSArray *dayNews;

/** 今日新闻的新闻 id 数组 */
@property (strong, nonatomic) NSArray *dayNewsId;

/** 顶部新闻数组 */
@property (strong, nonatomic) NSArray *topNews;

/** 顶部新闻的轮播图对象 */
@property (strong, nonatomic) UIView *carouselView;

/** 顶部滚动视图 */
@property (strong, nonatomic) UIScrollView *scrollView;

/** 顶部分屏控件 */
@property (strong, nonatomic) UIPageControl *pageControl;

/** 顶部新闻对象 */
@property (strong, nonatomic) XHBDayNews *topDayNews;

/** 顶部滚动新闻图片数量 */
@property (assign, nonatomic) NSInteger imageCount;

/** 顶部滚动新闻当前图片索引 */
@property (assign, nonatomic) NSInteger currentImageIndex;

/** 顶部滚动新闻的左边图片 */
@property (strong, nonatomic) UIImageView *leftImageView;

/** 顶部滚动新闻的右边图片 */
@property (strong, nonatomic) UIImageView *rightImageView;

/** 顶部滚动新闻的中间图片 */
@property (strong, nonatomic) UIImageView *centerImageView;

/** 顶部滚动新闻的左边图片标题 */
@property (strong, nonatomic) UILabel *leftImageTitle;

/** 顶部滚动新闻的右边图片标题 */
@property (strong, nonatomic) UILabel *rightImageTitle;

/** 顶部滚动新闻的中间图片标题 */
@property (strong, nonatomic) UILabel *centerImageTitle;

@end


@implementation XHBHomeViewController

#pragma mark - 常量
/* 将dayNewsCell的标识符设置为常量 */
static NSString * const XHBDayNewsCell = @"dayNewsCell";

#pragma mark - viewController 生命周期
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //显示导航栏
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 控件初始化设置 */
    [self setupView];
    
    /* 加载顶部的滚动的新闻 */
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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /* 创建导航栏按钮 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithImageName:@"Home_Icon" highImageName:@"Home_Icon_Highlight" target:self action:@selector(catalogClick)];
    
    /* 为tableView队列中的cell注册类 */
    NSString *className = NSStringFromClass([XHBDayNewsTableViewCell class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [self.dayNewsTableView registerNib:nib forCellReuseIdentifier:XHBDayNewsCell];
    
    /* 设置dayNewsTableView的行高 */
    self.dayNewsTableView.rowHeight = 90;
    
    self.dayNewsTableView.showsVerticalScrollIndicator = NO;
    
    //设置导航栏的标题
    self.navigationItem.title = @"今日新闻";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    //创建一个计时器
    [self setupTimer];
    
}



#pragma mark - 设置顶部新闻
/** 
 * 创建并设置轮播图
 */
- (void)setupTopNews {
    
    /* 创建并设置滚动视图 */
    [self setupScrollView];
    
    /* 创建并设置分页控件 */
    [self setupPageControl];
    
}


/**
 * 创建并设置滚动视图 
 */
- (void)setupScrollView {
    /* 创建一个 scrollView 对象 */
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
    
    //scrollView 的宽和高
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    CGFloat scrollViewHeight = self.scrollView.frame.size.height;
    
    /* 设置ScrollView的委托对象 */
    self.scrollView.delegate = self;
    
    /* 启用分页 */
    self.scrollView.pagingEnabled = YES;
    
    /* 设置ScrollView的内容视图的大小 */
    self.scrollView.contentSize = CGSizeMake(scrollViewWidth * 3, scrollViewHeight);
    
    /* 设置内容视图的坐标原点 */
    self.scrollView.contentOffset = CGPointMake(scrollViewWidth, 0);
    
    /* 隐藏水平滚动控件 */
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    /* 隐藏垂直滚动控件 */
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    //将滚动视图超过内容视图边缘时的反弹效果关闭
    self.scrollView.bounces = NO;
    
    //设置图片的总数
    self.imageCount = self.topNews.count;
    
    //添加3个 ImageView
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
    [self.scrollView addSubview:self.leftImageView];
    
    self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight)];
    [self.scrollView addSubview:self.centerImageView];
    
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollViewWidth * 2, 0, scrollViewWidth, scrollViewHeight)];
    [self.scrollView addSubview:self.rightImageView];
    
    //初始化 scrollView 的图片
    [self setDefaultImage];
    
    /* 将滚动视图添加到轮播图对象中 */
    [self.carouselView addSubview:self.scrollView];
}

/**
 * 创建并设置分页控件
 */
- (void)setupPageControl {
    /* 初始化一个分页控件 */
    self.pageControl = [[UIPageControl alloc] init];
    
    //根据页数返回合适的大小
    CGSize pageSize = [self.pageControl sizeForNumberOfPages:self.imageCount];
    
    self.pageControl.bounds = CGRectMake(0, 0, pageSize.width, pageSize.height);
    self.pageControl.center = CGPointMake(self.scrollView.frame.size.width / 2, 210);
    
    /* 设置分页控件的页数 */
    self.pageControl.numberOfPages = self.imageCount;
    
    /* 添加动作事件 */
    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    
    /* 将分页控件添加到轮播图对象中 */
    [self.carouselView addSubview:self.pageControl];
}

/**
 * 创建并设置一个计时器
 */
- (void)setupTimer {
    /* 创建 NSTimer 计时器来让轮播图每隔5秒自动滚动 */
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(autoScrollImage) userInfo:nil repeats:YES];
    
    /* 获取当前的消息循环对象 */
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    /* 将计时器对象的优先级设置为和控件的优先级一样 */
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 * 创建并设置轮播图的标题
 */
- (void)setupTitle:(NSString *)title imageView:(UIImageView *)imageView {
    
    if ([imageView isEqual:self.leftImageView]) {
        
        if (self.leftImageTitle == NULL) {
            //设置 title 的位置和大小
            self.leftImageTitle = [[UILabel alloc] init];
            
            //设置 title 的颜色
            self.leftImageTitle.textColor = [UIColor whiteColor];
            
            self.leftImageTitle.font = [UIFont boldSystemFontOfSize:20];
            
            //设置标签显示行数，0为显示多行
            self.leftImageTitle.numberOfLines = 0;
            
            //设置topNewsLabel根据字数自适应高度
            self.leftImageTitle.lineBreakMode = NSLineBreakByWordWrapping;
            
            //设置topNewsLabel的文字对齐方式
            self.leftImageTitle.textAlignment = NSTextAlignmentLeft;
            
            /* 将新闻标题添加到新闻图片上 */
            [imageView addSubview:self.leftImageTitle];
            
            //给新闻标题添加约束
            [self.leftImageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(imageView.mas_left).with.offset(15);
                make.right.equalTo(imageView.mas_right).with.offset(-15);
                make.bottom.equalTo(imageView.mas_bottom).with.offset(-20);
            }];
        }
        
        self.leftImageTitle.text = title;
        
    }
    
    if ([imageView isEqual:self.rightImageView]) {
        
        if (self.rightImageTitle == NULL) {
            //设置 title 的位置和大小
            self.rightImageTitle = [[UILabel alloc] init];
            
            //设置 title 的颜色
            self.rightImageTitle.textColor = [UIColor whiteColor];
            
            self.rightImageTitle.font = [UIFont boldSystemFontOfSize:20];
            
            //设置标签显示行数，0为显示多行
            self.rightImageTitle.numberOfLines = 0;
            
            //设置topNewsLabel根据字数自适应高度
            self.rightImageTitle.lineBreakMode = NSLineBreakByWordWrapping;
            
            //设置topNewsLabel的文字对齐方式
            self.rightImageTitle.textAlignment = NSTextAlignmentLeft;
            
            /* 将新闻标题添加到新闻图片上 */
            [imageView addSubview:self.rightImageTitle];
            
            //给新闻标题添加约束
            [self.rightImageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(imageView.mas_left).with.offset(15);
                make.right.equalTo(imageView.mas_right).with.offset(-15);
                make.bottom.equalTo(imageView.mas_bottom).with.offset(-20);
            }];
        }
        
        self.rightImageTitle.text = title;

    }
    
    if ([imageView isEqual:self.centerImageView]) {
        
        if (self.centerImageTitle == NULL) {
            //设置 title 的位置和大小
            self.centerImageTitle = [[UILabel alloc] init];
            
            //设置 title 的颜色
            self.centerImageTitle.textColor = [UIColor whiteColor];
            
            self.centerImageTitle.font = [UIFont boldSystemFontOfSize:20];
            
            //设置标签显示行数，0为显示多行
            self.centerImageTitle.numberOfLines = 0;
            
            //设置topNewsLabel根据字数自适应高度
            self.centerImageTitle.lineBreakMode = NSLineBreakByWordWrapping;
            
            //设置topNewsLabel的文字对齐方式
            self.centerImageTitle.textAlignment = NSTextAlignmentLeft;
            
            /* 将新闻标题添加到新闻图片上 */
            [imageView addSubview:self.centerImageTitle];
            
            //给新闻标题添加约束
            [self.centerImageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(imageView.mas_left).with.offset(15);
                make.right.equalTo(imageView.mas_right).with.offset(-15);
                make.bottom.equalTo(imageView.mas_bottom).with.offset(-20);
            }];
        }
        
        self.centerImageTitle.text = title;
        
    }
}

/**
 * 自动滚动图片
 */
- (void)autoScrollImage {
    
    //将 scrollView 的 contentOffset 设置到下一页
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];
    
    //创建一个不循环的计时器
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
    
}

/** 
 * 设置默认显示的图片 
 */
- (void)setDefaultImage {
    
    //加载默认显示的图片，并添加标题
    self.topDayNews = self.topNews[self.imageCount - 1];
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.topDayNews.image]];
    [self setupTitle:self.topDayNews.title imageView:self.leftImageView];
    
    self.topDayNews = self.topNews[0];
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.topDayNews.image]];
    [self setupTitle:self.topDayNews.title imageView:self.centerImageView];
    
    self.topDayNews = self.topNews[1];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.topDayNews.image]];
    [self setupTitle:self.topDayNews.title imageView:self.rightImageView];
    
    //当前显示的图片索引
    self.currentImageIndex = 0;
    
    //设置当前页
    self.pageControl.currentPage = self.currentImageIndex;
    
    
}

/**
 * 滚动时重新加载图片
 */
- (void)reloadImage {
    
    //声明左边 ImageView 和右边 ImageView 的图片索引
    NSInteger leftImageIndex, rightImageIndex;
    
    CGPoint offset = [self.scrollView contentOffset];
    
    //滚动到右边
    if (offset.x > self.scrollView.frame.size.width) {
        self.currentImageIndex = (self.currentImageIndex + 1) % self.imageCount;
    }
    else if (offset.x < self.scrollView.frame.size.width) { //滚动到左边
        self.currentImageIndex = (self.currentImageIndex + self.imageCount - 1) % self.imageCount;
    }
    
    //设置 pageControl 的当前页
    self.pageControl.currentPage = self.currentImageIndex;
    
    //根据当前图片索引加载 centerImageView 的图片和标题
    self.topDayNews = self.topNews[self.currentImageIndex];
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.topDayNews.image]];
    [self setupTitle:self.topDayNews.title imageView:self.centerImageView];
    
    //计算左边 ImageView 和右边 ImageView 的图片索引
    leftImageIndex = (self.currentImageIndex + self.imageCount - 1) % self.imageCount;
    rightImageIndex = (self.currentImageIndex + 1) % self.imageCount;
    
    //根据左边和右边的图片索引加载 leftImageView 和 rightImageView 的图片和标题
    self.topDayNews = self.topNews[leftImageIndex];
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.topDayNews.image]];
    [self setupTitle:self.topDayNews.title imageView:self.leftImageView];
    
    self.topDayNews = self.topNews[rightImageIndex];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.topDayNews.image]];
    [self setupTitle:self.topDayNews.title imageView:self.rightImageView];
    
}



#pragma mark - 加载网络数据
/**
 * 加载pageControl中的新闻
 */
- (void)loadTopDayNews {
    
    /* 在 block 中替换属性的名称，让属性名和网络数据中的 key 相对应 */
    [XHBDayNews mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{
                 @"ID" : @"id"
                 };
        
    }];
    
    //打开网络活动指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    /* 发送无参数网络请求 */
    [self.manager GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        /* 转换数据模型 */
        self.topNews = [XHBDayNews mj_objectArrayWithKeyValuesArray:responseObject[@"top_stories"]];
        
        /* 创建并设置一个轮播图 */
        [self setupTopNews];
        
        [self.dayNewsTableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        /* 提示加载失败信息 */
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
}

/** 
 * 加载当日的新闻
 */
- (void)loadDayNews {
    
    //打开网络活动指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    /* 发送网络请求 */
    [self.manager GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        self.dayNews = [XHBDayNews mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
        
        self.dayNewsId = [self.dayNews valueForKeyPath:@"ID"];
        
        /* 刷新表格 */
        [self.dayNewsTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
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
    
    return self.carouselView;
}

/**
 * 选中 cell 时调用
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    /* 创建一个新闻内容对象 */
//    XHBNewsContentViewController *newsContentVC = [[XHBNewsContentViewController alloc] init];
//    
//    /* 将新闻 id 赋值给 newsContentVC 对象 */
//    XHBDayNews *dayNews = self.dayNews[indexPath.row];
//    newsContentVC.newsId = dayNews.ID;
    
    //创建一个新闻内容容器对象
    XHBContainerViewController *containerVC = [[XHBContainerViewController alloc] init];
    
    //将新闻 id 和本类对象赋值给新闻容器对象
    containerVC.newsId = [[self.dayNewsId objectAtIndex:indexPath.row] integerValue];
    containerVC.homeVC = self;
    
    /* 将新创建的新闻内容对象压入 navigationController */
    [self.navigationController pushViewController:containerVC animated:YES];
}



#pragma mark - UIScrollViewDelegate协议
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
        
        //重新创建一个计时器
        [self setupTimer];
    }
    
}

/**
 * 实现视图停止滚动时的方法
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.imageCount != 0) {
        //重新加载图片
        [self reloadImage];
    }
    
    //将 scrollView 的 contentOffset 设置为 centerImageView，将滚动的动画效果关闭
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
}



#pragma mark - XHBNewsContentControllerDelegate
/**
 * 通过本条新闻的 id 获取下一条新闻的 id
 */
- (NSInteger)getNextNewsWithNewsId:(NSInteger)newsId {
    
    //获取当前新闻 id 在新闻 id 数组中的位置
    NSInteger idIndex = [self.dayNewsId indexOfObject:[NSNumber numberWithInteger:newsId]];
    
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



#pragma mark - UIPageControl动作方法
/** 
 * 当前页改变
 */
- (void)changePage {
    
    [UIView animateWithDuration:0.3 animations:^{
        /* 将偏移量设置为当前页乘以屏幕宽度 */
        NSInteger currentPage = self.pageControl.currentPage;
        self.scrollView.contentOffset = CGPointMake(screenWidth * currentPage, 0);
    }];
    
}



#pragma mark - 按钮动作事件方法
/**
 * 导航栏按钮动作事件 
 */
- (void)catalogClick {
    
    XHBRootViewController *rootVC = [XHBRootViewController sharedInstance];
    
    [rootVC navigationButton];
    
}

/**
 * 轮播图的图片按钮动作事件
 */
- (void)imageViewClick {
    
    NSLog(@"第%lu张图片", self.pageControl.currentPage);
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

/** 
 * 返回一个轮播图对象
 */
- (UIView *)carouselView {
    
    if (!_carouselView) {
        _carouselView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
    }
    
    return _carouselView;
}

@end
