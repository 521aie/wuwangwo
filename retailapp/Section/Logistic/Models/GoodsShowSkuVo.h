//
//  GoodsShowSkuVo.h
//  retailapp
//
//  Created by hm on 15/10/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsShowSkuVo : NSObject
@property (nonatomic,copy) NSString* goodsName;
@property (nonatomic,copy) NSString* styleCode;
@property (nonatomic,assign) double hangTagPrice;
@property (nonatomic,copy) NSString* filePath;
@property (nonatomic,strong) NSMutableArray* colors;
@property (nonatomic,strong) NSMutableArray* sizes;
@end
