//
//  HttpEngine+Member.m
//  retailapp
//
//  Created by taihangju on 16/9/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "HttpEngine+Member.h"
#import "AFNetworking.h"
#import "AlertBox.h"

@implementation HttpEngine (Member)

+ (void)mb_upLoadImage:(NSString *)path param:(NSDictionary *)param imageData:(NSArray *)imageList CompletionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock {
    
    __weak typeof(self) wself = self;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", @"application/x-www-form-urlencoded", nil];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:param];
    [params setValue:@"1280" forKey:@"width"];
    [params setValue:@"1280" forKey:@"height"];
    [params setValue:@"128" forKey:@"smallWidth"];
    [params setValue:@"72" forKey:@"smallHeight"];
    [params setValue:@"160" forKey:@"minWidth"];
    [params setValue:@"160" forKey:@"minHeight"];

    [SVProgressHUD show];
    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSDictionary *dict in imageList) {
            NSData *data = dict[@"data"];
            NSString *file = dict[@"file"];
            file = [NSString isNotBlank:file] ? file : @"file";
            [formData appendPartWithFileData:data name:file fileName:file mimeType:@"image/jpg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] boolValue] && completionBlock) {
            
            completionBlock(responseObject);
        }
        else if ([NSString isNotBlank:responseObject[@"message"]])
        {
            [AlertBox show:responseObject[@"message"]];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (errorBlock) {
            
            [wself responseError:nil errorHandler:errorBlock];
        }
    }];
//    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        for (NSDictionary *dict in imageList) {
//            NSData *data = dict[@"data"];
//            NSString *file = dict[@"file"];
//            file = [NSString isNotBlank:file] ? file : @"file";
//            [formData appendPartWithFileData:data name:file fileName:file mimeType:@"image/jpg"];
//        }
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [SVProgressHUD dismiss];
//        if ([responseObject[@"code"] boolValue] && completionBlock) {
//            
//            completionBlock(responseObject);
//        }
//        else if ([NSString isNotBlank:responseObject[@"message"]])
//        {
//            [AlertBox show:responseObject[@"message"]];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       
//        [SVProgressHUD dismiss];
//        if (errorBlock) {
//           
//            [wself responseError:[operation responseObject] errorHandler:errorBlock];
//        }
//    }];
}


+ (void)responseError:(id)json errorHandler:(HttpErrorBlock)errorBlock
{
    if (json == nil) {
        json = @"连接服务器异常!";
    }
    else
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"message.plist" ofType:nil];
        NSDictionary *message = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSString *errStr = message[json];
        if ([NSString isNotBlank:errStr]) {
            json = errStr;
        }
    }
    errorBlock(json);
}


@end
