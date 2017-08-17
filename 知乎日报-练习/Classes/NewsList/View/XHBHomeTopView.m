//
//  XHBHomeTopView.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/12.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBHomeTopView.h"
#import "XHBDayNews.h"

#import "UIImageView+WebCache.h"

@interface XHBHomeTopView () <UIScrollViewDelegate>

/** 顶部滚动视图 */
@property (strong, nonatomic) UIScrollView *carouselScroll;

/** 顶部分屏控件 */
@property (strong, nonatomic) UIPageControl *pageControl;

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

/** 顶部新闻对象 */
@property (strong, nonatomic) XHBDayNews *topDayNews;

/** 传进来的首页对象 */
@property (weak, nonatomic) UIView *homeView;

@end

@implementation XHBHomeTopView

/**
 * 将 XHBHomeTopView 固定在传进来的视图上，并且监听传进来的滚动视图的偏移值
 */
+ (XHBHomeTopView *)attachToView:(UIView *)view observeScrollView:(UIScrollView *)scrollView {
    
    XHBHomeTopView *topView = [[XHBHomeTopView alloc] init];
    
    topView.homeView = view;
    
    //给传进来的滚动视图添加监听
    [scrollView addObserver:topView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    return topView;
}

/** 
 * 监听事件发生时
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //接收产生事件的对象
    UIScrollView *scrollView = object;
    
    //获取偏移值
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0 && offsetY >= -90) {
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.homeView.mas_top).with.offset(-45 - 0.5 * offsetY);
            make.height.mas_equalTo(265 - 0.5 * offsetY);
        }];
        
    }
    else if (offsetY < -90) {
        scrollView.contentOffset = CGPointMake(0, -90);
    }
    else if (offsetY <= 500) {
        
        //如果图片视图还没有消失，就让状态栏保持浅色
        if (offsetY <= 220) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
        else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
        
        //让图片视图跟着新闻滚动
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-45 - offsetY);
        }];
        
    }
}


#pragma mark - 轮播图视图的设置
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
    self.carouselScroll = [[UIScrollView alloc] init];
    
    /* 设置ScrollView的委托对象 */
    self.carouselScroll.delegate = self;
    
    /* 启用分页 */
    self.carouselScroll.pagingEnabled = YES;
    
//    self.carouselScroll.contentMode = UIViewContentModeCenter;
    
    /* 隐藏水平滚动控件 */
    self.carouselScroll.showsHorizontalScrollIndicator = NO;
    
    /* 隐藏垂直滚动控件 */
    self.carouselScroll.showsVerticalScrollIndicator = NO;
    
    //将滚动视图超过内容视图边缘时的反弹效果关闭
    self.carouselScroll.bounces = NO;
    
    //设置图片的总数
    self.imageCount = self.topNews.count;
    
    /* 将滚动视图添加到轮播图对象中 */
    [self addSubview:self.carouselScroll];
    
    [self.carouselScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(265);
    }];
    
    /* 设置ScrollView的内容视图的大小 */
    self.carouselScroll.contentSize = CGSizeMake(screenWidth * 3, 265);
    
    /* 设置内容视图的坐标原点 */
    self.carouselScroll.contentOffset = CGPointMake(screenWidth, 0);
    
    //添加3个 ImageView
    self.leftImageView = [[UIImageView alloc] init];
    [self.carouselScroll addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.carouselScroll.mas_left);
        make.top.equalTo(self.carouselScroll.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(265);
    }];
    
    self.centerImageView = [[UIImageView alloc] init];
    [self.carouselScroll addSubview:self.centerImageView];
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.carouselScroll.mas_left).with.offset(screenWidth);
        make.top.equalTo(self.carouselScroll.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(265);
    }];
    
    self.rightImageView = [[UIImageView alloc] init];
    [self.carouselScroll addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.carouselScroll.mas_left).with.offset(screenWidth * 2);
        make.top.equalTo(self.carouselScroll.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(265);
    }];
    
    //创建点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsTapAction:)];
    
    //给 scrollView 添加点击手势
    [self.carouselScroll addGestureRecognizer:tap];
    
    //创建计时器
    [self createTimer];
    [self stopTimer];
    
    //初始化 scrollView 的图片
    [self setDefaultImage];

    
}

/**
 * 创建并设置分页控件
 */
- (void)setupPageControl {
    /* 初始化一个分页控件 */
    self.pageControl = [[UIPageControl alloc] init];
    
    //根据页数返回合适的大小
    CGSize pageSize = [self.pageControl sizeForNumberOfPages:self.imageCount];
    
    /* 设置分页控件的页数 */
    self.pageControl.numberOfPages = self.imageCount;
    
    /* 添加动作事件 */
//    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    
    /* 将分页控件添加到轮播图对象中 */
    [self addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(pageSize.width);
        make.height.mas_equalTo(pageSize.height);
    }];
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
    [self.carouselScroll setContentOffset:CGPointMake(screenWidth * 2, 0) animated:YES];
    
    //创建一个不循环的计时器
//    [UIView animateWithDuration:0.3 animations:^{
//        [self performSelector:@selector(scrollViewDidEndDecelerating:)];
//    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ((void (*)(id, SEL))[self methodForSelector:@selector(scrollViewDidEndDecelerating:)])(self, @selector(scrollViewDidEndDecelerating:));
    });
    
//    [self performSelector:@selector(scrollViewDidEndDecelerating:)];
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
    
    //启动计时器
    [self startTimer];

}

/**
 * 滚动时重新加载图片
 */
- (void)reloadImage {
    
    //声明左边 ImageView 和右边 ImageView 的图片索引
    NSInteger leftImageIndex, rightImageIndex;
    
    CGPoint offset = [self.carouselScroll contentOffset];
    
    //滚动到右边
    if (offset.x > self.carouselScroll.width) {
        self.currentImageIndex = (self.currentImageIndex + 1) % self.imageCount;
    }
    else if (offset.x < self.carouselScroll.frame.size.width) { //滚动到左边
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


#pragma mark - 计时器的设置
/**
 * 创建计时器
 */
- (void)createTimer {
    /* 创建 NSTimer 计时器来让轮播图每隔5秒自动滚动 */
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(autoScrollImage) userInfo:nil repeats:YES];
    
    /* 获取当前的消息循环对象 */
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    /* 将计时器对象的优先级设置为和控件的优先级一样 */
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 * 启动计时器
 */
- (void)startTimer {
    
    if (![self.timer isValid]) {
        return;
    }
    
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
}

/**
 * 停止轮播图的计时器
 */
- (void)stopTimer {
    
    if (![self.timer isValid]) {
        return;
    }
    
    //distantFuture: 将返回：4001-01-01 00:00:00 +0000
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)deleteTimer {
    /* 停止计时器 */
    [self.timer invalidate];
    
    /* 在调用完 invalidate 的时候要将当前控制器的计时器对象设置为 nil，因为计时器和当前控制器形成了强引用循环，所以不设置为 nil 会导致计时器对象没有销毁，当前控制器也就无法调用 dealloc 方法 */
    self.timer = nil;
}


#pragma mark - 点击进入新闻
- (void)newsTapAction:(UITapGestureRecognizer *)tap {
    
    if (self.tapActionBlock) {
        
        self.topDayNews = self.topNews[self.currentImageIndex];
        
        self.tapActionBlock(self.topDayNews.ID);
    }
}



#pragma mark - UIScrollViewDelegate协议
/**
 * 实现即将开始拖拽的方法
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    /* 停止计时器 */
    [self stopTimer];
    
}

/**
 * 实现拖拽完毕的方法
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    //启动计时器
    [self startTimer];

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
    [self.carouselScroll setContentOffset:CGPointMake(screenWidth, 0) animated:NO];
}


#pragma mark - UIPageControl动作方法
/**
 * 当前页改变
 */
//- (void)changePage {
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        /* 将偏移量设置为当前页乘以屏幕宽度 */
//        NSInteger currentPage = self.pageControl.currentPage;
//        self.carouselScroll.contentOffset = CGPointMake(screenWidth * currentPage, 0);
//    }];
//    
//}


#pragma mark - setter
- (void)setTopNews:(NSArray *)topNews {
    
    if (!_topNews) {
        
        _topNews = topNews;
        
        //创建并设置轮播图
        [self setupTopNews];
    }
    else {
        
        _topNews = topNews;
        
        //初始化轮播图的图片
        [self setDefaultImage];
    }
    
}


- (void)dealloc {
    
}

@end
