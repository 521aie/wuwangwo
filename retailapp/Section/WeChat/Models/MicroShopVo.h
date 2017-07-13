//
//  MicroShopVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/10/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface MicroShopVo : Jastor

@property (nonatomic, strong) NSString *address;

@property (nonatomic) int applyStatus;

@property (nonatomic, strong) NSString *contact;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *entityCode;

@property (nonatomic, strong) NSString *entityId;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *introduce;

@property (nonatomic) int isFreeSend;

@property (nonatomic) int isSelfPickUp;

@property (nonatomic, strong) NSString *lat;

@property (nonatomic, strong) NSString *lng;

@property (nonatomic, strong) NSString *memberCardId;

@property (nonatomic, strong) NSString *memo;

@property (nonatomic, strong) NSString *microMallId;

@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, strong) NSString *publicNo;

@property (nonatomic, strong) NSString *qq;

@property (nonatomic, strong) NSString *relevanceEntityId;

@property (nonatomic) double sendCost;

@property (nonatomic, strong) NSString *sendRange;

@property (nonatomic) long sendStrategy;

@property (nonatomic, strong) NSString *sendTime;

@property (nonatomic, strong) NSString *shopCode;

@property (nonatomic, strong) NSString *shopName;

@property (nonatomic, strong) NSString *sortCode;

@property (nonatomic, strong) NSString *tel;

@property (nonatomic, strong) NSString *weixin;

@property (nonatomic, strong) NSString *logo;
/** shortUrl */
@property (nonatomic, copy) NSString *shortUrl;
@end
