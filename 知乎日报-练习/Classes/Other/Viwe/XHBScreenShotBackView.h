//
//  XHBScreenShotBackView.h
//  知乎日报-练习
//
//  Created by 谢海邦 on 2017/7/15.
//  Copyright © 2017年 谢海邦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBScreenShotBackView : UIView

/** 屏幕快照的图片 */
@property (nonatomic, strong) UIImageView *imageView;

/** 遮罩视图 */
@property (nonatomic, strong) UIView *maskView;
@end
