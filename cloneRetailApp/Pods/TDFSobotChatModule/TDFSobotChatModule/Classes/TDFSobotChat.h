//
//  TDFSobotChat.h
//  TDFSobotChatModule
//
//  Created by chaiweiwei on 2017/4/10.
//  Copyright © 2017年 chaiweiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSBadgeView.h"
#import <SobotKit/SobotKit.h>
#import "TDFLogger.h"
#import "TDFSobotUserInfoModel.h"
#import "TDFSobotCustomerModel.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface TDFSobotChat : NSObject

+ (instancetype)shareInstance;

/**
 用户
 */
@property (nonatomic,strong) TDFSobotUserInfoModel *chatUserInfoModel;
/**
 客服 已经取消
 */
@property (nonatomic,strong) TDFSobotCustomerModel *chatCustomerModel;
/**
 展示未读数的view
 */
@property (nonatomic, strong) JSBadgeView *badgeView;
/**
 第一次启动的时候 立刻跳转到聊天页面
 */
@property (nonatomic, assign) BOOL startChatImmediately;
/**
 初始化智齿SDK
 */
- (void)initSobotChatWithAppKey:(NSString *)appkey;
/**
 进入聊天页面
 */
- (void)startTDFChatView;
/**
 移除当前账户 推送与消息通道
 */
- (void)removeCurrentAccount;

@end
