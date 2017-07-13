//
//  HttpEngine.h
//  retailapp
//
//  Created by hm on 15/7/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpResponseBlock)(id json);
typedef void (^HttpErrorBlock)(id json);

typedef enum HttpMethodType {
    GET_TYPE,
    POST_TYPE
} HttpMethodType;

@interface HttpEngine : NSObject

+ (HttpEngine *)sharedEngine;

/**
 *  访问API服务器的结果(无指示器)
 *
 *  @param path            url地址
 *  @param params          参数
 *  @param completionBlock 成功回调block
 *  @param errorBlock      失败回调block
 */
- (void)postUrl:(NSString *)path
            params:(NSDictionary *)params
            completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock;


/**
 *  访问API服务器的结果（不显示成功失败/信息）
 *
 *  @param path            url地址
 *  @param params          参数
 *  @param completionBlock 成功回调block
 *  @param errorBlock      失败回调block
 *  @param message         加载时提示信息
 */
- (void)postUrl:(NSString *)path
            params:(NSDictionary *)params
            completionHandler:(HttpResponseBlock)completionBlock
            errorHandler:(HttpErrorBlock)errorBlock
            withMessage:(NSString*)message;


@end

