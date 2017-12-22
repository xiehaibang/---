//
//  XHBNewsContent.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/5/19.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBNewsContent : NSObject

/** HTML 字符串 */
@property (nonatomic, strong) NSString *body;

/** 图片版权信息 */
@property (nonatomic, strong) NSString *image_source;

/** 新闻标题 */
@property (nonatomic, strong) NSString *title;

/** 图片地址 */
@property (nonatomic, strong) NSString *image;

/** 分享链接 */
@property (nonatomic, strong) NSString *share_url;

/** JS */
@property (nonatomic, strong) NSString *js;

/** 新闻的类型 */
@property (nonatomic, assign) NSInteger type;

/** 新闻 ID */
@property (nonatomic, assign) NSInteger ID;

/** CSS */
@property (nonatomic, strong) NSArray *css;

@end
