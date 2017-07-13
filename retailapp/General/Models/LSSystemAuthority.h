//
//  LSSystemAuthority.h
//  retailapp
//
//  Created by guozhi on 2016/11/14.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSystemAuthority : NSObject
#pragma mark - 相册权限
+ (BOOL)isCanUsePhotos;
#pragma mark - 相机权限
+ (BOOL)isCanUseCamera;
@end
