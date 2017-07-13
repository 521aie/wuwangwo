//
//  PackGoodsVo.h
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMultiNameValueItem.h"
@interface PackGoodsVo : NSObject<IMultiNameValueItem>

/**装箱单id*/
@property (nonatomic, copy) NSString *packGoodsId;
/**装箱单号*/
@property (nonatomic, copy) NSString *packCode;
/**箱号*/
@property (nonatomic, copy) NSString *boxCode;
/**状态*/
@property (nonatomic, assign) short billStatus;
/**状态名称*/
@property (nonatomic, copy) NSString *billStatusName;
/**装箱时间戳*/
@property (nonatomic,assign) long long packTimeL;
/**装箱时间yy-mm-dd（打印）*/
@property (nonatomic, copy) NSString *packTime;
/**门店/仓库编码（打印）*/
@property (nonatomic, copy) NSString *shopCode;
/**门店/仓库名称（打印）*/
@property (nonatomic, copy) NSString *shopName;
/**商品一览（打印）*/
@property (nonatomic, strong) NSMutableArray *goodsList;

@property (nonatomic, assign) BOOL checkVal;
+ (PackGoodsVo *)converToVo:(NSDictionary*)dic;
+ (NSMutableArray *)converToArr:(NSMutableArray*)sourceList;

@end
