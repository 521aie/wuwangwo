//
//  SystemService.h
//  retailapp
//
//  Created by hm on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemService : NSObject

- (void)editUserPass:(NSString*)oldPassword withNewPassword:(NSString*)newPassword completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

@end
