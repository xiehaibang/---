//
//  XHBNewsHeadView.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/7.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBNewsHeadView.h"

@interface XHBNewsHeadView ()
/** 头部新闻提示信息 */
@property (nonatomic, strong) UILabel *promptLabel;

/** 载入上一条新闻是的动画的箭头图片 */
@property (nonatomic, strong) UIImageView *arrowImage;

/** 传进来的滚动视图 */
@property (nonatomic, weak) UIScrollView *scrollView;

/** 传进来的对象 */
@property (nonatomic, assign) id target;

/** 传进来的需要执行的方法 */
@property (nonatomic, assign) SEL action;

/** 视图是否加载过的布尔值 */
@property (nonatomic, assign) BOOL isLoaded;

@end

@implementation XHBNewsHeadView

#pragma mark - 视图设置
/**
 * 获取 XHBNewsHeadView 对象，并且对传进来的滚动视图进行监听
 */
+ (XHBNewsHeadView *)getViewObserveToScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action {
    
    //创建一个脚部视图
    XHBNewsHeadView *headView = [[XHBNewsHeadView alloc] init];
    
    headView.scrollView = scrollView;
    headView.target = target;
    headView.action = action;
    
    [headView setupView];
    
    //对传进来的 scrollView 的 contentOffset 进行监听
    [headView.scrollView addObserver:headView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return headView;
}

/** 
 * headView 的设置
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
 * 监听事件的发生
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //接收事件发生的对象
    UIScrollView *scrollView = object;

    //获取位置偏移值
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= 0) {
        return;
    }
    
    if (offsetY < - 60) {
        
        [UIView animateWithDuration:0.2 animations:^{
            //让箭头图片旋转180°
            self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        
        //如果停止拖拽 scrollView
//        if (!self.scrollView.isDragging && !self.isLoaded) {
//
//            //用 performSelector: 方法会存在内存泄露的危险，因为编译器不知道该对象能不能响应，如果不能，就是不安全的
//            //所以可以用 methodForSelector: 方法来获取指定方法的函数指针，在传入 receiver 和 selector 调用这个方法
//            ((void (*)(id, SEL))[self.target methodForSelector:self.action])(self.target, self.action);
//
//            //将视图设置为正在加载，以防止视图被销毁之前，因为 scrollView 的滚动再次加载别的新闻
//            self.isLoaded = YES;
//
//        }
    }
    else {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.arrowImage.transform = CGAffineTransformIdentity;
        }];
    }
    
}



#pragma mark - getter
- (UILabel *)promptLabel {
    
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        
        _promptLabel.text = @"载入上一篇";
        _promptLabel.textColor = [UIColor grayColor];
        _promptLabel.font = [UIFont systemFontOfSize:13];
        
        [_promptLabel sizeToFit];
    }
    
    return _promptLabel;
}

- (UIImageView *)arrowImage {
    
    if (!_arrowImage) {
        
        _arrowImage = [[UIImageView alloc] init];
        
        _arrowImage.image = [UIImage imageNamed:@"ZHAnswerViewBackIcon"];
    }
    
    return _arrowImage;
}


- (void)dealloc {
    
}

@end
