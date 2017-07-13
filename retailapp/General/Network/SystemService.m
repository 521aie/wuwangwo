//
//  SystemService.m
//  retailapp
//
//  Created by hm on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SystemService.h"
#import "SignUtil.h"

@implementation SystemService

- (void)editUserPass:(NSString*)oldPassword withNewPassword:(NSString*)newPassword completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:[SignUtil convertPassword:oldPassword] forKey:@"oldPwd"];
    [param setValue:[SignUtil convertPassword:newPassword] forKey:@"newPwd"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"password/change"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

@end
