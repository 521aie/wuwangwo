//
//  MicroGoodsImageVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "IImageData.h"

@interface MicroGoodsImageVo : NSObject <IImageData>

/**
 * <code>图片</code>.
 */
@property (nonatomic, strong) NSString *fileName;

/**
 * <code>文件</code>.
 */
@property (nonatomic, strong) NSString *file;

/**
 * <code>路径</code>.
 */
@property (nonatomic, strong) NSString *filePath;

/**
 * <code>颜色</code>.
 */
@property (nonatomic, strong) NSString *color;


/**
 * <code>颜色id</code>.
 */
@property (nonatomic, strong) NSString *colorId;


@property (nonatomic,strong) NSString *homePageId;
/**
 * byte 上传1 删除 2
 */
@property (nonatomic,assign) Byte opType;

+(MicroGoodsImageVo*)convertToMicroGoodsImageVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(MicroGoodsImageVo *)microGoodsImageVo;

@end
