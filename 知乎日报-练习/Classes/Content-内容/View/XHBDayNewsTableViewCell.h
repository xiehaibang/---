//
//  XHBDayNewsTableViewCell.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/4/25.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHBDayNews.h"

@interface XHBDayNewsTableViewCell : UITableViewCell

/** 今日日报对象 */
@property (strong, nonatomic) XHBDayNews *dayNewsItem;

@end
