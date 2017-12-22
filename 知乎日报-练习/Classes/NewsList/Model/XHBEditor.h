//
//  XHBEditor.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/5/30.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBEditor : NSObject

/** 数据库中的唯一标识符 */
@property (nonatomic, assign) NSInteger editor_id;

/** 主编的知乎用户主页 */
@property (nonatomic, strong) NSString *url;

/** 主编的个人简介 */
@property (nonatomic, strong) NSString *bio;

/** 主编的头像 */
@property (nonatomic, strong) NSString *avatar;

/** 主编的姓名 */
@property (nonatomic, strong) NSString *name;

@end
