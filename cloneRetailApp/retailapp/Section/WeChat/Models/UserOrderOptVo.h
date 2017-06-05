//
//  UserOrderOptVo.h
//  retailapp
//
//  Created by diwangxie on 16/3/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface UserOrderOptVo : Jastor

//角色Id
@property (nonatomic, copy) NSString *roleId;
//用户Id
@property (nonatomic, copy) NSString *userId;
//订单Id
@property (nonatomic, copy) NSString *orderId;
//订单code
@property (nonatomic, copy) NSString *code;
//订单类型
@property (nonatomic) short orderType;

+(NSDictionary*)getDictionaryData:(UserOrderOptVo *)userOrderOptVo;

@end
