//
//  XHBThemeDaily.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/5/30.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBThemeDaily : NSObject

/** 图形地址 */
@property (nonatomic, strong) NSArray *images;

/** 消息的标题 */
@property (nonatomic, strong) NSString *title;

/** 主题日报的介绍 */
@property (nonatomic, strong) NSString *theme_description;

/** 主题日报的背景图片 */
@property (nonatomic, strong) NSString *background;

/** 主题日报的名称 */
@property (nonatomic, strong) NSString *name;

/** 背景图片的小图版本 */
@property (nonatomic, strong) NSString *image;

/** 图像的版权信息 */
@property (nonatomic, strong) NSString *image_source;

@end
