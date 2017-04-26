//
//  XHBDayNewsTableViewCell.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/4/25.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBDayNewsTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface XHBDayNewsTableViewCell ()
/** 新闻标题 */
@property (weak, nonatomic) IBOutlet UILabel *dayNewsTitle;

/** 新闻图片 */
@property (weak, nonatomic) IBOutlet UIImageView *dayNewsImage;


@end

@implementation XHBDayNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 存取方法
- (void)setDayNewsItem:(XHBDayNews *)dayNewsItem
{
    _dayNewsItem = dayNewsItem;
    
    /* 添加新闻图片 */
    [self.dayNewsImage sd_setImageWithURL:[NSURL URLWithString:dayNewsItem.images[0]]];
    
    /* 添加新闻标题 */
    self.dayNewsTitle.text = dayNewsItem.title;
    
}

@end
