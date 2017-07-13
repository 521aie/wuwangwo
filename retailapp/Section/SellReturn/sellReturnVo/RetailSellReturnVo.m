//
//  RetailSellReturnVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RetailSellReturnVo.h"
#import "MJExtension.h"

@implementation RetailInstanceVo


@end

@implementation RetailExpansion

@end


@implementation RetailSellReturnVo

+ (RetailSellReturnVo *)converToVo:(NSDictionary *)dic {
   
    return [self mj_objectWithKeyValues:dic];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"instanceList" : @"RetailInstanceVo"};
}


+ (NSMutableArray*)converToArr:(NSArray*)sourceList {
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            RetailSellReturnVo* retailSellReturnVo = [RetailSellReturnVo converToVo:dic];
            [dataList addObject:retailSellReturnVo];
        }
    }
    return dataList;
}

- (NSDictionary *)convertToDic {
    return [[self mj_keyValues] copy];
}

- (NSString *)getStatusString {
    NSDictionary *statusDic = @{@"1":@"待审核", @"2":@"退款成功", @"3":@"同意退货", @"4":@"退货中", @"5":@"待退款", @"6":@"拒绝退货", @"7":@"拒绝退款", @"8":@"取消退货", @"9":@"退款失败"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%ld" ,(long)self.status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    }
    return @"";
}
@end
