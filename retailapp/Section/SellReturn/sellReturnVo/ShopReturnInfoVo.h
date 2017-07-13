//
//  ShopReturnInfoVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopReturnInfoVo : NSObject

//实体id
@property (nonatomic, copy) NSString *entityId;

//店铺id
@property (nonatomic, copy) NSString *shopId;

//联系人
@property (nonatomic, copy) NSString *linkMan;

//联系电话
@property (nonatomic, copy) NSString *phone;

//退货地址
@property (nonatomic, copy) NSString *address;

//省份id
@property (nonatomic, copy) NSString *provinceid;

//城市id
@property (nonatomic, copy) NSString *cityid;

//区县id
@property (nonatomic, copy) NSString *countyid;

//邮编
@property (nonatomic, copy) NSString *zipcode;

//版本号
@property (nonatomic) NSInteger lastVer;

+ (ShopReturnInfoVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
