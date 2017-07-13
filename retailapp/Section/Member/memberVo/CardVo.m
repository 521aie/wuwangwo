//
//  CardVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CardVo.h"
#import "ObjectUtil.h"

@implementation CardVo

+ (CardVo*)convertToCard:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        CardVo* cardVo = [[CardVo alloc] init];
        cardVo.cardId = [ObjectUtil getStringValue:dic key:@"cardId"];
        cardVo.kindCardId = [ObjectUtil getStringValue:dic key:@"kindCardId"];
        cardVo.code = [ObjectUtil getStringValue:dic key:@"code"];
        cardVo.kindCardName = [ObjectUtil getStringValue:dic key:@"kindCardName"];
        cardVo.cardshopid = [ObjectUtil getStringValue:dic key:@"cardshopid"];
        cardVo.cardshopname = [ObjectUtil getStringValue:dic key:@"cardshopname"];
        cardVo.balance = [ObjectUtil getDoubleValue:dic key:@"balance"];
        cardVo.consumeAmount = [ObjectUtil getDoubleValue:dic key:@"consumeAmount"];
        cardVo.point = [ObjectUtil getIntegerValue:dic key:@"point"];
        cardVo.degreeAmount = [ObjectUtil getIntegerValue:dic key:@"degreeAmount"];
        cardVo.giftBalance = [ObjectUtil getDoubleValue:dic key:@"giftBalance"];
        cardVo.ratio = [ObjectUtil getDoubleValue:dic key:@"ratio"];
        cardVo.activeDate = [ObjectUtil getLonglongValue:dic key:@"activeDate"];
        cardVo.status = [ObjectUtil getStringValue:dic key:@"status"];
        cardVo.isPrefeeDegree = [ObjectUtil getShortValue:dic key:@"isPrefeeDegree"];
        cardVo.isRatiofeeDegree = [ObjectUtil getShortValue:dic key:@"isRatiofeeDegree"];
        cardVo.exchangeDegree = [ObjectUtil getDoubleValue:dic key:@"exchangeDegree"];
        cardVo.ratioExchangeDegree = [ObjectUtil getDoubleValue:dic key:@"ratioExchangeDegree"];
        cardVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        
        return cardVo;
    }
    return nil;
}

+ (NSDictionary*)getDictionaryData:(CardVo *)cardVo
{
    if ([ObjectUtil isNotNull:cardVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"cardId" val:cardVo.cardId];
        [ObjectUtil setStringValue:data key:@"kindCardId" val:cardVo.kindCardId];
        [ObjectUtil setStringValue:data key:@"code" val:cardVo.code];
        [ObjectUtil setStringValue:data key:@"kindCardName" val:cardVo.kindCardName];
        [ObjectUtil setStringValue:data key:@"cardshopid" val:cardVo.cardshopid];
        [ObjectUtil setStringValue:data key:@"cardshopname" val:cardVo.cardshopname];
        [ObjectUtil setDoubleValue:data key:@"balance" val:cardVo.balance];
        [ObjectUtil setDoubleValue:data key:@"consumeAmount" val:cardVo.consumeAmount];
        [ObjectUtil setIntegerValue:data key:@"point" val:cardVo.point];
        [ObjectUtil setIntegerValue:data key:@"degreeAmount" val:cardVo.degreeAmount];
        [ObjectUtil setDoubleValue:data key:@"giftBalance" val:cardVo.giftBalance];
        [ObjectUtil setDoubleValue:data key:@"ratio" val:cardVo.ratio];
        [ObjectUtil setLongLongValue:data key:@"activeDate" val:cardVo.activeDate];
        [ObjectUtil setStringValue:data key:@"status" val:cardVo.status];
        [ObjectUtil setShortValue:data key:@"isPrefeeDegree" val:cardVo.isPrefeeDegree];
        [ObjectUtil setShortValue:data key:@"isRatiofeeDegree" val:cardVo.isRatiofeeDegree];
        [ObjectUtil setDoubleValue:data key:@"exchangeDegree" val:cardVo.exchangeDegree];
        [ObjectUtil setDoubleValue:data key:@"ratioExchangeDegree" val:cardVo.ratioExchangeDegree];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:cardVo.lastVer];
        
        return data;
    }
    return nil;

}

@end
