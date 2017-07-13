//
//  LSSmsPackageVo.h
//  retailapp
//
//  Created by guozhi on 16/9/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSmsPackageVo : NSObject
/**
 *  套餐id
 */
@property (nonatomic, assign) int id;
/**
 *  套餐名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  套餐价格 BigDecima
 */
@property (nonatomic, assign) double price;
/**
 *  套餐短信数量
 */
@property (nonatomic, assign) int num;
/**
 *  备注
 */
@property (nonatomic, copy) NSString *memo;
/**
 *  是否选中
 */
@property (nonatomic,assign) BOOL isSelect;

@end
