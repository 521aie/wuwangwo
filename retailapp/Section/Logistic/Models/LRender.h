//
//  LRender.h
//  retailapp
//
//  Created by hm on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRender : NSObject
+(NSMutableArray *)listCondition;
+(NSMutableArray *)listOrderStatus;
+(NSMutableArray *)listClientOrderStatus;
+(NSMutableArray *)listStockInStatus;
+(NSMutableArray *)listReturnStatus;
+(NSMutableArray *)listClientReturnStatus;
+(NSMutableArray *)listAllocateStatus;
+(NSMutableArray *)listPackBoxStatus;
+(NSMutableArray *)listPaperType;
+(NSMutableArray *)listDate;
+(NSMutableArray *)listSupplierType;
@end
