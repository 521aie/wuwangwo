//
//  OtherService.h
//  retailapp
//
//  Created by guozhi on 15/11/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherService : NSObject
/**账户信息*/
- (void)accountDetail:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**门店提现申请校验*/
- (void)applyCheck:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**用户银行账户添加*/
- (void)addBanks:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**创建门店提现申请*/
- (void)createApply:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**门店提现审核信息列表	*/
- (void)applyList:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**取消门店提现*/
- (void)applyCancel:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**余额日志*/
- (void)balanceLog:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

@end
