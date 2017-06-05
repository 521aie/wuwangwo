//
//  MoneyFlowVo.h
//  retailapp
//
//  Created by diwangxie on 16/5/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 账户收支明细流水vo
 * @author diwangxie
 *
 */
@interface MoneyFlowVo : NSObject


//订单id
@property (nonatomic,copy) NSString *orderid;
//返利单号（订单类和退款用）
@property (nonatomic,copy) NSString *id;
//订单类（1，3） 提现（5） 退款（6）
@property (nonatomic) short action;

//状态 订单状态、退款状态和提现状态
@property (nonatomic) short status;

//金额
@property (nonatomic) double fee;

//订单单号（订单类和退款用）
@property (nonatomic,copy) NSString *orderCode;

//时间  申请时间 下单时间
@property (nonatomic) long long createTime;

//申请人 (退款和提现用)
@property (nonatomic,copy) NSString *customerName;

/*
 *订单类专用
 */

//订单来源
@property (nonatomic,copy) NSString *outType;
//佣金比例
@property (nonatomic) double rebateRate;


/*
 *退款专用
 */
//退款人手机号
@property (nonatomic,copy) NSString *customerMobile;
//退款成功时间
@property (nonatomic)  long long opTime;


/*
 *提现专用
 */

//提现方式编号，数据库可能是存了提现方式code
@property (nonatomic,copy) NSString * withDrawType;

//开户行
@property (nonatomic,copy) NSString* bankName;

//银行卡号
@property (nonatomic,copy) NSString* accountNumber;



+(MoneyFlowVo *)convertToMoneyFlowVo:(NSDictionary*)dic;

+(NSDictionary*)getDictionaryData:(MoneyFlowVo *)moneyFlowVo;

@end
