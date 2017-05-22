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
@property (strong, nonatomic) NSString *body;

/** 图片版权信息 */
@property (strong, nonatomic) NSString *image_source;

/** 新闻标题 */
@property (strong, nonatomic) NSString *title;

/** 图片地址 */
@property (strong, nonatomic) NSString *image;

/** 分享链接 */
@property (strong, nonatomic) NSString *share_url;

/** 新闻的类型 */
@property (assign, nonatomic) NSInteger type;

/** 新闻 ID */
@property (assign, nonatomic) NSInteger ID;

/** CSS */
@property (strong, nonatomic) NSArray *css;

@end
