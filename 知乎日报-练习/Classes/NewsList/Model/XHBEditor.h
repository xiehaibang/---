//
//  XHBEditor.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/5/30.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHBEditor : NSObject

/** 主编的知乎用户主页 */
@property (strong, nonatomic) NSString *url;

/** 主编的个人简介 */
@property (strong, nonatomic) NSString *bio;

/** 数据库中的唯一标识符 */
@property (assign, nonatomic) NSInteger editor_id;

/** 主编的头像 */
@property (strong, nonatomic) NSString *avatar;

/** 主编的姓名 */
@property (strong, nonatomic) NSString *name;

@end
