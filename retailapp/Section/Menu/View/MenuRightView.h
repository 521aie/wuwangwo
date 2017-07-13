//
//  MenuRightView.h
//  retailapp
//
//  Created by taihangju on 16/6/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,MRSelectItemType){
    MRChangePassword = 0,     // 修改密码
    MRChangeBackgroundPhoto,  // 更改背景图片
    MRSystemNotification,     // 系统通知
    MRMessageCenter,          // 消息中心
    MRAbout,                  // 关于
    MRSignOut                 // 登出
};

@protocol MenuRightViewDelegate;
@interface MenuRightView : UIView

/**
 *  初始化MenuRightView对象
 *
 *  @param delegate 代理对象要求遵循MenuRightViewDelegate协议
 *
 *  @return 初始化成功的MenuRightView对象
 */
+ (MenuRightView *)menuRightView:(id<MenuRightViewDelegate>)delegate;

// 刷新显示当前登录用户信息的view, 更新最新的用户信息
- (void)refreshUserInfo;
- (void)reloadData;
@end

@protocol MenuRightViewDelegate <NSObject>
/**
 *  MenuRightView对象中cell点击后，发送该消息给实现了该协议的代理对象
 *
 *  @param leftView MenuRightView 对象
 *  @param type     点击项对应的类型，指定跳转到对应的下一级控制器
 */
- (void)rightMenu:(MenuRightView *)leftView selectType:(MRSelectItemType)type;

@end


@interface MenuRightTabHeader : UITableViewHeaderFooterView

@end
