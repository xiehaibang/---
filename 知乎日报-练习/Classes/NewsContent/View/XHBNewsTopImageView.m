//
//  XHBNewsTopImageView.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/9.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBNewsTopImageView.h"
#import "UIImageView+WebCache.h"

@interface XHBNewsTopImageView ()

/** 传进来的滚动视图 */
@property (weak, nonatomic) UIScrollView *scrollView;

/** 传进来的视图, 用不了 weak  */
@property (weak, nonatomic) UIView *newsContentView;

/** 新闻图片 */
@property (strong, nonatomic) UIImageView *newsImage;

/** 新闻图片的标题 */
@property (strong, nonatomic) UILabel *imageTitle;

/** 新闻图片的来源信息 */
@property (strong, nonatomic) UILabel *imageSource;

@end

@implementation XHBNewsTopImageView

#pragma mark - 视图的生命周期
/**
 * 视图销毁的时候
 */
- (void)dealloc {
    
//    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}


#pragma mark - 视图的设置
/**
 * 将 XHBNewsTopImageView 固定在传进来的视图上，并且监听传进来的滚动视图的偏移值
 */
+ (XHBNewsTopImageView *)attachToView:(UIView *)view observeScorllView:(UIScrollView *)scrollView {
    
    XHBNewsTopImageView *topImageView = [[XHBNewsTopImageView alloc] init];
    
//    topImageView.frame = CGRectMake(0, -kTopImageYValue, screenWidth, 265);
    
    topImageView.scrollView = scrollView;
    topImageView.newsContentView = view;
    
    //设置 topImageView
    [topImageView setupView];
    
    [topImageView.scrollView addObserver:topImageView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return topImageView;
}

/**
 * 设置 topImageView
 */
- (void)setupView {

    //给 topImageView 添加新闻标题和图片来源信息
    [self addSubview:self.newsImage];
    [self addSubview:self.imageTitle];
    [self addSubview:self.imageSource];
    
    //设置 newsImage 的约束
    [self.newsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    //设置新闻标题的约束
    [self.imageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
//        make.bottom.equalTo(self.mas_bottom).with.offset(-30);
        make.bottom.equalTo(self.imageSource.mas_top);
    }];
    
    [self.imageSource mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-8);
        make.height.mas_equalTo(20);
    }];
    
}


#pragma mark - 事件
/** 
 * 监听事件的发生
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    
    //接收产生事件的对象
    UIScrollView *scrollView = object;
    
    //获取偏移值
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0 && offsetY >= -90) {
                
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.newsContentView.mas_top).with.offset(-kTopImageYValue - 0.5 * offsetY);
            make.height.mas_equalTo(kTopImageHeight - 0.5 * offsetY);
        }];
        
    }
    else if (offsetY < -90) {
        self.scrollView.contentOffset = CGPointMake(0, -90);
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
        self.y = -kTopImageYValue - offsetY;
        
    }
    
}



#pragma mark - setter 和 getter
- (void)setNewsContent:(XHBNewsContent *)newsContent {
    
    _newsContent = newsContent;

    self.imageTitle.text = _newsContent.title;
    self.imageSource.text = [NSString stringWithFormat:@"图片:%@", _newsContent.image_source];
    [self.newsImage sd_setImageWithURL:[NSURL URLWithString:_newsContent.image]];
}

- (UILabel *)imageTitle {
    
    if (!_imageTitle) {
        
        _imageTitle = [[UILabel alloc] init];
        
        _imageTitle.textColor = [UIColor whiteColor];
        
        _imageTitle.font = [UIFont systemFontOfSize:20];
        
        _imageTitle.numberOfLines = 0;
        
        _imageTitle.lineBreakMode = NSLineBreakByWordWrapping;
        
        _imageTitle.textAlignment = NSTextAlignmentLeft;
        
        [_imageTitle sizeToFit];
    }
    
    return _imageTitle;
}

- (UILabel *)imageSource {
    
    if (!_imageSource) {
        
        _imageSource = [[UILabel alloc] init];
        
        _imageSource.textColor = [UIColor whiteColor];
        
        _imageSource.font = [UIFont systemFontOfSize:12];
        
        [_imageSource sizeToFit];
    }
    
    return _imageSource;
}

- (UIImageView *)newsImage {
    
    if (!_newsImage) {
        
        _newsImage = [[UIImageView alloc] init];
    
    }
    
    return _newsImage;
}

@end
