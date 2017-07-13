//
//  MemberTransactionListVo.h
//  retailapp
//
//  Created by guozhi on 15/10/12.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberTransactionListVo : NSObject
//<<<<<<< HEAD
//=======
//@property (nonatomic, copy) NSString *customerName; //会员名
//@property (nonatomic, copy) NSString *mobile; //会员手机号
//@property (nonatomic, copy) NSString *orderId; //订单号
//@property (nonatomic, copy) NSString *outType; //订单类型 微信：weixin 实体店：entity
//@property (nonatomic, strong) NSNumber *createTime; //交易时间
//@property (nonatomic, strong) NSNumber *cost; //消费金额
/*
 * 1：销售单
 * 2：退货单
 */
//@property (nonatomic, strong) NSString *orderKind;
//>>>>>>> dev

@property (nonatomic, strong) NSString *customerName;   //会员名
@property (nonatomic, strong) NSString *mobile;         //会员手机号
@property (nonatomic, strong) NSString *orderId;        //订单号
@property (nonatomic ,strong) NSString *code;           /*<单号>*/
@property (nonatomic ,strong) NSString *swiftNo;        /*<流水号>*/
@property (nonatomic, strong) NSString *outType;        //订单类型 微信：weixin 实体店：entity
@property (nonatomic, strong) NSString *cardCode;       /*<会员卡号>*/
@property (nonatomic, strong) NSString *kindCardName;   /*<会员卡类型名称>*/
@property (nonatomic, strong) NSNumber *createTime;     //交易时间
@property (nonatomic, strong) NSNumber *cost;           //消费金额
@property (nonatomic ,strong) NSString *shopEntityId;   /*<店铺实体ID 会员服务化新加>*/
@property (nonatomic ,strong) NSNumber *orderKind;      /*<1.销售单  2.退货单>*/

+ (instancetype)memberTranscationVo:(NSDictionary *)keyValues;
+ (NSArray *)memberTranscationVoList:(NSArray *)keyVaulesArray;
@end
