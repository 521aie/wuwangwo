//
//  MessageBox.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-15.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MessageBox.h"
#import "SystemUtil.h"

static UIAlertView *alertView;

static MessageBox *messageBox = nil;

@implementation MessageBox

+ (void)initMessageBox
{
    if (messageBox == nil) {
        messageBox = [[MessageBox alloc]init];
    }
}

+ (void)show:(NSString *)message client:(id<MessageBoxClient>)client;
{
    messageBox->client = client;
    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:messageBox cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
    [alertView show];
}

+ (void)show:(NSString *)message btnName:(NSString *)btnName client:(id<MessageBoxClient>)client
{
    messageBox->client = client;
    alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:messageBox cancelButtonTitle:@"取消"  otherButtonTitles:btnName, nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([messageBox->client respondsToSelector:@selector(cancel)]) {
            [messageBox->client cancel];
        }
    } else if (buttonIndex == 1) {
        [messageBox->client confirm];
    }
}

@end
