//
//  DealSellReturnData.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//处理退货单用
@interface DealSellReturnData : NSObject

//code		 退货单号		String
//opType		操作类型		Short
//shopId		店铺id		String
//returnTypeId		退货类型		String
@property (nonatomic, copy) NSString *returnTypeId;

//returnAmount		实际退款金额		BigDecimal
@property (nonatomic, strong) NSNumber *returnAmount;

//returnReason		退货理由		String
@property (nonatomic, copy) NSString *returnReason;

//refuseReason		拒绝原因		String
@property (nonatomic, copy) NSString *refuseReason;

//lastVer		版本号		Long
//linkman		联系人		String
@property (nonatomic, copy) NSString *linkman;

//phone		联系电话		String
@property (nonatomic, copy) NSString *phone;

//address		退货地址		String
@property (nonatomic, copy) NSString *address;

//provinceId		省份id		String
@property (nonatomic, copy) NSString *provinceId;

//cityId		城市id		String
@property (nonatomic, copy) NSString *cityId;

//countyId		区县id		String
@property (nonatomic, copy) NSString *countyId;

//zipCode		邮编		String
@property (nonatomic, copy) NSString *zipCode;


@end
