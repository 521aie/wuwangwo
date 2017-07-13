//
//  OtherService.m
//  retailapp
//
//  Created by guozhi on 15/11/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OtherService.h"
#import "SignUtil.h"
#import "MyMD5.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@implementation OtherService

/**账户信息*/
- (void)accountDetail:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([[Platform Instance] getShopMode] == 2) {
        [param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    } else if ([[Platform Instance] getShopMode] == 3) {
        [param setValue:[[Platform Instance] getkey:ORG_ID] forKey:@"shopId"];
    }else if ([[Platform Instance] getShopMode] == 1) {
        [param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    }
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shopAccount/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**门店提现申请校验*/
- (void)applyCheck:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"withdrawCheck/check"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**用户银行账户添加*/
- (void)addBanks:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"userBank/save"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**创建门店提现申请*/
- (void)createApply:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"withdrawCheck/saveShopWithdrawCheck"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**门店提现审核信息列表	*/
- (void)applyList:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"withdrawCheck/resume"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
/**取消门店提现*/
- (void)applyCancel:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"withdrawCheck/updateWithdrawCheck"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**余额日志*/
- (void)balanceLog:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"withdrawCheck/shopMoneyFlow"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (NSString*)convertSign:(NSMutableDictionary*)params
{
    NSMutableString *ns = [NSMutableString string];
    
    if ([ObjectUtil isNotEmpty:params]) {
        NSString *val;
        NSArray *keys=[params allKeys];
        NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *key in sortedKeys) {
            val=(NSString *)[params objectForKey:key];
            if ([key isEqualToString:@"sign"] || [key isEqualToString:@"method"] || [key isEqualToString:@"appKey"] || [key isEqualToString:@"v"] || [key isEqualToString:@"format"] || [key isEqualToString:@"timestamp"]) {
                continue;
            }
            if ([NSString isNotBlank:val]) {
                [ns appendString:key];
                [ns appendString:val];
            }
        }
    }
    [ns appendString:APP_CY_API_SECRET];
    return [MyMD5 md5:ns];
}



@end
