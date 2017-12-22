//
//  XHBHomeNews.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/17.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBHomeNews : NSObject

/** 新闻发布的时间 */
@property (nonatomic, copy) NSString *date;

/** tabelView 的新闻列表 */
@property (nonatomic, strong) NSArray *stories;

/** 首页顶部的新闻 */
@property (nonatomic, strong) NSArray *top_stories;

@end
