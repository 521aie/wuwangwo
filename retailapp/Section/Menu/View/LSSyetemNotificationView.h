//
//  LSSyetemNotificationView.h
//  retailapp
//
//  Created by guozhi on 2016/11/3.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LSSystemNotificationViewDelegate;
@interface LSSyetemNotificationView : UIView
@property (nonatomic, weak) id<LSSystemNotificationViewDelegate> delegate;
/** 通知标题 */
@property (nonatomic, strong) UILabel *lblTitle;
/** 小喇叭 */
@property (nonatomic, strong) UIImageView *imgSmallHorn;
/** 新消息标志 */
@property (nonatomic, strong) UIImageView *imgNewsStatus;
+ (instancetype)systemNotificationView:(CGFloat)y;
@end

@protocol LSSystemNotificationViewDelegate <NSObject>
- (void)systemNotificationViewDidEndClick:(LSSyetemNotificationView *)systemNotification;
@end
