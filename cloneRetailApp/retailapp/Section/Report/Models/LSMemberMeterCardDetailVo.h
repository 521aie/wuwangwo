//
//  LSMemberMeterCardDetailVo.h
//  retailapp
//
//  Created by wuwangwo on 2017/4/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSMemberMeterCardDetailVo : NSObject
@property (nonatomic, copy) NSString *memberName; //会员名
@property (nonatomic ,copy) NSString *memberNo;//会员卡号
@property (nonatomic, copy) NSString *memberType; //	会员卡类型
@property (nonatomic ,copy) NSString *accountCardName;//计次服务名称
@property (nonatomic ,strong) NSNumber *accountCardId;//	计次卡ID
@property (nonatomic, strong) NSNumber *createTime; //充值时间
@property (nonatomic, strong) NSNumber *endDate; //	有效期结束时间
@property (nonatomic, strong) NSNumber *startDate; //有效期开始时间
@property (nonatomic, strong) NSNumber *opTime; //操作时间
@property (nonatomic, copy) NSString *opUserName; //操作人
@property (nonatomic, copy) NSString *opUserNo; //操作人工号
@property (nonatomic, strong) NSNumber *action; //操作类型（1充值,2支付,3退卡）
@property (nonatomic, strong) NSNumber *payMode; //支付方式(微信，支付宝，QQ钱包)
@property (nonatomic, copy) NSString *payModeName; //支付方式(微信，支付宝，QQ钱包)
@property (nonatomic, copy) NSString *phoneNo; //手机号
@property (nonatomic, strong) NSNumber *pay; //售价
@end
