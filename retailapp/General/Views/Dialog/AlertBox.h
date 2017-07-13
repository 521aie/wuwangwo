//
//  AlertBox.h
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertBoxClient <NSObject>

@required
- (void)understand;
@optional
- (void)confirm;
@end

@interface AlertBox : NSObject
{
    __weak id<AlertBoxClient> client;
}

+ (void)initAlertBox;

+ (void)show:(NSString *)message;

+ (void)show:(NSString *)message client:(id<AlertBoxClient>)client;

//显示确认、取消按钮
+ (void)showBox:(NSString *)message client:(id<AlertBoxClient>)client;
@end
