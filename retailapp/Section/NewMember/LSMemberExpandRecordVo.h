//
//  LSMeberExpandRecordVo.h
//  retailapp
//
//  Created by taihangju on 2016/10/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

// 会员消费记录 vo
@interface LSMemberExpandRecordVo : NSObject

@property (nonatomic ,strong) NSString *orderId;        /*< 订单号>*/
@property (nonatomic ,strong) NSString *code;           /*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *orderKind;      /*<<#说明#>>*/
@property (nonatomic ,strong) NSString *swiftNo;        /*<流水号>*/
@property (nonatomic ,strong) NSNumber *cost;           /*<消费金额>*/
@property (nonatomic ,strong) NSString *customerName;   /*<会员名>*/
@property (nonatomic ,strong) NSString *mobile;         /*<手机号>*/
@property (nonatomic ,strong) NSString *outType;        /*<订单类型>*/
@property (nonatomic ,strong) NSNumber *createTime;     /*<long 交易时间>*/
@property (nonatomic ,strong) NSString *kindCardName;   /*<会员卡类型名称>*/
@property (nonatomic ,strong) NSString *cardCode;       /*<会员卡号>*/
@property (nonatomic ,strong) NSString *shopEntityId;   /*<消费门店>*/

@property (nonatomic ,strong) NSString *timeString;// 根据self.createTime 得到对应的"yyyy年MM月"

+ (NSArray *)getMemberExpandRecordList:(NSArray *)dicArr;
- (NSString *)expandTimeString; //获取完整的交易时间
@end
