//
//  LSPictureAdvertisingVo.h
//  retailapp
//
//  Created by guozhi on 2016/11/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IImageData.h"
@interface LSPictureAdvertisingVo : NSObject<IImageData>
/** 图片下载地址 */
@property (nonatomic, copy) NSString *downloadUrl;
/** 图片路径 */
@property (nonatomic, copy) NSString *path;
/** <#注释#> */
@property (nonatomic, copy) NSString *id;
/** 数据是否改变 */
@property (nonatomic, assign) BOOL isChange;
/** 是否显示上传图片失败 */
@property (nonatomic, assign) BOOL isShowFailImage;
@end
