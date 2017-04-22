//
//  XHBDayNews.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/4/18.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBDayNews : NSObject

/** 新闻标题 */
@property (strong, nonatomic) NSString *title;

/** 图片地址数组(官方 API 使用数组形式。目前暂未有使用多张图片的情形出现，有无 images 属性的情况，请在使用中注意) */
@property (strong, nonatomic) NSArray *images;

/** 图片地址 */
@property (strong, nonatomic) NSString *image;

/** 新闻ID */
@property (assign, nonatomic) NSInteger id;

@end
