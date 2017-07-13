//
//  MicroDistributeService.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroDistributeService.h"
#import "MicroDistributeVo.h"

@implementation MicroDistributeService

//选择微分销基本设置列表
- (void)microDistributeList:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microDistribute/list"];
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//保存微分销基本设置
- (void)saveMicroDistribute:(NSArray *)microDistributeVoList
          completionHandler:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microDistribute/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([ObjectUtil isNotEmpty:microDistributeVoList]) {
        NSMutableArray *list = [NSMutableArray arrayWithCapacity:microDistributeVoList.count];
        
        for (MicroDistributeVo *vo in microDistributeVoList) {
            [list addObject:[vo toDictionary]];
        }
        
        [param setValue:list forKey:@"microDistributeVoList"];
    }

    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//根据code查找微分销基本设置
- (void)selectMicroDistributeByCode:(NSString *)code
                  completionHandler:(HttpResponseBlock) completionBlock
                       errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microDistribute/selectByCode"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([NSString isNotBlank:code]) {
        [param setValue:code forKey:@"code"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


//根据银行编码查询银行所属省份
- (void)selectProvinceList:(NSString *)bankName
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"userBank/selectProvinceList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([NSString isNotBlank:bankName]) {
        [param setValue:bankName forKey:@"bankName"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//根据银行编码和省份编码查询银行所属省份的城市列表
- (void)selectCityList:(NSString *)bankName
            provinceNo:(NSString *)provinceNo
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"userBank/selectCityList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if ([NSString isNotBlank:bankName]) {
        [param setValue:bankName forKey:@"bankName"];
    }
    if ([NSString isNotBlank:provinceNo]) {
        [param setValue:provinceNo forKey:@"provinceNo"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//银行编码和城市编码查询银行所属城市的支行列表
- (void)selectSubBankList:(NSString *)bankName
                   cityNo:(NSString *)cityNo
        completionHandler:(HttpResponseBlock) completionBlock
             errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"userBank/selectSubBankList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if ([NSString isNotBlank:bankName]) {
        [param setValue:bankName forKey:@"bankName"];
    }
    if ([NSString isNotBlank:cityNo]) {
        [param setValue:cityNo forKey:@"cityNo"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//用户银行账户一览
- (void)selectUserBankList:(NSString *)userId
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"userBank/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([NSString isNotBlank:userId]) {
        [param setValue:userId forKey:@"userId"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//用户银行账户添加
- (void)saveUserBank:(UserBankVo *)userBank
   completionHandler:(HttpResponseBlock) completionBlock
        errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"userBank/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([ObjectUtil isNotNull:userBank]) {
        [param setValue:[userBank toDictionary] forKey:@"userBankVo"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

@end
