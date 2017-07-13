//
//  UserHandoverVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHandoverVo : NSObject
/**交接班ID*/
@property (nonatomic, strong) NSString *userHandoverId;
/**开始时间*/
@property (nonatomic, assign) NSInteger startWorkTime;
/**结束时间*/
@property (nonatomic, assign) NSInteger endWorkTime;
/**收银单数*/
@property (nonatomic, assign) NSInteger orderNumber;
/**卖出商品数*/
@property (nonatomic, strong) NSString *saleGoodsNumber;
/**销售总额*/
@property (nonatomic, strong) NSString *resultAmount;
/**实收总额*/
@property (nonatomic, strong) NSString *discountAmount;
/**充值金额*/
@property (nonatomic, strong) NSString *chargeAmount;
/**赠送金额*/
@property (nonatomic, strong) NSString *presentAmount;
/**退单数*/
@property (nonatomic, assign) NSInteger returnOrderNumber;
/**提成*/
@property (nonatomic, strong) NSString *royalties;
/**退单金额*/
@property (nonatomic, strong) NSString *returnAmount;
/**收银金额*/
@property (nonatomic, strong) NSString *cashierAmount;


+ (UserHandoverVo*)convertToUser:(NSDictionary*)dic;

- (NSMutableDictionary *)getDic:(UserHandoverVo *)userHandoverVo;

@end
