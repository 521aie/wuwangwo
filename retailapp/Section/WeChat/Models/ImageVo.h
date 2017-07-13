//
//  ImageVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "IImageData.h"

@interface ImageVo : Jastor<IImageData>

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
 * <code>证件图片正反面区分</code>.
 */
@property (nonatomic) short frontBack;

@property (nonatomic) BOOL isChanged;

+ (ImageVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
