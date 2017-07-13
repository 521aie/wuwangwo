//
//  LSNetwrokHelper.h
//  retailapp
//
//  Created by taihangju on 2016/11/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;
typedef  void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface LSNetworkModel : NSObject

@property (nonatomic ,strong) NSString *url;/*<请求地址>*/
@property (nonatomic ,strong) NSString *httpMethod;/*<http请求方式>*/
@property (nonatomic ,assign) NSTimeInterval timeOut;/*<超时时间>*/
@property (nonatomic ,strong) NSArray *params;/*<请求参数>*/
@property (nonatomic ,strong) NSDictionary *httpHeaderFieldDic;/*<httpHeaderField>*/
@property (nonatomic ,strong) NSSet *acceptContentTypeSet;/*<response接受的: Content-Type>*/
/*<请求成功block回调>*/
@property (nonatomic ,copy) SuccessBlock successBlock;
/*<请求失败block回调>*/
@property (nonatomic ,copy) FailureBlock failureBlock;
@end

@interface LSNetwrokHelper : NSObject

@end
