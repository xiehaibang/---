//
//  XHBCatalogTableViewCell.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/12.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBCatalogTableViewCell.h"

@interface XHBCatalogTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *newsNamelable;

@end

@implementation XHBCatalogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /* 设置cell的字体颜色 */
//    self.textLabel.textColor = XHBColor(153, 157, 161);
    
    /* 设置cell被选中时的背景颜色 */
    UIColor *customColor = XHBColor(27, 35, 41);
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = customColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 存取方法
- (void)setCategoryItem:(XHBNewCatalog *)categoryItem
{
    _categoryItem = categoryItem;
    
    self.newsNamelable.text = categoryItem.name;
}

@end
