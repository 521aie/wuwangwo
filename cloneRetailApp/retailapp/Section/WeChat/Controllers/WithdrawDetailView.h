//
//  WithdrawDetailView.h
//  retailapp
//
//  Created by Jianyong Duan on 16/1/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawCheckVo.h"
#import "NavigateTitle2.h"
#import "EditItemText.h"
#import "EditItemCertId.h"
#import "ITreeItem.h"

@interface WithdrawDetailView : BaseViewController


typedef void(^WithdrawDetail)(id<ITreeItem> companion);

@property (nonatomic,copy) WithdrawDetail withdrawDetailBlock;

- (void)loadWithdrawDetail:(NSInteger)viewType withIsPush:(BOOL)isPush callBack:(WithdrawDetail)callBack;

//input
@property (nonatomic, strong) WithdrawCheckVo *checkVo;

// outlet
@property (nonatomic,weak) IBOutlet UIView* titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//姓名/名称
@property (weak, nonatomic) IBOutlet UILabel *lblName;

//手机号码
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;

//提现金额（元）
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;

//提现方式
@property (weak, nonatomic) IBOutlet UILabel *lblWithdrawType;

//持卡人
@property (weak, nonatomic) IBOutlet UILabel *lblCardholder;

//开户行
@property (weak, nonatomic) IBOutlet UILabel *lblBank;

//银行卡号
@property (weak, nonatomic) IBOutlet UILabel *lblCardNo;

//证件号码
@property (weak, nonatomic) IBOutlet UILabel *lblCertificateNo;

//证件图片
@property (weak, nonatomic) IBOutlet EditItemCertId *itemCertIdImg;

//申请时间
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

//审核状态
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

//审核不通过原因
@property (weak, nonatomic) IBOutlet EditItemText *txtReason;

@property (weak, nonatomic) IBOutlet UIView *viewOper;

//判断是从【提现记录】（1）来，跟【提现审核】区分
@property (nonatomic) int fromRecordView;

@property (weak, nonatomic) IBOutlet UIButton *buttonRefuse;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfig;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
//审核不通过
- (IBAction)refuseWithdrawClick:(id)sender;

//审核通过
- (IBAction)configWithdrawClick:(id)sender;

//取消
- (IBAction)cancelWithdrawClick:(id)sender;

@end
