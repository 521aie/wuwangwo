//
//  SupplyVo.h
//  retailapp
//
//  Created by hm on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValue.h"

@interface SupplyVo : NSObject<INameValue>
//供应商id
@property (nonatomic,copy) NSString* supplyId;
//供应商名称
@property (nonatomic,copy) NSString* supplyName;
//编号
@property (nonatomic,copy) NSString* code;
//简称
@property (nonatomic,copy) NSString* shortName;
//联系人
@property (nonatomic,copy) NSString* relation;
//联系电话
@property (nonatomic,copy) NSString* phone;
//手机号码
@property (nonatomic,copy) NSString* mobile;
/**第三方供应商标识 0是 1否*/
@property (nonatomic,assign) short wareHouseFlg;

+ (SupplyVo*)converToVo:(NSDictionary*)dic;

+ (NSMutableArray*)converToArr:(NSArray*)sourceList;
@end
