//
//  LSMemberMeterCardListVo.h
//  retailapp
//
//  Created by wuwangwo on 2017/4/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSMemberMeterCardListVo : NSObject

@property (nonatomic ,copy) NSString *accountCardId;//	计次卡ID
@property (nonatomic ,copy) NSString *accountCardName;//计次服务名称
@property (nonatomic, strong) NSNumber *createTime; //充值时间
@property (nonatomic ,copy) NSString *memberNo;//会员卡号
@property (nonatomic, copy) NSString *memberName; //会员名
@property (nonatomic, strong) NSNumber *pay; //售价
@property (nonatomic, copy) NSString *operType; //操作类型（充值、退款）
@property (nonatomic, strong) NSNumber *consumeDate; //时间段标记
@property (nonatomic ,copy) NSString *id;//	充值ID
@property (nonatomic, strong) NSNumber *action; //操作类型（1充值,2支付,3退卡）

+ (instancetype)byTimeRechargeRecordVo:(NSDictionary *)jsonDic;
+ (NSArray *)byTimeRechargeRecordVoList:(NSArray *)keyValuesArray;
@end
