//
//  SellReturnService.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellReturnService : NSObject

//退货单一览
- (void)sellReturnList:(NSString *)keywords
                mobile:(NSString *)mobile
                status:(short)status
            returnTime:(NSString *)returnTime
          lastDateTime:(long long)lastDateTime
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock;

/** 退货单详情
  * @param sellReturnId 退货单ID
  */
- (void)sellReturnDetail:(NSString *)sellReturnId
       completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock;
//退款单一览
- (void)sellReturnMoneyList:(NSString *)searchType
                 serachCode:(NSString *)serachCode
                     status:(short)status
                 returnTime:(NSString *)returnTime
               lastDateTime:(long long)lastDateTime
          completionHandler:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock;
//退款单操作
-(void)sellReturnMoneyOpera:(NSString *)shopId
                       code:(NSString *)code
                    lastVer:(long long)lastVer
          completionHandler:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock;
//退款单批量操作
-(void)sellReturnMoneyBatchOpera:(NSArray *)retailSellReturnVoList
                            flag:(NSInteger)flag
          completionHandler:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock;

//处理退货单
- (void)dealSellReturn:(NSDictionary *)param
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock;

//店铺退货地址信息
- (void)shopReturnInfo:(NSString *)shopId
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock;

//退货类型一览
- (void)returnTypeListCompletionHandler:(HttpResponseBlock) completionBlock
                           errorHandler:(HttpErrorBlock) errorBlock;

//查询物流信息
- (void)logisticsMessage:(NSString *)billCode
               logisticsName:(NSString *)logisticsName
       completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock;

@end
