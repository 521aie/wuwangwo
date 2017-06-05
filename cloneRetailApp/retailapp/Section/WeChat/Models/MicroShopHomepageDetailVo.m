//
//  microShopHomepageDetailVoArrVo.m
//  retailapp
//
//  Created by diwangxie on 16/4/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroShopHomepageDetailVo.h"
#import "MJExtension.h"

@implementation MicroShopHomepageDetailVo

//+(microShopHomepageDetailVoArrVo *)convertTomicroShopHomepageDetailVoArrVo:(NSDictionary*)dic{
//    if ([ObjectUtil isNotEmpty:dic]) {
//        microShopHomepageDetailVoArrVo *vo=[[microShopHomepageDetailVoArrVo alloc] init];
//        vo.id=[ObjectUtil getStringValue:dic key:@"id"];
//        vo.microShopHomepageId=[ObjectUtil getStringValue:dic key:@"microShopHomepageId"];
//        vo.relevanceId=[ObjectUtil getStringValue:dic key:@"relevanceId"];
//        vo.relevanceType=[ObjectUtil getIntegerValue:dic key:@"relevanceType"];
//        
//        vo.sortCode=[ObjectUtil getIntegerValue:dic key:@"sortCode"];
//        vo.styleName=[ObjectUtil getStringValue:dic key:@"styleName"];
//        vo.styleCode=[ObjectUtil getStringValue:dic key:@"styleCode"];
//        vo.goodsBarCode=[ObjectUtil getStringValue:dic key:@"goodsBarCode"];
//        vo.goodsName=[ObjectUtil getStringValue:dic key:@"goodsName"];
//        vo.cateGoryName=[ObjectUtil getStringValue:dic key:@"cateGoryName"];
//        return vo;
//    }
//    return nil;
//}
//+(NSDictionary*)getDictionaryData:(microShopHomepageDetailVoArrVo *)microShopHomepageDetailVoArrVo{
//    if ([ObjectUtil isNotEmpty:microShopHomepageDetailVoArrVo]) {
//        NSMutableDictionary* data = [NSMutableDictionary dictionary];
//        [ObjectUtil setStringValue:data key:@"id" val:microShopHomepageDetailVoArrVo.id];
//        [ObjectUtil setStringValue:data key:@"microShopHomepageId" val:microShopHomepageDetailVoArrVo.microShopHomepageId];
//        [ObjectUtil setStringValue:data key:@"relevanceId" val:microShopHomepageDetailVoArrVo.relevanceId];
//        [ObjectUtil setIntegerValue:data key:@"relevanceType" val:microShopHomepageDetailVoArrVo.relevanceType];
//        
//        [ObjectUtil setIntegerValue:data key:@"sortCode" val:microShopHomepageDetailVoArrVo.sortCode];
//        [ObjectUtil setStringValue:data key:@"styleName" val:microShopHomepageDetailVoArrVo.styleName];
//        [ObjectUtil setStringValue:data key:@"styleCode" val:microShopHomepageDetailVoArrVo.styleCode];
//        [ObjectUtil setStringValue:data key:@"goodsBarCode" val:microShopHomepageDetailVoArrVo.goodsBarCode];
//        [ObjectUtil setStringValue:data key:@"goodsName" val:microShopHomepageDetailVoArrVo.goodsName];
//        [ObjectUtil setStringValue:data key:@"cateGoryName" val:microShopHomepageDetailVoArrVo.cateGoryName];
//        
//        return data;
//    }
//    return nil;
//}


+(MicroShopHomepageDetailVo *)convertTomicroShopHomepageDetailVoArrVo:(NSDictionary*)dic {
    return [self mj_objectWithKeyValues:dic];
}

// Model -> JSON【将一个模型转成字典】
- (NSDictionary *)convertToDictionary {
    return [self.mj_keyValues copy];
}

//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"_id":@"id"};
//}

@end
