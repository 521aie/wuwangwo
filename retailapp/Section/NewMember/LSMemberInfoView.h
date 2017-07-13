//
//  LSMemberInfoView.h
//  retailapp
//
//  Created by byAlex on 16/9/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LSMemberInfoViewDelegate;
// 二维火会员信息
@interface LSMemberInfoView : UIView

@property (nonatomic ,strong) UIImageView *headImageView;/*头像 <*/
@property (nonatomic ,strong) UILabel *headLabel;/* 主要信息，"人名(性别)"<*/
@property (nonatomic ,strong) UILabel *phoneLabel;/* 电话<*/
@property (nonatomic ,strong) UILabel *birthdayLabel;/* <生日label*/
@property (nonatomic ,strong) UILabel *statusLabel;/* <状态label*/
@property (nonatomic ,strong) UIView *separateLine;/*<底部分割线>*/
@property (nonatomic ,strong) UIButton *changeButton;/*<手机号修改button>*/

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LSMemberInfoViewDelegate>)delegate;
//- (void)fillMemberInfo:(id)obj phone:(NSString *)phoneStr;
- (void)fillMemberInfo:(id)obj cards:(NSArray *)cardArray cardTypes:(NSArray *)typeArray phone:(NSString *)phoneStr;
- (void)showPhoneNumChangeButton;
@end


@protocol LSMemberInfoViewDelegate <NSObject>

@optional;
// 卡状态允许多行显示，高度不固定，需要调整整个界面的布局
- (void)memberInfoViewHeightChaged;
// 点击手机号码 “修改” 显示提示信息
- (void)memberInfoViewShowPhoneNumChangeNotice;
@end
