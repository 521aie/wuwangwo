//
//  MallTransactionListVo.h
//  retailapp
//
//  Created by guozhi on 16/1/26.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MallTransactionListVo : NSObject
/**会员名   String*/
@property (nonatomic, copy) NSString *name;
/**会员卡ID String*/
@property (nonatomic, copy) NSString *cardId;
/**会员手机号  String*/
@property (nonatomic, copy) NSString *mobile;
/**会员卡号  String*/
@property (nonatomic, copy) NSString *code;
/**消费总额 BigDecimal*/
@property (nonatomic, strong) NSNumber *costAmount;
/**交易次数Integer*/
@property (nonatomic, strong) NSNumber *tradingNum;
- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
