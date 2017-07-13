//
//  LSImageDataVo.h
//  retailapp
//
//  Created by guozhi on 16/8/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSImageDataVo : NSObject
/**
 *  上传图片数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  上传图片路径
 */
@property (nonatomic, copy) NSString *file;
+ (instancetype)imageDataVoWithData:(NSData *)data file:(NSString *)file;
@end
