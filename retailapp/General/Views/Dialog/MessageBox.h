//
//  MessageBox.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-15.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AppController.h"

@protocol MessageBoxClient;
@interface MessageBox : NSObject<UIAlertViewDelegate>
{
    id<MessageBoxClient> client;
}

+ (void)initMessageBox;

+ (void)show:(NSString *)message client:(id<MessageBoxClient>)client;

+ (void)show:(NSString *)message btnName:(NSString *)btnName client:(id<MessageBoxClient>)client;

@end


@protocol MessageBoxClient <NSObject>

@required
- (void)confirm;

@optional
- (void)cancel;

@end