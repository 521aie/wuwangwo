//
//  MicroDistributeService.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserBankVo.h"

@interface MicroDistributeService : NSObject

//选择微分销基本设置列表
- (void)microDistributeList:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock;

//保存微分销基本设置
- (void)saveMicroDistribute:(NSArray *)microDistributeVoList
          completionHandler:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock;

//根据code查找微分销基本设置
- (void)selectMicroDistributeByCode:(NSString *)code
                  completionHandler:(HttpResponseBlock) completionBlock
                       errorHandler:(HttpErrorBlock) errorBlock;


//根据银行编码查询银行所属省份
- (void)selectProvinceList:(NSString *)bankName
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock;

//根据银行编码和省份编码查询银行所属省份的城市列表
- (void)selectCityList:(NSString *)bankName
            provinceNo:(NSString *)provinceNo
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock;

//银行编码和城市编码查询银行所属城市的支行列表
- (void)selectSubBankList:(NSString *)bankName
                   cityNo:(NSString *)cityNo
        completionHandler:(HttpResponseBlock) completionBlock
             errorHandler:(HttpErrorBlock) errorBlock;

//用户银行账户一览
- (void)selectUserBankList:(NSString *)userId
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock;

//用户银行账户添加
- (void)saveUserBank:(UserBankVo *)userBank
   completionHandler:(HttpResponseBlock) completionBlock
        errorHandler:(HttpErrorBlock) errorBlock;

@end
