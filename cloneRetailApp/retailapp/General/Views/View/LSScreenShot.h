//
//  LSScreenShot.h
//  retailapp
//
//  Created by guozhi on 16/8/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

/**
 *  实现截屏功能保存到本地
 */
#import <Foundation/Foundation.h>

@interface LSScreenShot : NSObject
/**
 *  保存某个画面到相册
 *
 */
+ (UIImage *)screenShot:(UIView *)view;
@end
