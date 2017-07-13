//
//  LSAppUpdate.m
//  retailapp
//
//  Created by guozhi on 2016/10/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSAppUpdate.h"
#import "AFHTTPSessionManager.h"
//#import "AFHTTPRequestOperationManager.h"

@implementation LSAppUpdate
+ (void)appUpDateVersion:(UIViewController *)viewController {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *appCode = @"RETAIL_MANANGE_IOS";
    NSDictionary *param = @{
                                @"app_code" : appCode,
                                @"app_version" : appVersion,
                                @"platform_type" : @"2"
                                };
//     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = URL_APP_UPDATE;
    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dataInfo = responseObject[@"data"];
        if ([ObjectUtil isNotNull:dataInfo]) {
            NSDictionary *alertInfo = dataInfo[@"appUpdateInfo"];
            if ([ObjectUtil isNotNull:alertInfo]) {
                //是否提醒一次
                BOOL alertOneTime = [alertInfo[@"alertOneTime"] boolValue];
                //是否强制更新
                BOOL forceUpdate = [alertInfo[@"forceUpdate"] boolValue];
                //新版本号
                NSString *newestVersion = alertInfo[@"newestVersion"];
                NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                if ([appVersion compare:newestVersion options:NSNumericSearch] != NSOrderedAscending) {
                    return;
                }
                
                if (alertOneTime) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertInfo[@"title"]
                                                                                             message:alertInfo[@"message"]
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    
                    NSString *cancelButtonTitle = alertInfo[@"cancelButton"];
                    if (cancelButtonTitle) {
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                                               style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                                                                   if (forceUpdate) {
                                                                                       exit(0);
                                                                                   }
                                                                               }];
                        
                        [alertController addAction:cancelAction];
                    }
                    
                    NSString *confirmButtonTitle = alertInfo[@"confirmButton"];
                    
                    if (confirmButtonTitle) {
                        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle
                                                                                style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction *action) {
                                                                                  NSString *urlString = alertInfo[@"url"];
                                                                                  
                                                                                  NSURL *URL = [NSURL URLWithString:urlString];
                                                                                  
                                                                                  [[UIApplication sharedApplication] openURL:URL];
                                                                                  
                                                                                  if (forceUpdate) {
                                                                                      exit(0);
                                                                                  }
                                                                              }];
                        
                        [alertController addAction:confirmAction];
                    }
                    if (viewController) {
                        [viewController presentViewController:alertController animated:YES completion:nil];
                    }
                }
                
            }
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
//    [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dataInfo = responseObject[@"data"];
//        if ([ObjectUtil isNotNull:dataInfo]) {
//            NSDictionary *alertInfo = dataInfo[@"appUpdateInfo"];
//            if ([ObjectUtil isNotNull:alertInfo]) {
//                //是否提醒一次
//                BOOL alertOneTime = [alertInfo[@"alertOneTime"] boolValue];
//                //是否强制更新
//                BOOL forceUpdate = [alertInfo[@"forceUpdate"] boolValue];
//                //新版本号
//                NSString *newestVersion = alertInfo[@"newestVersion"];
//                NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//                if ([appVersion compare:newestVersion options:NSNumericSearch] != NSOrderedAscending) {
//                    return;
//                }
//
//                if (alertOneTime) {
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertInfo[@"title"]
//                                                                                             message:alertInfo[@"message"]
//                                                                                      preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    NSString *cancelButtonTitle = alertInfo[@"cancelButton"];
//                    if (cancelButtonTitle) {
//                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
//                                                                               style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                                                                                   if (forceUpdate) {
//                                                                                       exit(0);
//                                                                                   }
//                                                                               }];
//                        
//                        [alertController addAction:cancelAction];
//                    }
//                    
//                    NSString *confirmButtonTitle = alertInfo[@"confirmButton"];
//                    
//                    if (confirmButtonTitle) {
//                        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle
//                                                                                style:UIAlertActionStyleDefault
//                                                                              handler:^(UIAlertAction *action) {
//                                                                                  NSString *urlString = alertInfo[@"url"];
//                                                                                  
//                                                                                  NSURL *URL = [NSURL URLWithString:urlString];
//                                                                                  
//                                                                                  [[UIApplication sharedApplication] openURL:URL];
//                                                                                  
//                                                                                  if (forceUpdate) {
//                                                                                      exit(0);
//                                                                                  }
//                                                                              }];
//                        
//                        [alertController addAction:confirmAction];
//                    }
//                    if (viewController) {
//                        [viewController presentViewController:alertController animated:YES completion:nil];
//                    }
//                }
//
//            }
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    

}

@end
