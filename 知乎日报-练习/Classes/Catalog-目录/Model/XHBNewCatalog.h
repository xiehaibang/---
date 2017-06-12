//
//  XHBNewCatalog.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/4/8.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBNewCatalog : NSObject

/* 日报编号 */
@property (assign, nonatomic) NSInteger ID;

/* 日报名称 */
@property (strong, nonatomic) NSString *name;

/* 颜色 */
@property (assign, nonatomic) NSInteger color;

/* 日报描述 */
@property (strong, nonatomic, readonly) NSString *dailyDescription;

/* 缩略图 */
@property (strong, nonatomic) NSString *thumbnail;

@end
