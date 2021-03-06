//
//  XHBCatalogTableViewCell.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/12.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHBNewCatalog.h"

@interface XHBCatalogTableViewCell : UITableViewCell

/* 主题日报对象 */
@property (nonatomic, strong) XHBNewCatalog *categoryItem;

/**
 * 设置首页 cell
 */
- (void)setupHomeCell;

@end
