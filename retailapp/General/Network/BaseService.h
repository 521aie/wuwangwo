//
//  BaseService.h
//  retailapp
//
//  Created by guozhi on 16/4/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^RequestFinishedBlock)();
@interface BaseService : NSObject
/**
 * 零售的网络请求
 * url               请求路径(后半部分)
 * param             请求参数
 * message           请求等待页面提示信息
 * isShow            是否显示等待请求页面
 * CompletionHandler 成功回调
 * errorHandler      失败回调
 */
+ (void)getRemoteLSDataWithUrl:(NSString *)url param:(NSDictionary *)param withMessage:(NSString *)message show:(BOOL)isShow CompletionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;


+ (void)getRemoteLSOutDataWithUrl:(NSString *)url param:(NSDictionary *)param withMessage:(NSString *)message show:(BOOL)isShow CompletionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

// 用于api 登录时，跨域访问
+ (void)crossDomanRequestWithUrl:(NSString *)url param:(NSDictionary *)params withMessage:(NSString *)message show:(BOOL)isShow CompletionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

// 图片上传接口
+ (void)upLoadImageWithimageVoList:(NSMutableArray *)imageVoList imageDataVoList:(NSMutableArray *)imageDataVoList;
+ (void)uploadImageWithFilePath:(NSString *)filePath image:(UIImage *)image width:(int)width heigth:(int)height completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;
@end
