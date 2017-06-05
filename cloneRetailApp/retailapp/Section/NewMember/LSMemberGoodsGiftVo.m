//
//  LSMemberGiftVo.m
//  retailapp
//
//  Created by taihangju on 16/10/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberGoodsGiftVo.h"

//@implementation LSMemberGiftVo
//
//+ (NSDictionary *)mj_objectClassInArray {
//    return @{@"giftPojoList":@"LSMemberGiftBalanceVo",@"goodsGiftList":@"LSMemberGiftGoodVo"};
//}
//
//+ (LSMemberGiftVo *)memberGiftVo:(NSDictionary *)dic {
//    
//    return [self mj_objectWithKeyValues:dic];
//}
//
//
//@end

@implementation LSMemberGoodsGiftVo

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.sId = @"";
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"sId":@"id"};
}

+ (NSArray *)voListFromJsonArray:(NSArray *)keyValuesArray {
    return [[self mj_objectArrayWithKeyValuesArray:keyValuesArray] copy];
}

+ (NSString *)jsonStringFromVoList:(NSArray *)voArray {
    NSArray *jsonObjects = [self jsonArrayFromVoList:voArray];
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObjects options:NSJSONWritingPrettyPrinted error:nil];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (NSArray *)jsonArrayFromVoList:(NSArray *)voArray {
    return [[self mj_keyValuesArrayWithObjectArray:voArray] copy];
}

// 2-拆分商品 3-组装商品 4-散装商品 5-原料商品 6-加工商品
- (NSString *)goodTypeImageString {
    switch (self.goodsType.integerValue) {
        case 2:
            return @"status_chaifen";
            break;
        case 3:
            return @"status_zhuzhuang";
            break;
        case 4:
            return @"status_shancheng";
            break;
        case 5:
            return @"";
            break;
        case 6:
            return @"status_jiagong";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)toJsonString {
    
    NSString *jsonString = [[self mj_JSONString] stringByReplacingOccurrencesOfString:@"point" withString:@"quantity"];
    return jsonString;
}

- (NSString *)name {
    if (!_name) {
        return @"";
    }
    return _name;
}

- (NSString *)innerCode {
    if (!_innerCode) {
        return @"";
    }
    return _innerCode;
}

- (NSString *)barCode {
    if (!_barCode) {
        return @"";
    }
    return _barCode;
}

- (NSString *)goodsSize {
    if (!_goodsSize) {
        return @"";
    }
    return _goodsSize;
}

- (NSNumber *)giftStore {
    if (!_giftStore) {
        return @(0);
    }
    return _giftStore;
}

- (NSNumber *)weixinGiftStore {
    if (!_weixinGiftStore) {
        return @(0);
    }
    return _weixinGiftStore;
}

@end

//@implementation LSMemberGiftBalanceVo
//
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"sId":@"id"};
//}
//
//- (NSString *)giftBalanceVoJsonString {
//    return [self mj_JSONString];
//}
//
//@end
