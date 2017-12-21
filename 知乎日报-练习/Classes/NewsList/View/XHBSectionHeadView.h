//
//  XHBSectionHeadView.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/17.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBSectionHeadView : UITableViewHeaderFooterView

/** 新闻日期 */
@property (copy, nonatomic) NSString *date;

+ (instancetype)getSectionHeadViewWithTableView:(UITableView *)tableView;

@end
