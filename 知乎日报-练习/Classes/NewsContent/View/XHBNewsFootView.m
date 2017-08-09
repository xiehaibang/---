//
//  XHBNewsFootView.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/7.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBNewsFootView.h"

@interface XHBNewsFootView ()

/** 底部视图的提示信息 */
@property (strong, nonatomic) UILabel *promptLabel;

/** 载入下一条新闻时的动画的箭头图片 */
@property (strong, nonatomic) UIImageView *arrowImage;

/** 传进来的对象 */
@property (assign, nonatomic) id target;

/** 传进来的需要执行的方法 */
@property (assign, nonatomic) SEL action;

/** 传进来的滚动视图 */
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation XHBNewsFootView

/**
 * 将 XHBNewsFootView 固定在传进来的视图上，并且对传进来的滚动视图进行监听
 */
+ (XHBNewsFootView *)attachObserveToScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action {
    
    //创建一个脚部视图
    XHBNewsFootView *footView = [[XHBNewsFootView alloc] init];
    
    footView.scrollView = scrollView;
    footView.target = target;
    footView.action = action;
    
    [footView setupView];
    
    //对传进来的 scrollView 的 contentOffset 进行监听
    [footView.scrollView addObserver:footView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    return footView;
}

/**
 * footView 的设置
 */
- (void)setupView {
    
    //设置 footView
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.size = CGSizeMake(screenWidth, 30);
    self.frame = frame;
    
    self.backgroundColor = [UIColor clearColor];
    
    //设置 arrowImage 和 promptLabel
    self.arrowImage.frame = CGRectMake(130, 5, 15, 20);
    
    frame = self.promptLabel.frame;
    frame.origin.x = self.arrowImage.frame.origin.x + 25;
    self.promptLabel.frame = frame;
    
    CGPoint center = self.promptLabel.center;
    center.y = self.arrowImage.center.y;
    self.promptLabel.center = center;

    
    [self addSubview:self.promptLabel];
    [self addSubview:self.arrowImage];
}


/**
 * 监听事件发生
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //接收事件发生的对象
    UIScrollView *scrollView = object;
    
    //获取偏移值
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < scrollView.contentSize.height - scrollView.frame.size.height) {
        return;
    }
    else if (offsetY > scrollView.contentSize.height - scrollView.frame.size.height + 60) {
        
        [UIView animateWithDuration:0.2 animations:^{
            //让箭头图片旋转180°
            self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        
        //如果 scrollView 停止滚动
        if (!self.scrollView.isDragging) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            //使用宏来忽略警告
            [self.target performSelector:self.action];
#pragma clang diagnostic pop
        }
        
    }
    else {
        
        //将箭头旋转回原位
        [UIView animateWithDuration:0.2 animations:^{
            self.arrowImage.transform = CGAffineTransformIdentity;
        }];
    }
    
}


#pragma mark - getter
- (UILabel *)promptLabel {
    
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        
        _promptLabel.text = @"载入下一篇";
        _promptLabel.textColor = [UIColor grayColor];
        _promptLabel.font = [UIFont systemFontOfSize:13];
        
        [_promptLabel sizeToFit];
    }
    
    return _promptLabel;
}

- (UIImageView *)arrowImage {
    
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc] init];
        
        _arrowImage.image = [UIImage imageNamed:@"ZHAnswerViewPrevIcon"];
    }
    
    return _arrowImage;
}

@end
