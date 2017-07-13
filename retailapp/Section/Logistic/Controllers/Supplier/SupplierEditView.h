//
//  SupplierEditView.h
//  retailapp
//
//  Created by hm on 15/12/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class SupplyVo;
typedef void(^EditSupplyHandler)(SupplyVo *supplyVo, NSInteger action);

@class LSEditItemTitle,LSEditItemText,LSEditItemList;
@interface SupplierEditView : LSRootViewController<UIActionSheetDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) LSEditItemTitle *baseTitle;
//供应商名称
@property (nonatomic, strong) LSEditItemText *txtSupplyName;
//供应商简称
@property (nonatomic, strong) LSEditItemText *txtShorName;
//供应商编号
@property (nonatomic, strong) LSEditItemText *txtCode;
//供应商类别
@property (nonatomic, strong) LSEditItemList *lsSupplyType;
//联系人
@property (nonatomic, strong) LSEditItemText *txtRelation;
//联系电话
@property (nonatomic, strong) LSEditItemText *txtMobile;
//手机号
@property (nonatomic, strong) LSEditItemText *txtPhone;
//微信号
@property (nonatomic, strong) LSEditItemText *txtWechat;
//邮箱
@property (nonatomic, strong) LSEditItemText *txtMail;
//传真
@property (nonatomic, strong) LSEditItemText *txtFax;
//联系地址
@property (nonatomic, strong) LSEditItemText *txtAddress;
//账户信息
@property (nonatomic, strong) LSEditItemTitle *infoTitle;
//开户行
@property (nonatomic, strong) LSEditItemText *txtBank;
//银行账号
@property (nonatomic, strong) LSEditItemText *txtBankAccount;
//户名
@property (nonatomic, strong) LSEditItemText *txtUserName;
@property (nonatomic, strong) UIView *delView;

//页面入口
- (void)loadDataWithId:(NSString *)supplyId withIsWarehouse:(BOOL)isWarehouse withAction:(NSInteger)action callBack:(EditSupplyHandler)handler;

@end
