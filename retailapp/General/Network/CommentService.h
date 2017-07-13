//
//  CommentService.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentService : NSObject

//综合评价(实体)
- (void)shopReport:(NSString *)shopId
      shopEntityId:(NSString *)shopEntityId
 completionHandler:(HttpResponseBlock) completionBlock
      errorHandler:(HttpErrorBlock) errorBlock;

//综合评价(微店)
- (void)microShopReport:(NSString *)shopId
                  modal:(NSString *)modal
      completionHandler:(HttpResponseBlock)completionBlock
           errorHandler:(HttpErrorBlock)errorBlock;

//综合评价（实体）--历史汇总
- (void)shopHistoryReportList:(NSString *)shopId
                        modal:(NSString *)modal
                  companionId:(NSString *)companionId
                    startDate:(NSInteger)startDate
                      endDate:(NSInteger)endDate
            completionHandler:(HttpResponseBlock) completionBlock
                 errorHandler:(HttpErrorBlock) errorBlock;

//综合评价（微店）--历史汇总
- (void)microShopHistoryReportList:(NSString *)shopId
                             modal:(NSString *)modal
                       companionId:(NSString *)companionId
                         startDate:(NSInteger)startDate
                           endDate:(NSInteger)endDate
                 completionHandler:(HttpResponseBlock) completionBlock
                      errorHandler:(HttpErrorBlock) errorBlock;

//商品评价列表
- (void)goodsReport:(NSString *)shopId
        companionId:(NSString *)companionId
           lastTime:(NSInteger)lastTime
            keyWord:(NSString *)keyWord
            barCode:(NSString *)barCode
        isMicroShop:(NSNumber *)isMicroShop
              modal:(NSString *)modal
  completionHandler:(HttpResponseBlock) completionBlock
       errorHandler:(HttpErrorBlock) errorBlock;

//商品评价详细
- (void)goodsReportDetail:(NSString *)shopId
                 shopType:(NSInteger)shopType
                   goodId:(NSString *)goodId
                startTime:(NSNumber *)startTime
                  endTime:(NSNumber *)endTime
                 lastTime:(NSNumber *)lastTime
             commentLevel:(NSNumber *)commentLevel
        completionHandler:(HttpResponseBlock) completionBlock
             errorHandler:(HttpErrorBlock) errorBlock;

@end
