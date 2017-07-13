//
//  OpOrderShopWare.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpOrderShopWare : NSObject

//订单处理机构表id
@property (nonatomic, copy) NSString *opOrderShopId;

//门店、机构编码
@property (nonatomic, copy) NSString *code;

//供货价
@property (nonatomic) double supplyPrice;

//库存数
@property (nonatomic) id number;

//门店还是仓库
@property (nonatomic) short shopType;

//名称
@property (nonatomic, copy) NSString *name;
/**虚拟库存的状态 1 开启  0 未开启*/
@property (nonatomic, copy) NSString *virtualStoreStatus;

@end
