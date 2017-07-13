//
//  MicroStyleImageVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "IImageData.h"

@interface MicroStyleImageVo : Jastor<IImageData>

/**
 * <code>文件名</code>.
 */
@property (nonatomic, strong) NSString *fileName;

/**
 * <code>文件</code>.
 */
@property (nonatomic, strong) NSString *file;

/**
 * <code>颜色</code>.
 */
@property (nonatomic, strong) NSString *color;

/**
 * <code>图片的服务器路径</code>.
 */
@property (nonatomic, strong) NSString *filePath;

+(MicroStyleImageVo*)convertToMicroStyleImageVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(MicroStyleImageVo *)microStyleImageVo;

@end
