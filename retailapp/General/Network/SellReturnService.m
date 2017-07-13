//
//  SellReturnService.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SellReturnService.h"

@implementation SellReturnService

//退货单一览
- (void)sellReturnList:(NSString *)keywords
                mobile:(NSString *)mobile
                status:(short)status
            returnTime:(NSString *)returnTime
          lastDateTime:(long long)lastDateTime
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"sellReturn/getlist"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];

    if ([NSString isNotBlank:keywords]) {
        [param setValue:keywords forKey:@"keywords"];
    } else {
        [param setValue:@"" forKey:@"keywords"];
    }
    if ([NSString isNotBlank:mobile]) {
        [param setValue:mobile forKey:@"mobile"];
    } else {
        [param setValue:@"" forKey:@"mobile"];
    }

    [param setValue:[NSNumber numberWithShort:status] forKey:@"status"];
    
    if ([NSString isNotBlank:returnTime]) {
        [param setValue:returnTime forKey:@"returnTime"];
    }
    if (lastDateTime > 0) {
        [param setValue:[NSNumber numberWithLongLong:lastDateTime] forKey:@"lastDateTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//退货单详情
- (void)sellReturnDetail:(NSString *)sellReturnId
       completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"sellReturn/detail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    /** 注: 报表改造1期
     * String shopId（删除）
     * String code（删除） 删除于
     * String sellReturnId（退货单ID）(新增)
     */
    [param setValue:sellReturnId forKey:@"sellReturnId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//退款单一览
- (void)sellReturnMoneyList:(NSString *)searchType
                serachCode:(NSString *)serachCode
                status:(short)status
            returnTime:(NSString *)returnTime
          lastDateTime:(long long)lastDateTime
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"refundManagement/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    if ([NSString isNotBlank:searchType]) {
        [param setValue:searchType forKey:@"searchType"];
    }
    if ([NSString isNotBlank:serachCode]) {
        [param setValue:serachCode forKey:@"keywords"];
    }
    [param setValue:[NSNumber numberWithShort:status] forKey:@"status"];
    
    if ([NSString isNotBlank:returnTime]) {
        [param setValue:returnTime forKey:@"returnTime"];
    }
    if (lastDateTime > 0) {
        [param setValue:[NSNumber numberWithLongLong:lastDateTime] forKey:@"lastDateTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void)sellReturnMoneyOpera:(NSString *)shopId
                       code:(NSString *)code
                    lastVer:(long long)lastVer
          completionHandler:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"refundManagement/dealRefund"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if ([NSString isNotBlank:code]) {
        [param setValue:code forKey:@"code"];
    }
    [param setValue:[NSNumber numberWithLong:lastVer] forKey:@"lastVer"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void)sellReturnMoneyBatchOpera:(NSArray *)retailSellReturnVoList
                            flag:(NSInteger)flag
               completionHandler:(HttpResponseBlock) completionBlock
                    errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"refundManagement/batchDealRefund"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:retailSellReturnVoList forKey:@"retailSellReturnVoList"];
    [param setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


//处理退货单
- (void)dealSellReturn:(NSDictionary *)param
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"sellReturn/dealSellReturn"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//店铺退货地址信息
- (void)shopReturnInfo:(NSString *)shopId
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"sellReturn/shopReturnInfo"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }

    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//退货类型一览
- (void)returnTypeListCompletionHandler:(HttpResponseBlock) completionBlock
                           errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"sellReturn/returnTypeList"];

    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock];
}

//查询物流信息
- (void)logisticsMessage:(NSString *)billCode
          logisticsName:(NSString *)logisticsName
       completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"sellReturn/logisticsMessage"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([NSString isNotBlank:billCode]) {
        [param setValue:billCode forKey:@"billCode"];
    }
    if ([NSString isNotBlank:logisticsName]) {
        [param setValue:logisticsName forKey:@"logisticsName"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

@end
