//
//  LSMemberSaveDetailVo.m
//  retailapp
//
//  Created by taihangju on 2016/10/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberDetaileVo.h"
#import "MJExtension.h"

@implementation LSMemberDetaileVo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"sId":@"id",
             @"s_Id":@"_id"};
}

@end


@implementation LSMemberDegreeFlowVo

// 这里过滤掉了：赠分为0的数据，这种数据是由于后端数据迁移，老的数据产生，无效固不显示
+ (NSArray *)getDegreeFlowVoVoList:(NSArray *)keyValuesArray {
    
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:keyValuesArray.count];
    for (NSDictionary *record in keyValuesArray) {
        if (![[record valueForKey:@"num"] isEqual:@(0)]) {
            [models addObject:[self mj_objectWithKeyValues:record]];
        }
    }
    return [models copy];
}

- (NSString *)getActionStringWithTextColor:(UIColor * __autoreleasing *)color {
    
    
    NSString *str = nil;
    switch (self.action.integerValue) {
        case DegreeActionConsume:
        {
            str = @"消费：+";
            *color = [ColorHelper getRedColor];
        }
            break;
        case DegreeActionRedRush:
        {
            str = @"红冲：-";
            *color = [ColorHelper getGreenColor];
        }
            break;
        case DegreeActionGift:
        {
            str = @"赠分：+";
            *color = [ColorHelper getRedColor];
        }
            break;
        case DegreeActionExchange:
        {
            str = @"兑换：-";
            *color = [ColorHelper getGreenColor];
        }
            break;
        case DegreeActionBackRush:
        {
            str = @"回冲：-";
            *color = [ColorHelper getGreenColor];
        }
            break;
            
        default:
            break;
    }
    return str;
}


@end

@implementation LSMemberMoneyFlowVo

+ (NSArray *)getMoneyFlowVoList:(NSArray *)keyValuesArray {
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:keyValuesArray.count];
    [keyValuesArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *modelDic = [obj objectForKey:@"moneyFlowVo"];
        LSMemberMoneyFlowVo *vo = [self mj_objectWithKeyValues:modelDic];
        if ([NSString isNotBlank:[obj valueForKey:@"payModeStr"]]) {
            vo.payModeStr = [obj valueForKey:@"payModeStr"];
        }
        [array addObject:vo];
    }];
    
    
    return [array copy];
}

- (NSString *)getPayModeString {
    
    if (self.opType.integerValue == 1) {
        
        if (self.payMode.integerValue == 1) {
            return @"支付方式：现金";
        }
        else if (self.payMode.integerValue == 2) {
            return @"支付方式：银行卡";
        }
        else if (self.payMode.integerValue == 3) {
            return @"支付方式：第三方支付";
        }
        else if (self.payMode.integerValue == 4) {
            return @"支付方式：赠送";
        }
        else {
            return @"支付方式：其他";
        }
    }
    else if (self.opType.integerValue == 2) {
        
        if (self.payMode.integerValue == 6) {
            return @"支付方式：微信";
        }
        else if (self.payMode.integerValue == 7) {
            return @"支付方式：支付宝";
        }
    }
    return @"支付方式：";
}

- (NSString *)getActionStringWithTextColor:(UIColor * __autoreleasing *)color {
    
    NSString *str = nil;
    switch (self.action.integerValue) {
        case MoneyActionRecharge:
        {
            str = @"充值：+￥";
            *color = [ColorHelper getRedColor];
        }
            break;
        case MoneyActionConsume:
        {
            str = @"消费：-￥";
            *color = [ColorHelper getGreenColor];
        }
            break;
        case MoneyActionRedRush:
        {
            str = @"红冲：-￥";
            *color = [ColorHelper getGreenColor];
        }
            break;
        case MoneyActionBackRush:
        {
            str = @"回冲：+￥";
            *color = [ColorHelper getRedColor];
        }
            break;
        case MoneyActionGoodsReturn:
        {
            str = @"回冲：+￥";
            *color = [ColorHelper getRedColor];
        }
            break;
        default:
            break;
    }
    return str;
}

@end
