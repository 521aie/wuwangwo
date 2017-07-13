
//
//  AppDelegate.m
//  retailapp
//
//  Created by hm on 15/7/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "SystemUtil.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ReailAppDefine.h"
#import "JPUSHService.h"
#import "ReailAppDefine.h"
#import "MobClick.h"
#import "HomeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LSAlipayUtil.h"
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "AFNetworkActivityIndicatorManager.h"
#import "LSAppUpdate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "TDFNetworkHttpieLogger.h"
#import <TDFSobotChatModule/TDFSobotChat.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //设置状态栏的网络指示器
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [self addBgImageView];
    [self configUMengSet];
    //极光推送
    [self initPushService:launchOptions];
    //错误收集统计
    [self initSobotChatModule];
    [self configCrashAnalytics];
    [self configNavigationController];
    [self configNavigationBar];
    //debug模式下不报更新的提示
#ifndef DEBUG
    [LSAppUpdate appUpDateVersion:self.window.rootViewController];
#endif

#if !(ENTERPRISE || RELEASE)
    TDFNetworkHttpieLogger *networkLogger = [TDFNetworkHttpieLogger sharedLogger];
    networkLogger.level = TDFLoggerLevelDebug;
    
    networkLogger.filterPredicate = [NSPredicate predicateWithBlock:^BOOL(NSURLRequest *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return YES;
    }];
    [networkLogger startLogging];
#endif
    
    return YES;
}

#pragma mark - 配置导航控制器
- (void)configNavigationController {
    HomeViewController *vc = [HomeViewController controllerFromStroryboard:@"Main" storyboardId:nil];;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = self.navigationController;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)configNavigationBar {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBarTintColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.00]];
    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}];
}


//在APPdelegate.m中增加下面的系统回调配置，注意如果同时使用微信支付、支付宝等其他需要改写回调代理的SDK，请在if分支下做区分，否则会影响 分享、登录的回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 判断是否是来自友盟的回调，如果不是，在判断其他平台的回调
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [LSAlipayUtil payFinish:resultDic];
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }
        return YES;

    }
    return result;
}


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [LSAlipayUtil payFinish:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}


//注册成功回调方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    
    TDFLogDebug(@"---Token--%@", deviceToken);
    [[ZCLibClient getZCLibClient] setToken:deviceToken];
    
#if DEBUG
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@", deviceToken];
#endif
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [JPUSHService resetBadge];
    [self cancelAllNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [JPUSHService resetBadge];
    [self cancelAllNotifications];
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    [self jumpActionWithApplicationState:application.applicationState];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    TDFLogDebug(@"Userinfo %@",notification.request.content.userInfo);
    //功能：可设置是否在应用内弹出通知
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

//iOS 10  点击推送消息后回调 点击通知栏
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    TDFLogDebug(@"Userinfo %@",response.notification.request.content.userInfo);
    
    //点击通知 直接跳转到调天页面
    [TDFSobotChat shareInstance].startChatImmediately = YES;
    [self cancelAllNotifications];
}


- (void)cancelAllNotifications {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10")) {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    }else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
}

- (void)jumpActionWithApplicationState:(UIApplicationState)applicationState {
    [self cancelAllNotifications];
    if(applicationState == UIApplicationStateActive){
        //询问是否查看未读消息
    }else {
        //通过点击通知栏 直接跳转
        [TDFSobotChat shareInstance].startChatImmediately = YES;
    }
}

- (void)initPushService:(NSDictionary *)launchOptions
{
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                            categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:Jpush_Key
                          channel:Jpush_CHANNEL
                 apsForProduction:Jpush_PRODUCTION
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}


- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    TDFLogDebug(@"Regist fail%@",error);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        //        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSLog(@"notification ---->%@", notification);
    [JPUSHService resetBadge];
    NSDictionary * userInfo = [notification userInfo];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    if ([[extras objectForKey:@"type"] isEqualToString:@"1"]) {
        //公告通知
        [[Platform Instance] saveKeyWithVal:NOTICE_SMS withVal:@"1"];
    }else{
        [[Platform Instance] saveKeyWithVal:NOTICE_SMS withVal:@"0"];
    }
    if ([[extras objectForKey:@"type"] isEqualToString:@"2"]) {
        //过期提醒  
        [[Platform Instance] saveKeyWithVal:OVERDUE_ALERT withVal:@"1"];
    }else{
        [[Platform Instance] saveKeyWithVal:OVERDUE_ALERT withVal:@"0"];
    }
    if ([[extras objectForKey:@"type"] isEqualToString:@"3"]) {
        //库存预警
        [[Platform Instance] saveKeyWithVal:STOCK_WARNNING withVal:@"1"];
    }else{
        [[Platform Instance] saveKeyWithVal:STOCK_WARNNING withVal:@"0"];
    }
    if ([[extras objectForKey:@"type"] isEqualToString:@"4"]) {//操作通知
        if ([[extras objectForKey:@"businessType"] isEqualToString:@"1"]) {
            //一键上架
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_System_Message_Push object:nil];
        }
         [[Platform Instance] saveKeyWithVal:NOTICE_SYSTEM withVal:@"1"];
    } else {
         [[Platform Instance] saveKeyWithVal:NOTICE_SYSTEM withVal:@"0"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Message_Push object:nil];
}

// 配置错误收集
- (void)configCrashAnalytics {
    [Fabric with:@[[Crashlytics class]]];
}

#pragma mark - 配置友盟分享
- (void)configUMengSet {
    
    // 友盟统计
    UMConfigInstance.appKey = UmengAppKey;
    UMConfigInstance.channelId = AppChannelId;
    [MobClick startWithConfigure:UMConfigInstance];
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#else
    [MobClick setLogEnabled:NO];
#endif
    
    [MobClick setCrashReportEnabled:NO];
    
    // 友盟分享
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengAppKey];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APP_ID appSecret:WX_APP_SECERT redirectURL:nil];
    
#ifdef DEBUG
    [[UMSocialManager defaultManager] openLog:YES];
#else
    [[UMSocialManager defaultManager] openLog:NO];
#endif
}

/*
 
 customInfo[@"店铺名字"] = self.chatUserInfoModel.shopName;
 customInfo[@"店铺编号"] = self.chatUserInfoModel.shopCode;
 customInfo[@"entityId"] = self.chatUserInfoModel.entityId;
 customInfo[@"登录账号"] = self.chatUserInfoModel.userName;
 customInfo[@"手机号"] = self.chatUserInfoModel.phone;
 
 */
#pragma mark - 配置智齿设置
- (void)initSobotChatModule {
    
    [[TDFSobotChat shareInstance] initSobotChatWithAppKey:ZC_APP_KEY];
    
    TDFSobotCustomerModel *customerModel = [[TDFSobotCustomerModel alloc] init];
    customerModel.skillSetName = @"在线客服";
    customerModel.skillSetId = nil;//@"a752c85aa01e456b9d7442eb26a36aec";
    [TDFSobotChat shareInstance].chatCustomerModel = customerModel;
}



// 添加背景图片
- (void)addBgImageView {
    
    UIImage *image = [Platform getBgImage];
    UIImageView *imgv = [[UIImageView alloc] initWithImage:image];
    imgv.frame = [UIScreen mainScreen].bounds;
    [self.window addSubview:imgv];
    self.bgImageView = imgv;
}
@end
