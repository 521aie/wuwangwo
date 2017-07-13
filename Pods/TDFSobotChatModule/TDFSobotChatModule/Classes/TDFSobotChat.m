//
//  TDFSobotChat.m
//  TDFSobotChatModule
//
//  Created by chaiweiwei on 2017/4/10.
//  Copyright © 2017年 chaiweiwei. All rights reserved.
//

#import "TDFSobotChat.h"
#import <UIViewController+TopViewController.h>
#import "IQKeyboardManager.h"
#import "TDFLogger.h"
#import <UserNotifications/UserNotifications.h>
#import <UIDevice-Hardware.h>

@interface TDFSobotChat (){
    BOOL   _chatPageActive;
}

/**
 聊天页面是否初始化过
 */
@property (nonatomic, assign) BOOL chatViewIsExist;

@property (nonatomic, copy) NSString *sobotAppKey;

@property (nonatomic, assign) NSInteger alertCount;

@end

@implementation TDFSobotChat

+ (instancetype)shareInstance
{
    static TDFSobotChat *sobot = nil;
    static dispatch_once_t onceTime;
    dispatch_once(&onceTime, ^{
        if (!sobot) {
            sobot = [[TDFSobotChat alloc] init];
        }
    });
    return sobot;
}

#pragma mark 智齿SDK初始化
- (void)initSobotChatWithAppKey:(NSString *)appkey {
    self.sobotAppKey = appkey;
    
    [[ZCLibClient getZCLibClient].libInitInfo setAppKey:self.sobotAppKey];
    //
    [[ZCLibClient getZCLibClient] setAutoNotification:YES];
#if DEBUG
    [[ZCLibClient getZCLibClient] setIsDebugMode:YES];
#else
    [[ZCLibClient getZCLibClient] setIsDebugMode:NO];
#endif
    [ZCLibClient setZCLibUncaughtExceptionHandler];
    
    [self addNotificationCenterEnderBackground];
}

- (void)initSobotSDK {
    ZCLibInitInfo *initInfo = [ZCLibInitInfo new];
    
    initInfo.appKey = self.sobotAppKey;
    //客服设置
    [self customSobotCustomerInfo:initInfo];
    //用户参数设置
    [self customSobotUserInfo:initInfo];
    
#if DEBUG
    // 测试模式
    [ZCSobot setShowDebug:YES];
#else
    [ZCSobot setShowDebug:NO];
#endif
    
    [[ZCLibClient getZCLibClient] setLibInitInfo:initInfo];
}

- (void)addNotificationCenterEnderBackground{
    //监听是否重新进入程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark 进入聊天页面
- (void)startTDFChatView {
    
    //当topview是chatview的时候不新建chatview
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = [rootVC tdf_topViewController];
    
    if([topVC isKindOfClass:[ZCUIChatController class]]) {
        TDFLogDebug(@"ZCUIChatController in top");
        return;
    }
    
    //智齿与IQKeyboardManager 冲突
    [IQKeyboardManager sharedManager].enable = NO;
    
    _chatPageActive = YES;

    [self setUnreadNumber:0];

    [self initSobotSDK];

    // 启动
    [ZCSobot startZCChatView:[self customerSobotChatViewUI] with:topVC pageBlock:^(ZCUIChatController *object, ZCPageBlockType type) {
        // 点击返回
        if(type==ZCPageBlockGoBack){
            [IQKeyboardManager sharedManager].enable = YES;
        }
        
        // 页面UI初始化完成，可以获取UIView，自定义UI
        if(type==ZCPageBlockLoadFinish){
            [object.backButton setTitle:@" 返回" forState:UIControlStateNormal];
        }
    } messageLinkClick:nil];

    //实时检查未读数
    [ZCLibClient getZCLibClient].receivedBlock=^(id obj,int unRead){
        TDFLogDebug(@"未读消息数量：\n%d,%@",unRead,obj);
        if(unRead>0 || !_chatPageActive){
            self.alertCount ++;
            if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
                [self registerNotification:(NSString *)obj];
            }else{
                [self registerLocalNotificationInOldWay:(NSString *)obj];
            }
        }
        [self setUnreadNumber:unRead];
    };
}
#pragma 聊天页面参数
- (void)customSobotCustomerInfo:(ZCLibInitInfo *)initInfo{
    //取消技术组
//    initInfo.skillSetName = self.chatCustomerModel.skillSetName;
//    initInfo.skillSetId = self.chatCustomerModel.skillSetId;
}

- (void)customSobotUserInfo:(ZCLibInitInfo*)initInfo{
    NSMutableDictionary *customInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    
    if(self.chatUserInfoModel.userID.length > 0) {
        initInfo.avatarUrl = self.chatUserInfoModel.avatarUrl;
        initInfo.userId = self.chatUserInfoModel.userID;
        initInfo.userSex = self.chatUserInfoModel.sex;
        initInfo.nickName = self.chatUserInfoModel.shopCode;
        initInfo.phone = self.chatUserInfoModel.phone;
        
        customInfo[@"店铺名字"] = self.chatUserInfoModel.shopName;
        customInfo[@"店铺编号"] = self.chatUserInfoModel.shopCode;
        customInfo[@"entityId"] = self.chatUserInfoModel.entityId;
        customInfo[@"登录账号"] = self.chatUserInfoModel.userName;
        customInfo[@"手机号"] = self.chatUserInfoModel.phone;

    }else {
        initInfo.userId = @"";
    }
    customInfo[@"应用版本"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    customInfo[@"用户系统"] = [NSString stringWithFormat:@"%@ - %@", [UIDevice currentDevice].platformString, [UIDevice currentDevice].systemVersion];
    initInfo.customInfo = [customInfo copy];
}

-(ZCKitInfo *)customerSobotChatViewUI{
    ZCKitInfo *kitInfo = [[ZCKitInfo alloc] init];
    kitInfo.customBannerColor = [UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.00];
    kitInfo.socketStatusButtonBgColor = kitInfo.customBannerColor;
    return kitInfo;
}

#pragma mark 方法
- (void)setUnreadNumber:(int)unRead{
    if (unRead < 10) {
        self.badgeView.badgeText = [NSString stringWithFormat:@"%i",unRead];
    }else {
        self.badgeView.badgeText = @"...";
    }
    
    self.badgeView.hidden = unRead == 0;
}

- (void)setStartChatImmediately:(BOOL)startChatImmediately {
    _startChatImmediately = startChatImmediately;
    if(self.chatViewIsExist && startChatImmediately) {
        //当聊天页面已经存在 并且需要立刻展示 直接展示 否则等页面初始化完毕的时候再展示chatview
        [self startTDFChatView];
    }
}

- (void)removeCurrentAccount {
    self.chatUserInfoModel = nil;
    [[ZCLibClient getZCLibClient] removePush:^(NSString *uid, NSData *token, NSError *error) {
        if((uid==nil &&  token==nil) || error!=nil){
            // 移除失败，可设置uid或token(uid可不设置)后再调用
            TDFLogDebug(@"移除失败");
        }else{
            TDFLogDebug(@"移除成功");
        }
    }];
}

#pragma mark set get
- (void)setBadgeView:(JSBadgeView *)badgeView {
    _badgeView = badgeView;
    self.chatViewIsExist = YES;
    if(self.startChatImmediately) {
        [self startTDFChatView];
        self.startChatImmediately = NO;
    }
}

- (TDFSobotUserInfoModel *)chatUserInfoModel {
    if(!_chatUserInfoModel) {
        _chatUserInfoModel = [[TDFSobotUserInfoModel alloc] init];
    }
    return _chatUserInfoModel;
}

- (TDFSobotCustomerModel *)chatCustomerModel {
    if(!_chatCustomerModel) {
        _chatCustomerModel = [[TDFSobotCustomerModel alloc] init];
    }
    return _chatCustomerModel;
}

#pragma mark 本地通知
//使用 iOS 10 UNNotification 本地通知
-(void)registerNotification:(NSString *)message{
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    //    content.title = [NSString localizedUserNotificationStringForKey:@"新消息" arguments:nil];
    content.body = message;
    content.sound = [UNNotificationSound defaultSound];
    
    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:1 repeats:NO];
    
    NSString *identifier = [NSString stringWithFormat:@"www.sobot.com%li",(long)self.alertCount];

    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        //        NSLog(@"%@",error);
        //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
        //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //        [alert addAction:cancelAction];
        //        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)registerLocalNotificationInOldWay:(NSString *) message {
    // ios8后，需要添加这个注册，才能得到授权
    // if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    // UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    // UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
    // categories:nil];
    // [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    // // 通知重复提示的单位，可以是天、周、月
    // }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody = message;
    notification.applicationIconBadgeNumber = 0;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSString *identifier = [NSString stringWithFormat:@"www.sobot.com%li",(long)self.alertCount];
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:identifier forKey:@"pushType"];
    notification.userInfo = userDict;
    // 通知重复提示的单位，可以是天、周、月
    notification.repeatInterval = 0;
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - 监听 
- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    _chatPageActive = NO;
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    _chatPageActive = YES;
    TDFLogDebug(@"进入到前台！");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
