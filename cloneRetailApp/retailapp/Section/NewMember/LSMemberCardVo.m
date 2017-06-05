//
//  LSMemberCardVo.m
//  retailapp
//
//  Created by taihangju on 16/9/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardVo.h"
#import "FormatUtil.h"
#import "MyMD5.h"

@implementation LSMemberCardVo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"sId":@"id",
             @"s_Id":@"_id"};
}

+ (LSMemberCardVo *)getMemberCardVo:(NSDictionary *)dic {
    
    return [self mj_objectWithKeyValues:dic];
}

+ (NSArray *)getMemberCardVoList:(NSArray *)array {
    
    return [[self mj_objectArrayWithKeyValuesArray:array] copy];
}

- (NSString *)getModeStringShowRatio {
   
    if(self.mode.intValue == CardPrimeMember) {
        return @"会员价";
    }
    else if(self.mode.intValue ==  CardPrimeRaw) {
        return @"批发价";
    }
    else if(self.mode.intValue == CardPrimeDiscount) {
    
        if (self.ratio.intValue == 100) {
            return @"100%";
        }
        else if (self.ratio) {
            NSString *ratioStr = [FormatUtil formatDouble4:self.ratio.longLongValue];
            return [NSString stringWithFormat:@"%@%@",ratioStr,@"%"];
        }
        return @"0.0%";
    }
    else
    {
        return @"无";
    }

}

// mode 零售这边不会有为2的情况，餐饮那边使用
- (NSString *)getPrimeTypeName {
    
    if(self.mode.intValue == CardPrimeMember) {
        return @"使用会员价";
    }
    else if(self.mode.intValue ==  CardPrimeRaw) {
        return @"使用批发价";
    }
    else if(self.mode.intValue == CardPrimeDiscount) {
        
        return @"按固定折扣";
    }
    else
    {
        return @"无";
    }
}

- (BOOL)isLost {
    return (self.status.integerValue == 2);
}

/**
 *  status == 0   未使用
 *  status == 1   正常
 *  status == 2   挂失
 *  status == 3   注销
 *  status == 4   换卡
 *  status == 5   待审核
 */
- (NSString *)getCardStatusString {
    
    switch (self.status.intValue) {
        case 0:
            return @"未使用";
            break;
        case 1:
            return @"正常";
            break;
        case 2:
            return @"挂失";
            break;
        case 3:
            return @"注销";
            break;
        case 4:
            return @"换卡";
            break;
        case 5:
            return @"待审核";
            break;
        default:
            break;
    }
    return @"";
}

// INameItem 协议方法
-(NSString *)obtainItemId {
    return self.sId;
}

-(NSString *)obtainItemName {
    return self.upKindCardName;
}

-(NSString *)obtainOrignName {
    return self.upKindCardName;
}

@end


@implementation LSMemberCardPwdVo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.passward = @"";
        self.surePassward = @"";
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    if ([NSString isNotBlank:self.passward]) {
//        [dictionary setValue:[MyMD5 md5:self.passward] forKey:@"password"];
//    }
//    else {
//        [dictionary setValue:@"" forKey:@"password"];
//    }
//    [dictionary setValue:self.cardId forKey:@"cardId"];
    [dictionary setValue:[MyMD5 md5:self.passward] forKey:@"customKey"];
    [dictionary setValue:self.cardId forKey:@"id"];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}
@end

//@implementation LSMemberRetreatCardVo
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.realPay = @"0.00";
//        self.memo = @"";
//    }
//    return self;
//}
//
//- (NSDictionary *)dictionary
//{
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    [dictionary setValue:self.cardId forKey:@"cardId"];
//    [dictionary setValue:self.userId forKey:@"userId"];
//    [dictionary setValue:self.realPay forKey:@"realPay"];
//    [dictionary setValue:self.memo forKey:@"memo"];
//    return [NSDictionary dictionaryWithDictionary:dictionary];
//}
//@end


@implementation LSMemberRechargeVo

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.presentIntegral = @(0);
        self.presentMoney = @(0.0);
        self.payTyp = @(1); // 默认是现金支付
    }
    return self;
}

+ (NSArray *)getPayTypeItems {
    
    return @[[[NameItemVO alloc] initWithVal:@"现金" andId:@"1"],
             [[NameItemVO alloc] initWithVal:@"银行卡" andId:@"2"],
             [[NameItemVO alloc] initWithVal:@"第三方支付" andId:@"3"],
             [[NameItemVO alloc] initWithVal:@"赠送" andId:@"4"],
             [[NameItemVO alloc] initWithVal:@"其他" andId:@"5"]];
}


@end
