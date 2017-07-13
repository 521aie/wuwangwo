//
//  AlertBox.m
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertBox.h"
#import <QuartzCore/QuartzCore.h>
#import "SystemUtil.h"

static UIAlertView *alertView;

static AlertBox *alertBox = nil;

@implementation AlertBox
+ (void)initAlertBox
{
    if (alertBox == nil) {
        alertBox = [[AlertBox alloc] init];
    }
}

+ (void)show:(NSString *)message
{
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView = nil;
    }
    
    alertBox->client = nil;
    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:alertBox cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)show:(NSString *)message client:(id<AlertBoxClient>)client
{
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView = nil;
    }
    
    alertBox->client = client;
    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:alertBox cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)showBox:(NSString *)message client:(id<AlertBoxClient>)client
{
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView = nil;
    }
    
    alertBox->client = client;
    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:alertBox cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertBox->client != nil && [alertBox->client respondsToSelector:@selector(understand)]) {
            [alertBox->client understand];
        }
        alertView = nil;
    }else if(buttonIndex == 1){
        if (alertBox->client != nil && [alertBox->client respondsToSelector:@selector(confirm)]) {
            [alertBox->client confirm];
        }
        alertView = nil;
    }
}

@end
