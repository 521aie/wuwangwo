//
//  BaseService.m
//  retailapp
//
//  Created by guozhi on 16/4/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseService.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "SignUtil.h"
#import "MyMD5.h"
#import "AFNetworking.h"
#import "ReailAppDefine.h"
#import "LSImageDataVo.h"
#import "LSImageVo.h"
#import "NSObject+MJKeyValue.h"
#import "JSONKit.h"
#import "ImageUtils.h"

@implementation BaseService
/**
 * 零售那边的网络请求
 */
+ (void)getRemoteLSDataWithUrl:(NSString *)url param:(NSDictionary *)param withMessage:(NSString *)message show:(BOOL)isShow CompletionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock {
    
    if (![url hasPrefix:@"http"]) {
         url  = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,url];
    }
   
    [self urlLSPath:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:message withShow:isShow];
}

NSDictionary *responseParam;

+ (void)getRemoteLSOutDataWithUrl:(NSString *)url param:(NSDictionary *)param withMessage:(NSString *)message show:(BOOL)isShow CompletionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock {
   
    url  = [NSString stringWithFormat:URL_PATH_FORMAT,API_OUT_ROOT,url];
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *curTime = [NSString stringWithFormat:@"%lld",time];
    NSString *signVal = [SignUtil convertOutSign:curTime];
    
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionary];
    [requestParam addEntriesFromDictionary:param];
    [requestParam setValue:signVal forKey:@"sign"];
    [requestParam setValue:@"json" forKey:@"format"];
    [requestParam setValue:APP_API_OUT_KEY forKey:@"app_key"];
    [requestParam setValue:curTime forKey:@"timestamp"];
    [self urlCYPath:url params:requestParam completionHandler:completionBlock errorHandler:errorBlock withMessage:message withShow:isShow];
}

+ (void)crossDomanRequestWithUrl:(NSString *)url param:(NSDictionary *)params withMessage:(NSString *)message show:(BOOL)isShow CompletionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock {
  
    if (isShow) {
        if ([NSString isNotBlank:message]) {
            [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeClear];
        } else {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        }
    }
    
    url  = [NSString stringWithFormat:URL_PATH_FORMAT,API_OUT_ROOT,url];
#if DEBUG || DAILY
    NSString *urlPath = [[Platform Instance] getkey:SERVER_API_OUT];
    url = [url stringByReplacingOccurrencesOfString:API_OUT_ROOT withString:urlPath];
#endif

    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *curTime = [NSString stringWithFormat:@"%lld",time];
    NSString *signVal = [SignUtil convertOutSign:curTime];
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionary];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:params forKey:@"data"];
    [requestParam addEntriesFromDictionary:dict];
    [requestParam setValue:signVal forKey:@"sign"];
    [requestParam setValue:@"json" forKey:@"format"];
    [requestParam setValue:APP_API_OUT_KEY forKey:@"appKey"];
    [requestParam setValue:curTime forKey:@"timestamp"];
    
    {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];

        // cookies 设置
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:storage.cookies];
        for (NSString *key in cookieHeaders) {
            [manager.requestSerializer setValue:cookieHeaders[key] forHTTPHeaderField:key];
        }
        manager.requestSerializer.timeoutInterval = TIME_OUT;
        manager.requestSerializer.stringEncoding =NSUTF8StringEncoding;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
        [manager POST:url parameters:requestParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (isShow) {
                [SVProgressHUD dismiss];
            }
            if (completionBlock||errorBlock) {
                NSDictionary *map = responseObject;
                NSNumber *success = [map objectForKey:@"success"];
                NSNumber *code = [map objectForKey:@"code"];
                if (success != nil && success.intValue == 0) {
                    NSString *message = [map objectForKey:@"message"];
                    if (code != nil && code.intValue == 405) {
                        
                    } else {
                        message = ([NSString isBlank:message]?@"系统繁忙，请稍后在试一次!":message);
                        [AlertBox show:message];
                    }
                    
                } else if ([code isEqual:[NSNull null]]) {
                    completionBlock(responseObject);
                } else if (code!=nil && code.intValue==0) {
                    NSString* message=[map objectForKey:@"message"];
                    message = [NSString isBlank:message]?@"系统繁忙，请稍后在试一次!":message;
                    [AlertBox show:message];
                } else {
                    completionBlock(responseObject);
                }
            }

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (isShow) {
                [SVProgressHUD dismiss];
            }

            if (errorBlock) {
                [self responseError:nil errorHandler:errorBlock];
            }
        }];
    }
}

+ (void)urlCYPath:(NSString *)path params:(NSDictionary *)params completionHandler:(HttpResponseBlock)completionBlock
        errorHandler:(HttpErrorBlock) errorBlock withMessage:(NSString*)message withShow:(BOOL)isShow {
    
#if DEBUG || DAILY
    NSString *urlPath = [[Platform Instance] getkey:SERVER_API_OUT];
    path = [path stringByReplacingOccurrencesOfString:API_OUT_ROOT withString:urlPath];
#endif
    if (isShow) {
        if ([NSString isNotBlank:message]) {
            [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeClear];
        }else{
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIME_OUT;
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (isShow) {
            [SVProgressHUD dismiss];
        }
        if (completionBlock || errorBlock) {
            NSDictionary *map = responseObject;
            NSNumber *success = [map objectForKey:@"success"];
            NSNumber *code = [map objectForKey:@"code"];
            if (success != nil && success.intValue == 0) {
                NSString *message=[map objectForKey:@"message"];
                if (code != nil && code.intValue == 405) {
                    
                } else {
                    message = ([NSString isBlank:message]?@"系统繁忙，请稍后在试一次!":message);
                    [AlertBox show:message];
                }
                
            } else if ([code isEqual:[NSNull null]]) {
                completionBlock(responseObject);
            } else if (code!=nil && code.intValue==0) {
                NSString* message=[map objectForKey:@"message"];
                message = [NSString isBlank:message]?@"系统繁忙，请稍后在试一次!":message;
                [AlertBox show:message];
            } else {
                completionBlock(responseObject);
            }
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (isShow) {
            [SVProgressHUD dismiss];
        }

        if (errorBlock) {
            
            [self responseError:nil errorHandler:errorBlock];
        }
        
    }];
}

+ (void)responseLSSuccess:(id)json completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock {
    
    NSString *exceptionString = nil;
    BOOL isOk = NO;
    if ([[json allKeys] containsObject:@"returnCode"]) {
        
        isOk = [[json objectForKey:@"returnCode"] isEqualToString:@"success"];
        if (!isOk) {
            exceptionString = [json objectForKey:@"exceptionMsg"];
            if ([NSString isBlank:exceptionString]) {
                exceptionString = [json objectForKey:@"message"];
            }
        }
    } else if ([[json allKeys] containsObject:@"code"]) {
        
        isOk = [json[@"code"] boolValue];
        if (!isOk) {
            exceptionString = [json valueForKey:@"message"];
            if ([NSString isBlank:exceptionString]) {
                exceptionString = [json valueForKey:@"exceptionMsg"];
            }
        }
    }
    
    if (isOk) {
        if (completionBlock) {
            completionBlock(json);
        }
    }
    else {
        
        if ([NSString isNotBlank:exceptionString]) {
            
            if (errorBlock) {
                errorBlock(exceptionString);
            }
            
        }
        else {
            NSString *exceptionCode = [json objectForKey:@"exceptionCode"];
            [self responseError:exceptionCode errorHandler:errorBlock];
        }
    }
}

+ (void)responseError:(id)json errorHandler:(HttpErrorBlock)errorBlock {
    
    if (!json) {
      
        json = @"网络异常，请稍后再试!";
    } else {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"message.plist" ofType:nil];
        NSDictionary *message = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSString *errStr = message[json];
        
        // 会话超时
        if ([@"CS_MSG_000019" isEqualToString:json]) {
            
            json = errStr ?:@"会话状态失效，请重新登录!";
            [LSAlertHelper showAlert:json block:^{
                 [self sessionInvaildRetryLogin];
            }];
            return;
        }
        
        if ([NSString isNotBlank:errStr]) {
            json = errStr;
        }
    }
    
    if (errorBlock) {
        errorBlock(json);
    }
    
}

+ (NSMutableDictionary *)createCommonDictionary {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:VERSION forKey:@"version"];
    [params setObject:APP_KEY forKey:@"appKey"];
    [params setObject:SYS_VERSION forKey:@"sys_version"];
    [params setObject:[self getSystemCurrTime] forKey:@"timestamp"];
    NSString* signVal = [MyMD5 HMACMD5WithString:[params objectForKey:@"timestamp"] WithKey:APP_SECRET];
    [params setValue:signVal forKey:@"sign"];
    
    return params;
}

+ (NSString *)getSystemCurrTime {
    
    NSDate* dat = [NSDate date];
    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%lld", (long long)a];
}



+ (void)urlLSPath:(NSString *)path params:(NSDictionary *)params completionHandler:(HttpResponseBlock)completionBlock
        errorHandler:(HttpErrorBlock) errorBlock withMessage:(NSString*)message withShow:(BOOL)isShow {
    
#if DEBUG || DAILY
    NSString *urlPath = [[Platform Instance] getkey:SERVER_API];
    path = [path stringByReplacingOccurrencesOfString:API_ROOT withString:urlPath];
#endif
    if (isShow) {
        if ([NSString isNotBlank:message]) {
            [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeClear];
        } else {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = TIME_OUT;
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    NSString* url = path;
    NSMutableDictionary *copyParams = [self createCommonDictionary];
    if (params!=nil) {
        [copyParams addEntriesFromDictionary:params];
    }

    __weak typeof(self) weakSelf = self;
    
    [manager POST:url parameters:copyParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (isShow) {
            [SVProgressHUD dismiss];
        }

        [strongSelf responseLSSuccess:responseObject completionHandler:completionBlock errorHandler:errorBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (isShow) {
            [SVProgressHUD dismiss];
        }
        
        [strongSelf responseError:nil errorHandler:errorBlock];
    }];
}


+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    if ([ObjectUtil isNull:dic]) {
        return @"";
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 *  上传图片接口
 *
 *  @param imageVoList     LSImageVo对象 主要存放图片的路径 类型 操作
 *  @param imageDataVoList LSImageDataVo对象 主要存放图片的路径 数据
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
+ (void)upLoadImageWithimageVoList:(NSMutableArray *)imageVoList imageDataVoList:(NSMutableArray *)imageDataVoList CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableArray *dictArray = [LSImageVo mj_keyValuesArrayWithObjectArray:imageVoList];
    NSString *jsonString = [dictArray JSONString];
    [param setValue:jsonString forKey:@"uploadVo"];
    NSMutableDictionary *copyParams = [self createCommonDictionary];
    [copyParams addEntriesFromDictionary:param];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __weak typeof(self) wself = self;
    NSString *path = nil;

    /**start*/
    path = [NSString stringWithFormat:URL_PATH_FORMAT, API_ROOT, UPLOAD_IMAGE];
#if DEBUG || DAILY
    NSString *urlPath = [[Platform Instance] getkey:SERVER_API];
    path = [path stringByReplacingOccurrencesOfString:API_ROOT withString:urlPath];
#endif
    /**end*/
    
    [manager POST:path parameters:copyParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (LSImageDataVo *imageDataVo in imageDataVoList) {
            NSData *data = imageDataVo.data;
            NSString *file = imageDataVo.file;
            [formData appendPartWithFileData:data name:file fileName:file mimeType:@"image/png"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        [wself responseLSSuccess:responseObject completionHandler:completionBlock errorHandler:errorBlock];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        
        if (errorBlock) {
            NSString *errorStr = [error localizedDescription];
            if ([errorStr isEqual:@"A connection failure occurred"]) {
                errorStr = @"网络不给力，请稍后再试！";
            }
            errorBlock(errorStr);
        }
        
    }];
}

+ (void)upLoadImageWithimageVoList:(NSMutableArray *)imageVoList imageDataVoList:(NSMutableArray *)imageDataVoList {
    [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataVoList CompletionHandler:^(id json) {
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


+ (void)uploadImageWithFilePath:(NSString *)filePath image:(UIImage *)image width:(int)width heigth:(int)height completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock {
    
    __weak typeof(self) wself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    [param setObject:filePath forKey:@"path"];

    manager.operationQueue.maxConcurrentOperationCount = 1;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = API_UPLOAD_ROOT;
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [wself responseLSSuccess:responseObject completionHandler:completionBlock errorHandler:errorBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (errorBlock) {
            NSString *errorStr = [error localizedDescription];
            if ([errorStr isEqual:@"A connection failure occurred"]) {
                errorStr = @"网络不给力，请稍后再试！";
            }
            errorBlock(errorStr);
        }
    }];
}


// 会话状态超时重新登录
+ (void)sessionInvaildRetryLogin {
    
    NSString *entityCode         = [[Platform Instance] getkey:USER];
    NSString *username           = [[Platform Instance] getkey:CODE];
    NSString *password           = [[Platform Instance] getkey:PASS];
    NSMutableDictionary* param   = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:entityCode forKey:@"entityCode"];
    [param setValue:username forKey:@"username"];
    [param setValue:[SignUtil convertPassword:password] forKey:@"password"];

    [BaseService getRemoteLSDataWithUrl:@"login" param:param withMessage:nil show:YES CompletionHandler:^(id json) {
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

@end
