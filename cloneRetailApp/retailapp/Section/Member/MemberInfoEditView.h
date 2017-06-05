//
//  MemberInfoEditViewView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "CustomerVo.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "OptionPickerClient.h"
#import "IEditItemImageEvent.h"
#import "EditItemText2.h"
#import "DatePickerBox.h"
#import "SymbolNumberInputBox.h"

@class EditItemText, EditItemRadio, EditItemList, ItemTitle, EditItemImage2, EditItemText2;
@class MemberModule;
@interface MemberInfoEditView : BaseViewController<INavigateEvent, OptionPickerClient,IEditItemRadioEvent, IEditItemListEvent, IEditItemImageEvent, EditItemText2Delegate, DatePickerClient, SymbolNumberInputClient, UIActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//基本信息
@property (nonatomic, strong) IBOutlet ItemTitle *TitBaseInfo;
//会员卡号
@property (nonatomic, strong) IBOutlet EditItemText *txtCardCode;
//会员名
@property (nonatomic, strong) IBOutlet EditItemText *txtMemberName;
//性别
@property (nonatomic, strong) IBOutlet EditItemList *lsSex;
//手机号
@property (nonatomic, strong) IBOutlet EditItemText *txtmobile;
//卡类名称
@property (nonatomic, strong) IBOutlet EditItemList *lsKindCardName;
//余额
@property (nonatomic, strong) IBOutlet EditItemText2 *txtBalance;
//累计消费
@property (nonatomic, strong) IBOutlet EditItemText2 *txtConsumeAmount;
//累计赠送
@property (nonatomic, strong) IBOutlet EditItemText *txtPresentAmount;
//卡内积分
@property (nonatomic, strong) IBOutlet EditItemText2 *txtPoint;
//开卡日期
@property (nonatomic, strong) IBOutlet EditItemText *txtActiveDate;
//开卡门店
@property (nonatomic, strong) IBOutlet EditItemText *txtShop;
//卡状态
@property (nonatomic, strong) IBOutlet EditItemList *lsStatus;
//扩展信息
@property (nonatomic, strong) IBOutlet ItemTitle *TitExtendedInfo;
//身份证
@property (nonatomic, strong) IBOutlet EditItemText *txtCertificate;
//储值消费密码
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsNeedPwd;
//储值消费密码
@property (nonatomic, strong) IBOutlet EditItemList *lsPwd;
//生日
@property (nonatomic, strong) IBOutlet EditItemList *lsBirthday;
//微信
@property (nonatomic, strong) IBOutlet EditItemText *txtWeixin;
//地址
@property (nonatomic, strong) IBOutlet EditItemText *txtAddress;
//邮箱
@property (nonatomic, strong) IBOutlet EditItemText *txtEmail;
//邮编
@property (nonatomic, strong) IBOutlet EditItemList *lsZipcode;
//职业
@property (nonatomic, strong) IBOutlet EditItemText *txtJob;
//公司
@property (nonatomic, strong) IBOutlet EditItemText *txtCorporatiion;
//职务
@property (nonatomic, strong) IBOutlet EditItemText *txtPost;
//车牌号
@property (nonatomic, strong) IBOutlet EditItemText *txtCarNo;
//备注
@property (nonatomic, strong) IBOutlet EditItemText *txtMemo;
//会员头像
@property (nonatomic, strong) IBOutlet EditItemImage2 *imgMember;

@property (nonatomic, strong) IBOutlet UIButton *btnDel;

// 是否从【他的会员页面进入】 1：是
@property (nonatomic, strong) NSString *isFromSubCustomerList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
           customerId:(NSString *)customerId action:(int) action fromView:(int)fromViewTag;
/**
 *  设置回调block
 *
 *  @param block 修改会员消息后点击保存后回调前一个页面指定方法
 */
- (void)setCallBackBlock:(void (^)(id retObj))block;
@end
