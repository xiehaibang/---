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

/** 视图知否加载过的布尔值 */
@property (assign, nonatomic) BOOL isLoaded;

@end

@implementation XHBNewsFootView

#pragma mark - 视图的设置
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
    [footView.scrollView addObserver:footView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return footView;
}

/**
 * footView 的设置
 */
- (void)setupView {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.promptLabel];
    [self addSubview:self.arrowImage];
    
    //给箭头图片添加约束
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).with.offset(140);
        make.top.equalTo(self).with.offset(5);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    //给提示信息对象添加约束
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.arrowImage.mas_right).with.offset(10);
        make.centerY.equalTo(self.arrowImage.mas_centerY);
    }];
}


/**
 * 监听事件发生
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //接收事件发生的对象
    UIScrollView *scrollView = object;
    
    //获取偏移值
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (!scrollView.isDragging) {
    
        if (offsetY < scrollView.contentSize.height - scrollView.frame.size.height) {
            return;
        }
        else if (offsetY > scrollView.contentSize.height - scrollView.frame.size.height + 60) {
            
            [UIView animateWithDuration:0.2 animations:^{
                //让箭头图片旋转180°
                self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            
            //如果 scrollView 停止滚动
            if (!self.scrollView.isDragging && !self. isLoaded) {
                //用 performSelector: 方法会存在内存泄露的危险，因为编译器不知道该对象能不能响应，如果不能，就是不安全的
                //所以可以用 methodForSelector: 方法来获取指定方法的函数指针，在传入 receiver 和 selector 调用这个方法
                ((void (*)(id, SEL))[self.target methodForSelector:self.action])(self.target, self.action);
                
                //将视图设置已经加载过，以防止视图被销毁之前，因为 scrollView 的滚动再次加载别的新闻
                self.isLoaded = YES;
            }
            
        }
        else {
            
            //将箭头旋转回原位
            [UIView animateWithDuration:0.2 animations:^{
                self.arrowImage.transform = CGAffineTransformIdentity;
            }];
        }
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
