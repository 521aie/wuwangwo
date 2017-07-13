//
//  MemberTypeRender.h
//  RestApp
//
//  Created by zhangzhiliang on 15/6/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MemberTypeVo.h"

@interface MemberRender : NSObject

+(NSMutableArray*) listType;

+(NSString*) obtainPriceScheme:(NSInteger)priceSchemeId;

//会员主页筛选
//+(NSMutableArray*) listKindCardName:(NSMutableArray*) kindCardNameList;

+(NSMutableArray*) listActiveTime;

+(NSMutableArray*) listCardStatus;

+(NSMutableArray*) listActiveWay;

//+(NSString*) obtainKindCard:(NSString*)kindCardName kindCardList:(NSMutableArray*) kindCardList;

+(NSMutableArray*) listBirthdayTime;

//+(NSString*) obtainKindCardName:(NSString*)kindCardId kindCardList:(NSMutableArray*) kindCardList;

+(NSString*) obtainCardStatus:(NSString*)kindCardStatus;

+(NSString*) obtainActiveTime:(NSString*)activeTime;

+(NSString*) obtainActiveWay:(NSString*)activeWay;

//会员信息编辑
+(NSMutableArray*) listSex;

+(NSString*) obtainSex:(int)sex;

//+(NSMutableArray*) listKindCardName2:(NSMutableArray*) kindCardNameList;

+(NSMutableArray*) listCardStatus2;

//会员充值编辑
+(NSMutableArray*) listPayMode:(NSMutableArray*) salePayModeList;

+(NSMutableArray*) listSaleRecharge:(NSMutableArray*) saleRechargeList;

//会员红冲
+(NSMutableArray*) listRechargeType;

+(NSString*) obtainRechargeType:(NSString*)rechargeType;

+(NSString*) obtainPayMode:(NSString*)payMode salePayModeList:(NSMutableArray*) salePayModeList;

@end
