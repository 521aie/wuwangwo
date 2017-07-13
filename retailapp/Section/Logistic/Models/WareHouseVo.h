//
//  WareHouseVo.h
//  retailapp
//
//  Created by hm on 15/10/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameCode.h"
#import "IMultiNameValueItem.h"
@interface WareHouseVo : NSObject<INameCode,IMultiNameValueItem>
@property (nonatomic,copy) NSString* wareHouseId;
@property (nonatomic,copy) NSString* wareHouseName;
@property (nonatomic,copy) NSString* wareHouseCode;
@property (nonatomic,assign) short type;
/**机构id*/
@property (nonatomic,copy) NSString* orgId;
/**机构名称*/
@property (nonatomic,copy) NSString* orgName;
/**所在省份id*/
@property (nonatomic,copy) NSString* provinceId;
/**所在城市id*/
@property (nonatomic,copy) NSString* cityId;
/**所在区县id*/
@property (nonatomic,copy) NSString* countryId;
/**详细地址*/
@property (nonatomic,copy) NSString* address;
/**联系人*/
@property (nonatomic,copy) NSString* linkMan;
/**手机号*/
@property (nonatomic,copy) NSString* mobile;
/**座机*/
@property (nonatomic,copy) NSString* phone;
/**版本*/
@property (nonatomic,assign) NSInteger lastVer;
/**供应商编号*/
//@property (nonatomic,copy) NSString* supplyCode;
/**供应商类别名*/
//@property (nonatomic,copy) NSString* supplyTypeName;
/**供应商类别编号*/
//@property (nonatomic,copy) NSString* supplyTypeVal;
/**1 添加为供应商*/
//@property (nonatomic,assign) short supplyFlg;
/**1 添加为供应商*/
//@property (nonatomic,assign) short isAppointSupply;
/**add 添加 del 删除*/
@property (nonatomic,copy) NSString* operateType;
+ (WareHouseVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

+ (NSMutableDictionary *)converToDic:(WareHouseVo *)wareHouseVo;
+ (NSMutableArray *)converObjArrToDicArr:(NSMutableArray *)sourceList;

@property (nonatomic,assign) BOOL checkVal;

@end
