//
//  MarketRender.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketRender : NSObject

//特价管理
+(NSMutableArray*) listSaleScheme;

+(NSString*) obtainSaleScheme:(short)saleSchemeId;

+(NSMutableArray*) listShopPriceScheme;

+(NSString*) obtainShopPriceScheme:(short)shopPriceScheme;

//会员生日促销
+(NSMutableArray*) listBirShopPriceScheme:(BOOL) isShow;

+(NSString*) obtainBirShopPriceScheme:(short)shopPriceScheme isShow:(BOOL) isShow;

+(NSMutableArray*) listBirDate;

//促销活动编辑
+(NSMutableArray*) listWeixinPriceScheme;

+(NSString*) obtainWeixinPriceScheme:(short)weixinPriceScheme;

//N件打折编辑
+(NSMutableArray*) listGroupType;

+(NSString*) obtainGroupType:(short)groupTyp;

//活动适用范围
+(NSMutableArray*) listUsedArea;
@end
