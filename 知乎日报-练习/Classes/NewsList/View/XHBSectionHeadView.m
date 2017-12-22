//
//  XHBSectionHeadView.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/17.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBSectionHeadView.h"

@interface XHBSectionHeadView ()

@property (nonatomic, strong) UILabel *title;

@end

static NSString * const headerId = @"homeSectionHead";

@implementation XHBSectionHeadView

+ (instancetype)getSectionHeadViewWithTableView:(UITableView *)tableView {
    
    XHBSectionHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    
    if (!headView) {
        headView = [[XHBSectionHeadView alloc] init];
        
        headView.contentView.backgroundColor = XHBColor(23, 144, 211);
    }
    
    return headView;
}

//必须在layoutsubviews 里边写
- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.centerX = self.centerX;
}

#pragma mark - setter
- (void)setDate:(NSString *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CH"];
    
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSDate *formatedDate = [dateFormatter dateFromString:date];
    
    [dateFormatter setDateFormat:@"MM月dd日 EEEE"];
    
    _date = [dateFormatter stringFromDate:formatedDate];
    
//    [self addSubview:self.title];
//    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.mas_centerX);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
    
    self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:self.date
                                                                    attributes:@{
                                                                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18],
                                                                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                 }];
}


#pragma mark - getter
- (UILabel *)title {
    
    if (!_title) {
        _title = [[UILabel alloc] init];
        
        _title.attributedText = [[NSAttributedString alloc] initWithString:self.date
                                                                    attributes:@{
                                                                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18],
                                                                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                 }];
    }
    
    return _title;
}

@end
