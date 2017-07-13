//
//  MemberBirSaleVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface MemberBirSaleVo : Jastor

/**会员生日促销ID*/
@property (nonatomic,copy) NSString* meBirSaleId;

/**价格方案*/
@property (nonatomic) short priceScheme;

/**促销状态*/
@property (nonatomic) short status;

/**折扣率*/
@property (nonatomic) double rate;

/**限购数量*/
@property (nonatomic) NSInteger goodsCount;

/**限购次数*/
@property (nonatomic) NSInteger purchaseNumber;

/**有效期设置*/
@property (nonatomic) short validityType;

/**会员生日前天数*/
@property (nonatomic) NSInteger birthdayBeforeDays;

/**会员生日后天数*/
@property (nonatomic) NSInteger birthdayAfterDays;

/**版本号*/
@property (nonatomic) NSInteger lastVer;

+(MemberBirSaleVo*)convertToMemberBirSaleVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(MemberBirSaleVo *)memberBirSaleVo;

@end
