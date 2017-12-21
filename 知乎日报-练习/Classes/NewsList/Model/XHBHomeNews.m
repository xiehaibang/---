//
//  XHBHomeNews.m
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/8/17.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import "XHBHomeNews.h"
#import "XHBDayNews.h"

@implementation XHBHomeNews

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"stories" : [XHBDayNews class],
             @"top_stories" : [XHBDayNews class],
             };
}

@end
