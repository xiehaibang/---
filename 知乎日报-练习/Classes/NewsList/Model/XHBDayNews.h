//
//  XHBDayNews.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/4/18.
//  Copyright © 2017年 谢海邦. All rights reserved.
//  新闻列表模型

#import <Foundation/Foundation.h>

@interface XHBDayNews : NSObject

/** 新闻标题 */
@property (nonatomic, strong) NSString *title;

/** 图片地址数组(官方 API 使用数组形式。目前暂未有使用多张图片的情形出现，有无 images 属性的情况，请在使用中注意) */
@property (nonatomic, strong) NSArray *images;

/** 图片地址 */
@property (nonatomic, strong) NSString *image;

/** 新闻ID */
@property (nonatomic, assign) NSInteger ID;

@end
