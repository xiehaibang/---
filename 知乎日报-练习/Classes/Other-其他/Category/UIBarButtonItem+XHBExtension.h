//
//  UIBarButtonItem+XHBExtension.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/3/12.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XHBExtension)

+ (instancetype) initWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;

+ (instancetype) initWithImageName:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action;

@end
