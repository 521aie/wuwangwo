//
//  PurchaseSupplyVo.h
//  retailapp
//
//  Created by hm on 16/1/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameCode.h"
@interface PurchaseSupplyVo : NSObject<INameCode>
// 关联关系Id
@property (nonatomic,copy) NSString *purchaseSupplyId;
// 实体Id
@property (nonatomic,copy) NSString *entityId;
// 采购机构/门店ID
@property (nonatomic,copy) NSString *purchaseOrgId;
// 供应商机构ID
@property (nonatomic,copy) NSString *supplyOrgId;
// 是否有效
@property (nonatomic,copy) NSString *isValid;
// 操作类型 add 添加 del 删除
@property (nonatomic,copy) NSString *operateType;
// 供应商名称
@property (nonatomic,copy) NSString *supplyName;
// 供应商code
@property (nonatomic,copy) NSString *supplyCode;
// 联系人
@property (nonatomic,copy) NSString *linkMan;
// phone
@property (nonatomic,copy) NSString *phone;

@property (nonatomic,assign) BOOL checkVal;

- (instancetype)initWithDictionary:(NSDictionary *)json;
+ (NSMutableArray *)converToArr:(NSArray *)arr;
+ (NSMutableArray *)converToDicArr:(NSMutableArray *)arr;
+ (NSMutableDictionary *)converVoToDic:(PurchaseSupplyVo*)vo;
@end
