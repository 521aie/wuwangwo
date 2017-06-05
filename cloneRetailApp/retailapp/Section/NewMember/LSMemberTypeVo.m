//
//  LSMemberTypeVo.m
//  retailapp
//
//  Created by byAlex on 16/9/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberTypeVo.h"
#import "MJExtension.h"
#import "FormatUtil.h"
#import "NSNumber+Extension.h"

@implementation LSMemberTypeVo

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.mode = CardPrimeDiscount; // 默认使用折扣率
        self.ratio = @100; // 默认折扣率
        self.isRatioFeeDegree = 1;
        self.isPreFeeDegree = 1; // 默认开启
    }
    return self;
}

+ (NSArray *)getMemberTypeVos:(NSArray *)dicArray {
    
    return [[self mj_objectArrayWithKeyValuesArray:dicArray] copy];
}

+ (LSMemberTypeVo *)getMemberTypeVo:(NSDictionary *)dic {
    
    return [self mj_objectWithKeyValues:dic];
}

- (NSDictionary *)memberTypeDictionary {
    return [[self mj_keyValues] copy];
}

- (NSString *)jsonString {
    
    return [self mj_JSONString];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"sId":@"id",
             @"s_Id":@"_id",
             @"sHash":@"hash"};
}


- (NSString *)getModeStringShowRatio {
    
    if(self.mode == CardPrimeMember) {
        return @"会员价";
    }
    else if(self.mode ==  CardPrimeRaw) {
        return @"批发价";
    }
    else if(self.mode == CardPrimeDiscount) {
        
        if (self.ratio.integerValue == 100) {
            return @"100%";
        }
        else if (self.ratio) {
            return [NSString stringWithFormat:@"%@%@" ,[self.ratio stringFromNumberWithDecimalDigits:2] ,@"%"];
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
    
    if(self.mode == CardPrimeMember) {
        return @"使用会员价";
    }
    else if(self.mode ==  CardPrimeRaw) {
        return @"使用批发价";
    }
    else if(self.mode == CardPrimeDiscount) {
        
        return @"按固定折扣";
    }
    else
    {
        return @"无";
    }
}



+ (NSArray *)getNameItemsForPrimeType {
    
    return @[[[NameItemVO alloc] initWithVal:@"使用会员价" andId:@(CardPrimeMember).stringValue],
             [[NameItemVO alloc] initWithVal:@"使用折扣率" andId:@(CardPrimeDiscount).stringValue],
             [[NameItemVO alloc] initWithVal:@"使用批发价" andId:@(CardPrimeRaw).stringValue]
             ];
}

- (NSInteger)getCurrentPrimeTypeNameItemIndex {
    
    if (self.mode == CardPrimeMember) {
        return 0;
    }
    else if (self.mode == CardPrimeDiscount) {
        return 1;
    }
    else if (self.mode == CardPrimeRaw) {
        return 2;
    }
    return 1;
}


@end
