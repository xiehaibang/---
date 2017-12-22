//
//  XHBThemeStories.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/6/12.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBThemeStories : NSObject

/** 新闻标题 */
@property (nonatomic, strong) NSString *title;

/** 图片地址数组(官方 API 使用数组形式。目前暂未有使用多张图片的情形出现，有无 images 属性的情况，请在使用中注意) */
@property (nonatomic, strong) NSArray *images;

/** 类型，作用未知 */
@property (nonatomic, assign) NSInteger type;

/** 新闻ID */
@property (nonatomic, assign) NSInteger ID;

@end
