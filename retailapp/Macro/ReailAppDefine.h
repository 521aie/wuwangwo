//
//  ReailAppDefine.h
//  retailapp
//
//  Created by taihangju on 16/6/3.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef ReailAppDefine_h
#define ReailAppDefine_h


#if DEBUG || DAILY || PRE

#define DLog(fmt, ...)      NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define DLogCGRect(rect)    NSLog(@"%@\n", NSStringFromCGRect(rect))
#define DLogCGSize(size)    NSLog(@"%@\n",NSStringFromCGPoint(size));
#define DLogCGPoint(point)  NSLog(@"%@\n",NSStringFromCGPoint(point));

//#define UMengAnalyticsKey     @"58982b784ad156728a0010b0"

#else

#define DLog(...)
#define DLogCGRect(rect)
#define DLogCGSize(size)
#define DLogCGPoint(point)

//#define UMengAnalyticsKey     @"5750e740e0f55a3006002885"

#endif

#define kScreenWidth       CGRectGetWidth([UIScreen mainScreen].bounds)

#endif /* ReailAppDefine_h */


/*================================通知key===================================*/

// 类XBStepper 中注册使用的key, 用以通知新值的变化
#define  XBStepperNotificationKey  @"XBStepperNotification"

/*==================================JPUSHService===========================*/
#if RELEASE || DEBUG
#define Jpush_Key  @"db02a8482078cd8fa81f8e3c"
#else
#define Jpush_Key  @"d41fefc81eb84c8905830366"
#endif

#if DEBUG || DAILY || PRE

#define Jpush_PRODUCTION  0
#define Jpush_CHANNEL         @"Develop channel"

#else

#define Jpush_PRODUCTION 1
#define Jpush_CHANNEL         @"Publish channel"
#endif
