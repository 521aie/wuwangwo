//
//  CommentService.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CommentService.h"

@implementation CommentService

//综合评价(实体)
- (void)shopReport:(NSString *)shopId
      shopEntityId:(NSString *)shopEntityId
 completionHandler:(HttpResponseBlock)completionBlock
      errorHandler:(HttpErrorBlock)errorBlock {

    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"commentReport/shop"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if ([NSString isNotBlank:shopEntityId]) {
        [param setValue:shopEntityId forKey:@"shopEntityId"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


//综合评价(微店)
- (void)microShopReport:(NSString *)shopId
                  modal:(NSString *)modal
      completionHandler:(HttpResponseBlock)completionBlock
           errorHandler:(HttpErrorBlock)errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"commentReport/microShop"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }else [param setValue:@"" forKey:@"shopId"];
    
    if (modal) {
        [param setValue:modal forKey:@"modal"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//综合评价（实体）--历史汇总
- (void)shopHistoryReportList:(NSString *)shopId
                        modal:(NSString *)modal
                  companionId:(NSString *)companionId
                    startDate:(NSInteger)startDate
                      endDate:(NSInteger)endDate
            completionHandler:(HttpResponseBlock) completionBlock
                 errorHandler:(HttpErrorBlock) errorBlock {

    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"commentReport/shopHistoryList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    if ([NSString isNotBlank:shopId] && ![shopId isEqualToString:@"0"]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if (modal) {
        [param setValue:modal forKey:@"modal"];
    }
    
    [param setValue:@NO forKey:@"isMicroShop"];
    
    if (companionId) {
        [param setValue:companionId forKey:@"companionId"];
    }
    if (startDate > 0) {
        [param setValue:[NSNumber numberWithInteger:startDate] forKey:@"startDate"];
    }
    if (endDate > 0) {
        [param setValue:[NSNumber numberWithInteger:endDate] forKey:@"endDate"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//综合评价（微店）--历史汇总
- (void)microShopHistoryReportList:(NSString *)shopId
                             modal:(NSString *)modal
                       companionId:(NSString *)companionId
                         startDate:(NSInteger)startDate
                           endDate:(NSInteger)endDate
                 completionHandler:(HttpResponseBlock) completionBlock
                      errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"commentReport/shopHistoryList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if (modal) {
        [param setValue:modal forKey:@"modal"];
    }
    [param setValue:@YES forKey:@"isMicroShop"];
    
    
    if (companionId) {
        if([companionId isEqualToString:@"-1"]){
            //这里总部也是nil和-1，此次统一处理成nil，所以不做任何处理，等代码重构的时候再说。
        }else{
            [param setValue:companionId forKey:@"companionId"];
        }
        
    }
    if (startDate > 0) {
        [param setValue:[NSNumber numberWithInteger:startDate] forKey:@"startDate"];
    }
    if (endDate > 0) {
        [param setValue:[NSNumber numberWithInteger:endDate] forKey:@"endDate"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


//商品评价列表
- (void)goodsReport:(NSString *)shopId
        companionId:(NSString *)companionId
           lastTime:(NSInteger)lastTime
            keyWord:(NSString *)keyWord
            barCode:(NSString *)barCode
        isMicroShop:(NSNumber *)isMicroShop
              modal:(NSString *)modal
  completionHandler:(HttpResponseBlock) completionBlock
       errorHandler:(HttpErrorBlock) errorBlock {

    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"commentReport/goods"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if ([NSString isNotBlank:companionId]) {
        [param setValue:companionId forKey:@"companionId"];
    }
    if (lastTime > 0) {
        [param setValue:[NSNumber numberWithInteger:lastTime] forKey:@"lastTime"];
    }
    if ([NSString isNotBlank:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    if ([NSString isNotBlank:barCode]) {
        [param setValue:barCode forKey:@"barCode"];
    }
    if (isMicroShop) {
        BOOL isMic = [isMicroShop boolValue];
        [param setValue:[NSNumber numberWithBool:isMic] forKey:@"isMicroShop"];
    }
    if (modal) {
        [param setValue:modal forKey:@"modal"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//商品评价详细
- (void)goodsReportDetail:(NSString *)shopId
                 shopType:(NSInteger)shopType
                   goodId:(NSString *)goodId
                startTime:(NSNumber *)startTime
                  endTime:(NSNumber *)endTime
                 lastTime:(NSNumber *)lastTime
             commentLevel:(NSNumber *)commentLevel
        completionHandler:(HttpResponseBlock) completionBlock
             errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"commentReport/goodDetail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    } else {
        [param setValue:[NSNull null] forKey:@"shopId"];
    }
    
    if (goodId) {
        [param setValue:goodId forKey:@"goodId"];
    }
    [param setValue:[NSNumber numberWithInteger:shopType] forKey:@"shopType"];
    
    if (startTime) {
        [param setValue:startTime forKey:@"startTime"];
    }
    if (endTime) {
        [param setValue:endTime forKey:@"endTime"];
    }
    if (lastTime) {
        [param setValue:lastTime forKey:@"lastTime"];
    }
    if (commentLevel) {
        [param setValue:commentLevel forKey:@"commentLevel"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

@end
