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
@property (nonatomic, assign) NSInteger ID;

/* 日报名称 */
@property (nonatomic, strong) NSString *name;

/* 颜色 */
@property (nonatomic, assign) NSInteger color;

/* 日报描述 */
@property (nonatomic, readonly, strong) NSString *dailyDescription;

/* 缩略图 */
@property (nonatomic, strong) NSString *thumbnail;

@end
