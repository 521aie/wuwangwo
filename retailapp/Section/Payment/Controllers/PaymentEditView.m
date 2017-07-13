//
//  PaymentEditView.m
//  retailapp
//
//  Created by guozhi on 16/5/15.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_LST_ACCOUNT_TYPE 1
#define TAG_LST_BANK_NAME 2
#define TAG_LST_BANK_CITY 3
#define TAG_LST_BANK_BRANCH 4
#define TAG_LST_BANK 5
#define TAG_LST_BANK_PROVINCE 6
#define TAG_LST_ACCOUNT_TYPE_OF_ACCOUNT 7
#define TAG_LST_PROVINCE 8
#define TAG_LST_CITY 9

#import "PaymentEditView.h"
#import "XHAnimalUtil.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "OptionPickerBox.h"
#import "UIHelper.h"
#import "ShopInfoVO.h"
#import "AlertBox.h"
#import "NameItemVO.h"
#import "SymbolNumberInputBox.h"
#import "SelectItemList.h"
#import "SystemUtil.h"
#import "PaymentNoteView.h"
#import "SystemUtil.h"
#import "PaymentView.h"
#import "PaymentTypeView.h"
#import "LSEditItemTitle.h"
#import "LSPaymentStatusController.h"
#import "DateUtils.h"
#import "PaymentView.h"

@interface PaymentEditView ()<IEditItemListEvent,SymbolNumberInputClient,OptionPickerClient>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) LSEditItemList *lstAccountType;
@property (strong, nonatomic) LSEditItemList *lstBankName;
@property (strong, nonatomic) LSEditItemList *lstBankProvince;
@property (strong, nonatomic) LSEditItemList *lstBankCity;
@property (strong, nonatomic) LSEditItemList *lstBankBranch;
@property (strong, nonatomic) LSEditItemText *txtAccountName;
@property (strong, nonatomic) LSEditItemList *lstBank;
@property (strong, nonatomic) UIButton *btnCheck;
@property (strong, nonatomic) UILabel *lblInfo;
@property (nonatomic, strong) ShopInfoVO *shopInfoVO;
@property (nonatomic, strong) NSString *bankName; //记录银行代码
@property (nonatomic, strong) NSString *cityNo; //记录城市代码
@property (nonatomic, strong) NSString *bankSubNo; //开户银行支行代码
@property (nonatomic, strong) NSString *provinceNo;
@property (nonatomic, strong) NSMutableDictionary *param;
/** 收款账户 */
@property (strong, nonatomic) LSEditItemTitle *titleCollectionAcoount;
/** 店铺信息 */
@property (strong, nonatomic) LSEditItemTitle *titleShopInfo;
/** 组织机构代码 */
@property (strong, nonatomic) LSEditItemText *txtOrgCode;
/** 开户人证件类型 */
@property (strong, nonatomic) LSEditItemList *lstAccountTypeOfAccount;
/** 开户人证件号码 */
@property (strong, nonatomic) LSEditItemText *txtAcctountNumberOfAccount;
/** 开户人手机 */
@property (strong, nonatomic) LSEditItemText *txtAccountMobileOfAccount;
/** 所在省份 */
@property (strong, nonatomic) LSEditItemList *lstProvince;
/** 所在城市 */
@property (strong, nonatomic) LSEditItemList *lstCity;
/** 详细地址 */
@property (strong, nonatomic) LSEditItemText *txtAddress;
/** 负责人姓名 */
@property (strong, nonatomic) LSEditItemText *txtName;
/** 负责人手机号 */
@property (strong, nonatomic) LSEditItemText *txtMobile;
/** 当前省份选中 */
@property (nonatomic, strong) NSString *currentProvinceId;
@property (strong, nonatomic) UILabel *lblWarning;
@end

@implementation PaymentEditView
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"收款账户" leftPath:Head_ICON_BACK rightPath:nil];
    [self setupScrollView];
    [self initMainView];
    [self initNotification];
    [self loadData];
    [self configHelpButton:HELP_PAYMENT_ACCOUNT];
    
    
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, self.view.ls_width, self.view.ls_height - kNavH)];
    self.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.scrollView];
    
    [self setupInfoView];
    self.titleCollectionAcoount = [LSEditItemTitle editItemTitle];
    [self.titleCollectionAcoount configTitle:@"收款账户"];
    [self.scrollView addSubview:self.titleCollectionAcoount];
    
    
    self.lstAccountType = [LSEditItemList editItemList];
    [self.scrollView addSubview:self.lstAccountType];
    
    self.txtOrgCode = [LSEditItemText editItemText];
    [self.scrollView addSubview:self.txtOrgCode];
    
    self.lstBankName = [LSEditItemList editItemList];
    [self.scrollView addSubview:self.lstBankName];
    
    self.lstBankProvince = [LSEditItemList editItemList];
    [self.scrollView addSubview:self.lstBankProvince];
    
    self.lstBankCity = [LSEditItemList editItemList];
    [self.scrollView addSubview:self.lstBankCity];
    
    self.lstBankBranch = [LSEditItemList editItemList];
    [self.scrollView addSubview:self.lstBankBranch];
    
    self.txtAccountName = [LSEditItemText editItemText];
    [self.scrollView addSubview:self.txtAccountName];
    
    self.lstAccountTypeOfAccount = [LSEditItemList editItemList];
    [self.scrollView addSubview:self.lstAccountTypeOfAccount];
    
    self.txtAcctountNumberOfAccount = [LSEditItemText editItemText];
    [self.scrollView addSubview:self.txtAcctountNumberOfAccount];
    
    self.txtAccountMobileOfAccount = [LSEditItemText editItemText];
    [self.scrollView addSubview:self.txtAccountMobileOfAccount];
    
    self.lstBank = [LSEditItemList editItemList];
    [self.scrollView addSubview:self.lstBank];
    
    self.titleShopInfo = [LSEditItemTitle editItemTitle];
    [self.titleShopInfo configTitle:@"店铺信息"];
    [self.scrollView addSubview:self.titleShopInfo];
    
    self.lstProvince = [LSEditItemList editItemList];
    [self.scrollView addSubview:self.lstProvince];
    
    self.lstCity = [LSEditItemList editItemList];
    [self.scrollView addSubview:self.lstCity];
    
    self.txtAddress = [LSEditItemText editItemText];
    [self.scrollView addSubview:self.txtAddress];
    
    self.txtName = [LSEditItemText editItemText];
    [self.scrollView addSubview:self.txtName];
    
    self.txtMobile = [LSEditItemText editItemText];
    [self.scrollView addSubview:self.txtMobile];
    
    [self setupProtocolView];
    
    self.lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.scrollView.ls_width - 20, 196)];
    self.lblInfo.font = [UIFont systemFontOfSize:12];
    self.lblInfo.textColor = [ColorHelper getRedColor];
    self.lblInfo.numberOfLines = 0;
    [self.scrollView addSubview:self.lblInfo];
}

- (void)setupInfoView {
    //提示信息
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, 40)];
    [self.scrollView addSubview:infoView];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"ico_warning_r"];
    [infoView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoView).offset(10);
        make.centerY.equalTo(infoView);
        make.size.equalTo(22);
    }];
    UILabel *lblWarning = [[UILabel alloc] init];
    lblWarning.textColor = [ColorHelper getRedColor];
    lblWarning.numberOfLines = 0;
    lblWarning.font = [UIFont systemFontOfSize:11];
    [infoView addSubview:lblWarning];
    [lblWarning makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(5);
        make.top.bottom.equalTo(infoView);
        make.right.equalTo(infoView.right).offset(-10);
    }];
    self.lblWarning = lblWarning;
}

- (void)setupProtocolView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, 52)];
    [self.scrollView addSubview:view];
    
    UIButton *btnCheck = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCheck setImage:[UIImage imageNamed:@"ico_uncheck"] forState:UIControlStateNormal];
    [btnCheck addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnCheck = btnCheck;
    [view addSubview:btnCheck];
    [btnCheck makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(22);
        make.centerY.equalTo(view);
        make.left.equalTo(view);
    }];
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont systemFontOfSize:15];
    lbl.textColor = [ColorHelper getTipColor3];
    [view addSubview:lbl];
    lbl.text = @"我已阅读并同意";
    [lbl makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnCheck.right).offset(5);
        make.centerY.equalTo(view);
    }];
    UILabel *lblProtocol = [[UILabel alloc] init];
    lblProtocol.textColor = [ColorHelper getBlueColor];
    lblProtocol.font = [UIFont systemFontOfSize:13];
    lblProtocol.text = @"《电子支付代收代付协议》";
    lblProtocol.userInteractionEnabled = YES;
    [lblProtocol addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReadProtocol)]];
    [view addSubview:lblProtocol];
    [lblProtocol makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbl.right);
        make.bottom.equalTo(lbl.bottom).offset(-2);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [ColorHelper getBlueColor];
    [view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbl.right);
        make.bottom.equalTo(lbl);
        make.right.equalTo(lblProtocol.right);
        make.height.equalTo(1);
    }];
    [view layoutIfNeeded];
    CGFloat margin = (view.ls_width - line.ls_right)/2;
    [btnCheck updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(margin);
    }];
    
}
- (void)tapReadProtocol {
    PaymentNoteView *vc = [[PaymentNoteView alloc] initWithShopInfoVO:self.shopInfoVO];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}
- (void)loadData{
    //获取分账实体ID
    self.scrollView.hidden = YES;
    __strong typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *entiyId = [[Platform Instance] getkey:PAY_ENTITY_ID];
    [param setValue:entiyId forKey:@"entity_id"];
    ///查询店铺电子支付信息
    NSString *url = @"pay/online/v1/get_online_pay_info";
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        ShopInfoVO *shopInfoVo = [ShopInfoVO mj_objectWithKeyValues:json[@"data"]];
        wself.shopInfoVO = shopInfoVo;
        wself.scrollView.hidden = NO;
        [wself initData];
        [wself accountTypeOfAccountShow];
        [UIHelper refreshUI:wself.scrollView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        if (self.shopInfoVO.settleAccountInfo.auditStatus.intValue == 2 || self.shopInfoVO.settleAccountInfo.auditStatus.intValue == 3) {
            UIViewController *vc = nil;
            for (UIViewController *viewController in [self.navigationController viewControllers]) {
                if ([viewController isKindOfClass:[PaymentTypeView class]]) {
                   vc = viewController;
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    [self.navigationController popToViewController:vc animated:NO];
                    break;
                } else  if ([viewController isKindOfClass:[PaymentView class]]) {
                    PaymentView *vc = (PaymentView *)viewController;
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    [self.navigationController popToViewController:vc animated:NO];
                    break;
                }
            }
        } else {
             [self alertChangedMessage:[UIHelper currChange:self.scrollView]];
        }
    } else {
        if ([self isValid]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"收款账户提交成功后,1个月只能变更1次,且变更可能需要较长的审核时间,确定要提交吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再检查下" style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self save];
            }];
            [alertVC addAction:okAction];
            [alertVC addAction:cancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
}

- (void)initMainView {
    [self.lstAccountType initLabel:@"账户类型" withHit:@"建议选择对公账户" isrequest:NO delegate:self];
    [self.txtOrgCode initLabel:@"组织机构代码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.lstBankName initLabel:@"开户银行" withHit:nil isrequest:YES delegate:self];
    [self.lstBankProvince initLabel:@"开户省份" withHit:nil isrequest:YES delegate:self];
    [self.lstBankCity initLabel:@"开户城市" withHit:nil isrequest:YES delegate:self];
    [self.lstBankBranch initLabel:@"开户支行" withHit:nil isrequest:YES delegate:self];
    self.lstBankBranch.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.lstBank initLabel:@"银行账号" withHit:nil isrequest:YES delegate:self];
    [self.txtAccountName initLabel:@"开户人姓名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtAccountName initMaxNum:30];
    [self.lstAccountTypeOfAccount initLabel:@"开户人证件类型" withHit:nil isrequest:YES delegate:self];
    //默认开户人证件类型身份证
    [self.lstAccountTypeOfAccount initData:@"身份证" withVal:@"1"];
    [self.txtAcctountNumberOfAccount initLabel:@"开户人证件号码" withHit:nil isrequest:YES type:UIKeyboardTypeNumbersAndPunctuation];
    [self.txtAcctountNumberOfAccount initMaxNum:30];
    [self.txtAccountMobileOfAccount initLabel:@"开户人手机" withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtAccountMobileOfAccount initMaxNum:11];
    [self.lstProvince initLabel:@"所在省份" withHit:nil isrequest:YES delegate:self];
    [self.lstCity initLabel:@"所在城市" withHit:nil isrequest:YES delegate:self];
    [self.txtAddress initLabel:@"详细地址" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName initLabel:@"负责人姓名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtMobile initLabel:@"负责人手机" withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtMobile initMaxNum:11];
    self.lstAccountType.lblVal.hidden = YES;
    self.lstAccountType.lblVal1.hidden = NO;
    self.lstBankBranch.lblVal.hidden = YES;
    self.lstBankBranch.lblVal1.hidden = NO;
    
    self.lstAccountType.tag = TAG_LST_ACCOUNT_TYPE;
    self.lstBankName.tag = TAG_LST_BANK_NAME;
    self.lstBankCity.tag = TAG_LST_BANK_CITY;
    self.lstBankBranch.tag = TAG_LST_BANK_BRANCH;
    self.lstBankProvince.tag = TAG_LST_BANK_PROVINCE;
    self.lstBank.tag = TAG_LST_BANK;
    self.lstAccountTypeOfAccount.tag = TAG_LST_ACCOUNT_TYPE_OF_ACCOUNT;
    self.lstProvince.tag = TAG_LST_PROVINCE;
    self.lstCity.tag = TAG_LST_CITY;
    self.lblInfo.text = [NSString stringWithFormat:@" 提示：\n1.建议您绑定开户银行是主流银行的账户，比如工商银行、农业银行、中国银行、建设银行、招商银行、兴业银行、交通银行等，将会更加及时收到转账金额。\n2.请仔细核对以上信息，收款账户提交成功后，顾客使用电子支付的钱将会转到所填的银行账户。\n3.顾客使用电子支付付款成功后，这笔钱会在第%ld日中午12：00后自动转账到您所填的收款账户，按协议约定的费率收取服务费。\n4.变更账户后，顾客使用电子支付的钱将会在变更成功后的第%ld日中午12：00后自动转账到您所填的银行账户。",self.shopInfoVO.fundBillHoldDay+1,self.shopInfoVO.fundBillHoldDay +1];
    [self.lblInfo sizeToFit];
    
    
}

#pragma mark - 初始化通知
- (void)initNotification {
    [UIHelper initNotification:self.scrollView event:Notification_UI_KindPayEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_KindPayEditView_Change object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 页面里面的值改变时调用
- (void)dataChange:(NSNotification *)notification {
    [self editTitle:[UIHelper currChange:self.scrollView] act:ACTION_CONSTANTS_EDIT];
    if ([UIHelper currChange:self.scrollView]) {
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"提交" filePath:Head_ICON_OK];
    } else {
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:nil filePath:nil];
    }
    
}

- (void)initData {
    int authStatus = self.shopInfoVO.settleAccountInfo.authStatus.intValue;
    int auditStatus = self.shopInfoVO.settleAccountInfo.auditStatus.intValue;
    if(authStatus == 1 && auditStatus == 3){
        if (self.shopInfoVO.settleAccountInfo.auditMessage.length == 0) {
            self.lblWarning.text = @"您提交的收款账户变更审核未通过，请及时修改！";}
        else{
            self.lblWarning.text = [NSString stringWithFormat:@"您提交的收款账户变更审核未通过，原因是%@，请及时修改！",self.shopInfoVO.settleAccountInfo.auditMessage];}
    }else if(authStatus == 1 && auditStatus == 2){
        NSString* dateStr=[DateUtils formateChineseTime4:self.shopInfoVO.settleAccountInfo.opTime.longLongValue];
        self.lblWarning.text = [NSString stringWithFormat:@"以下信息请仔细填写，提交成功后，1个月只能变更1次。上次变更时间是%@，如需紧急变更，请联系客服:4000288255。",dateStr];
    }else if(authStatus == 0 || authStatus == 2 || (authStatus == 1 && auditStatus == 0)){
        //未进件，进件失败状态
        self.lblWarning.text = @"以下信息请仔细填写，提交成功后，1个月只能变更1次。如需紧急变更，请联系客服:4000288255。";
    }

    if (authStatus == 1) {//店铺信息已提交页面不可修改
        [self.btnCheck setBackgroundImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateNormal];
        self.btnCheck.userInteractionEnabled = NO;
        self.btnCheck.selected = YES;
    } else {//店铺信息没有提交
        [self.btnCheck setBackgroundImage:[UIImage imageNamed:@"ico_uncheck"] forState:UIControlStateNormal];
        self.btnCheck.selected = NO;
    }
     NSString* dateStr=[DateUtils formateChineseTime4:self.shopInfoVO.settleAccountInfo.opTime.longLongValue];
     NSDate *curren = [NSDate date];
     NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
     [formatter setDateFormat:@"yyyy年MM月"];
     NSString * currentTime = [formatter stringFromDate:curren];

    if (authStatus == 1 && auditStatus == 2 && [currentTime isEqualToString:dateStr] && self.shopInfoVO.hasCommit == 1) {//店铺信息已提交页面不可修改
        if (self.shopInfoVO.accountType == 1) {
            [self.lstAccountType initData:@"个人账户" withVal:@"1"];
            [self.txtAccountName initLabel:@"开户人姓名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        } else if (self.shopInfoVO.accountType == 2) {
            [self.lstAccountType initData:@"对公账户(公司或单位开设的账户)" withVal:@"2"];
            [self.txtAccountName initLabel:@"对公账户名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        }
    } else {
        if (self.shopInfoVO.hasCommit == 1) {
            if (self.shopInfoVO.accountType == 1) {
                [self.lstAccountType initData:@"个人账户" withVal:@"1"];
                [self.txtAccountName initLabel:@"开户人姓名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
            } else if (self.shopInfoVO.accountType == 2) {
                [self.lstAccountType initData:@"对公账户(公司或单位开设的账户)" withVal:@"2"];
                [self.txtAccountName initLabel:@"对公账户名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
            }
        } else if ([NSString isNotBlank:self.shopInfoVO.bankAccount]) {//信息完善一部分做兼容
            if (self.shopInfoVO.shopType == 2) {
                [self.lstAccountType initData:@"个人账户" withVal:@"1"];
                [self.txtAccountName initLabel:@"开户人姓名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
            } else if (self.shopInfoVO.shopType == 1) {
                [self.lstAccountType initData:@"对公账户(公司或单位开设的账户)" withVal:@"2"];
                 [self.txtAccountName initLabel:@"对公账户a名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
            }
        } else {//默认是个人
            [self.lstAccountType initData:@"个人账户" withVal:@"1"];
            [self.txtAccountName initLabel:@"开户人姓名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        }
        
    }
    [self.txtOrgCode initData:self.shopInfoVO.orgNo];
    [self.lstBankName initData:self.shopInfoVO.bankDisplayName withVal:self.shopInfoVO.bankName];
    [self.lstBankProvince initData:self.shopInfoVO.bankProvName withVal:self.shopInfoVO.bankProvNo];
    [self.lstBankCity initData:self.shopInfoVO.bankCityName withVal:self.shopInfoVO.bankCityNo];
    [self.lstBankBranch initData:self.shopInfoVO.bankSubName withVal:self.shopInfoVO.bankSubNo];
    [self.txtAccountName initData:self.shopInfoVO.bankAccount];
    [self.lstBank initData:self.shopInfoVO.bankCardNumber withVal:self.shopInfoVO.bankCardNumber];
    [self.txtAcctountNumberOfAccount initData:self.shopInfoVO.holderCardNo];
    [self.txtAccountMobileOfAccount initData:self.shopInfoVO.holderPhone];
    self.bankName = self.shopInfoVO.bankName;
    self.provinceNo = self.shopInfoVO.bankProvNo;
    self.cityNo = self.shopInfoVO.bankCityNo;
    self.bankSubNo = self.shopInfoVO.bankSubNo;
    [self.lstProvince initData:self.shopInfoVO.locusProvinceName withVal:self.shopInfoVO.locusProvince];
    [self.lstCity initData:self.shopInfoVO.locusCityName withVal:self.shopInfoVO.locusCity];
    [self.txtAddress initData: self.shopInfoVO.detailAddress];
    [self.txtName initData: self.shopInfoVO.ownerName];
    [self.txtMobile initData: self.shopInfoVO.ownerPhone];
    self.currentProvinceId = self.shopInfoVO.locusProvince;
#pragma mark -- 已进件成功且审核通过，所有选项置灰不可点
    if (authStatus == 1 && auditStatus == 2 && [currentTime isEqualToString:dateStr] && self.shopInfoVO.hasCommit == 1) {//店铺信息已提交页面不可修改
        [self editEnable:NO];
    } else {
        [self editEnable:YES];
    }
    
    
    
    
}
- (void)editEnable:(BOOL)isEdit {
    [self.lstAccountType editEnable:isEdit];
    [self.txtAccountName editEnabled:isEdit];
    [self.txtOrgCode editEnabled:isEdit];
    [self.lstBankName editEnable:isEdit];
    [self.lstBankProvince editEnable:isEdit];
    [self.lstBankCity editEnable:isEdit];
    [self.lstBankBranch editEnable:isEdit];
    [self.txtAccountName editEnabled:isEdit];
    [self.lstBank editEnable:isEdit];
    [self.txtAcctountNumberOfAccount editEnabled:isEdit];
    [self.txtAcctountNumberOfAccount editEnabled:isEdit];
    [self.lstProvince editEnable:isEdit];
    [self.lstCity editEnable:isEdit];
    [self.txtAddress editEnabled:isEdit];
    [self.txtAccountMobileOfAccount editEnabled:isEdit];
    [self.lstAccountTypeOfAccount editEnable:isEdit];
    [self.txtName editEnabled:isEdit];
    [self.txtMobile editEnabled:isEdit];
}
//1）账户类型是“个人账户”时，隐藏“组织机构代码”项
//2）账户类型是“对公账户”，隐藏“开户人证件类型”和“开户人证件号码”；开户人姓名文字改成"对公账户名称"，和原来保持一致。
- (void)accountTypeOfAccountShow {
    BOOL visibal = [[self.lstAccountType getDataLabel] isEqualToString:@"个人账户"];
    [self.txtOrgCode visibal:!visibal];
    [self.lstAccountTypeOfAccount visibal:visibal];
    [self.txtAcctountNumberOfAccount visibal:visibal];
}
- (void)alertChangedMessage:(BOOL)isChange {
    
    if (isChange) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"内容有变更尚未保存,确定要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self confirmChangedMessage];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else {
        [self confirmChangedMessage];
    }
}

- (void)confirmChangedMessage {
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)onItemListClick:(LSEditItemList *)obj {
    __strong PaymentEditView *strongSelf = self;
    if (self.lstBankProvince == obj) {
        if ([NSString isBlank:self.lstBankName.lblVal.text]) {
            [AlertBox show:@"开户银行不能为空"];
        } else {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setValue:self.bankName forKey:@"bankName"];
            NSString *url = @"pay/area/v1/get_bank_province";
            [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行开户省份
                NSArray *array = json[@"data"];
                NSMutableArray *optionList = [[NSMutableArray alloc] init];
                for (NSDictionary *obj in array) {
                    ShopInfoVO *shopInfoVO = [ShopInfoVO mj_objectWithKeyValues:obj];
                    NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.provinceName andId:shopInfoVO.provinceNo];
                    [optionList addObject:nameItem];
                    
                }
                [strongSelf showItemList:strongSelf.lstBankProvince array:optionList];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            
        }
    } else if (self.lstBankCity == obj) {
        if ([NSString isBlank:self.lstBankProvince.lblVal.text]) {
            [AlertBox show:@"开户省份不能为空"];
        } else {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setValue:self.bankName forKey:@"bankName"];
            [param setValue:self.provinceNo forKey:@"provinceNo"];
            NSString *url = @"pay/area/v1/get_bank_cities";
            [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行开户城市
                NSArray *array = json[@"data"];
                NSMutableArray *optionList = [[NSMutableArray alloc] init];
                for (NSDictionary *obj in array) {
                    ShopInfoVO *shopInfoVO = [ShopInfoVO mj_objectWithKeyValues:obj];
                    NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.cityName andId:shopInfoVO.cityNo];
                    [optionList addObject:nameItem];
                    
                }
                [strongSelf showItemList:strongSelf.lstBankCity array:optionList];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            
        }
    } else if (self.lstBankBranch == obj) {
        if ([NSString isBlank:self.lstBankCity.lblVal.text]) {
            [AlertBox show:@"开户城市不能为空"];
        } else {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setValue:self.bankName forKey:@"bankName"];
            [param setValue:self.cityNo forKey:@"cityNo"];
            NSString *url = @"pay/area/v1/get_sub_banks";
            [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行开户支行
                NSArray *array = json[@"data"];
                NSMutableArray *optionList = [[NSMutableArray alloc] init];
                for (NSDictionary *obj in array) {
                    ShopInfoVO *shopInfoVO = [ShopInfoVO mj_objectWithKeyValues:obj];
                    NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.subBankName andId:shopInfoVO.subBankNo];
                    [optionList addObject:nameItem];
                    
                }
                [strongSelf showItemList:strongSelf.lstBankBranch array:optionList];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            
        }
    } else if (self.lstBankName == obj) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        NSString *url = @"pay/area/v1/get_banks";
        [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行列表
            NSArray *array = json[@"data"];
            NSMutableArray *optionList = [[NSMutableArray alloc] init];
            for (NSDictionary *obj in array) {
                ShopInfoVO *shopInfoVO = [ShopInfoVO mj_objectWithKeyValues:obj];
                NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.bankDisplayName andId:shopInfoVO.bankName];
                [optionList addObject:nameItem];
                
            }
            [strongSelf showItemList:strongSelf.lstBankName array:optionList];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
        
    } else if (self.lstBank == obj) {
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox limitInputNumber:30 digitLimit:0];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
    } else if (self.lstAccountType == obj) {
        NSMutableArray *optionList = [NSMutableArray array];
        NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:@"个人账户" andId:@"1"];
        [optionList addObject:nameItem];
        nameItem = [[NameItemVO alloc] initWithVal:@"对公账户(公司或单位开设的账户)" andId:@"2"];;
        [optionList addObject:nameItem];
        [self showItemList:self.lstAccountType array:optionList];
    } else if (self.lstAccountTypeOfAccount == obj) {//开户人证件类型
        NSMutableArray *optionList = [NSMutableArray array];
        NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:@"身份证" andId:@"1"];
        [optionList addObject:nameItem];
        nameItem = [[NameItemVO alloc] initWithVal:@"护照" andId:@"2"];
        [optionList addObject:nameItem];
        [self showItemList:self.lstAccountTypeOfAccount array:optionList];
    } else if (self.lstProvince == obj) {//店铺所在省份
        __strong typeof(self) wself = self;
        NSString *url = @"pay/area/v1/get_province";
        [BaseService getRemoteLSOutDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
            NSArray *array = json[@"data"];
            NSMutableArray *optionList = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in array) {
                NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:dictionary[@"provinceName"] andId:dictionary[@"provinceNo"]];
                [optionList addObject:nameItem];
            }
            [wself showItemList:wself.lstProvince array:optionList];
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        NSMutableArray *optionList = [NSMutableArray array];
        NameItemVO *nameItem= [[NameItemVO alloc] initWithVal:@"身份证" andId:@"1"];
        [optionList addObject:nameItem];
        nameItem = [[NameItemVO alloc] initWithVal:@"护照" andId:@"2"];
        [optionList addObject:nameItem];
        [self showItemList:self.lstAccountTypeOfAccount array:optionList];
    } else if (self.lstCity == obj) {//店铺所在城市
        if ([NSString isBlank:[self.lstProvince getStrVal]]) {
            [AlertBox show:@"所在省份不能为空"];
            return;
        }
        __strong typeof(self) wself = self;
        NSString *url = @"pay/area/v1/get_cities";
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"province_no"] = self.currentProvinceId;
        
        [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            NSArray *array = json[@"data"];
            NSMutableArray *optionList = [[NSMutableArray alloc] init];
            for (NSMutableDictionary *dictionary in array) {
                NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:dictionary[@"cname"] andId:dictionary[@"cno"]];
                [optionList addObject:nameItem];
            }
            [wself showItemList:wself.lstCity array:optionList];
            
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    
}

- (void)showItemList:(LSEditItemList *)obj array:(NSMutableArray *)array {
    if (obj == self.lstBankName || obj == self.lstBankCity || obj == self.lstBankProvince || obj == self.lstAccountType || obj == self.lstAccountTypeOfAccount || obj == self.lstCity || obj == self.lstProvince) {
        [OptionPickerBox initData:array itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstBankBranch) {
        SelectItemList *vc = [[SelectItemList alloc] initWithtxtTitle:@"开户支行" txtPlaceHolder:@"输入支行关键字"];
        __strong PaymentEditView *strongSelf = self;
        [vc selectId:[obj getStrVal] list:array callBlock:^(id<INameItem> item) {
            if (item) {
                [strongSelf.lstBankBranch changeData:[item obtainItemName] withVal:[item obtainItemId]];
                strongSelf.bankSubNo = [item obtainItemId];
            }
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)event
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (event == TAG_LST_BANK_NAME) {
        [self.lstBankName changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([NSString isNotBlank:self.bankName]) {
            if (![self.bankName isEqualToString:[item obtainItemId]]) {
                [self.lstBankProvince initData:nil withVal:nil];
                [self.lstBankCity  initData:nil withVal:nil];
                [self.lstBankBranch initData:nil withVal:nil];
            }
        }
        self.bankName = [item obtainItemId];
    } else if (event == TAG_LST_BANK_PROVINCE) {
        [self.lstBankProvince changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([NSString isNotBlank:self.provinceNo]) {
            if (![self.provinceNo isEqualToString:[item obtainItemId]]) {
                [self.lstBankCity  initData:nil withVal:nil];
                [self.lstBankBranch initData:nil withVal:nil];
            }
        }
        self.provinceNo = [item obtainItemId];
    } else if (event == TAG_LST_BANK_CITY) {
        [self.lstBankCity changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([NSString isNotBlank:self.cityNo]) {
            if (![self.cityNo isEqualToString:[item obtainItemId]]) {
                [self.lstBankBranch initData:nil withVal:nil];            }
        }
        self.cityNo = [item obtainItemId];
    } else if (event == TAG_LST_BANK_BRANCH) {
        [self.lstBankBranch changeData:[item obtainItemName] withVal:[item obtainItemId]];
        self.bankSubNo = [item obtainItemId];
    } else if (event == TAG_LST_ACCOUNT_TYPE) {
        [self.lstAccountType changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([self.lstAccountType.lblVal.text isEqualToString:@"对公账户(公司或单位开设的账户)"]) {
            [self.txtAccountName initLabel:@"对公账户名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        } else {
            [self.txtAccountName initLabel:@"开户人姓名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        }
        [self accountTypeOfAccountShow];
    } else if (event == TAG_LST_ACCOUNT_TYPE_OF_ACCOUNT) {
        [self.lstAccountTypeOfAccount changeData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (event == TAG_LST_PROVINCE) {
        [self.lstProvince changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if (self.lstProvince.isChange) {
            [self.lstCity initData:nil withVal:nil];
            [self.txtAddress initData:nil];
        }
        self.currentProvinceId = [item obtainItemId];
    } else if (event == TAG_LST_CITY) {
        [self.lstCity changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if (self.lstCity.isChange) {
            [self.txtAddress initData:nil];
        }
       
    }
    
    [UIHelper refreshUI:self.scrollView];
    
    return YES;
}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if (eventType == TAG_LST_BANK) {
        [self.lstBank changeData:val withVal:val];
    }
}


- (void)btnClick:(UIButton *)sender {
    self.btnCheck.selected = !self.btnCheck.selected;
    [self initImage];
}

- (void)initImage
{
    if (self.btnCheck.selected == YES) {
        [self.btnCheck setBackgroundImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateNormal];
    } else {
        [self.btnCheck setBackgroundImage:[UIImage imageNamed:@"ico_uncheck"] forState:UIControlStateNormal];
    }
    
}

- (void)save {
        NSString *url = @"pay/online/v1/modify_online_pay_info";
        __strong PaymentEditView *strongSelf = self;
        [BaseService getRemoteLSOutDataWithUrl:url param:self.param withMessage:@"正在提交" show:YES CompletionHandler:^(id json) {
#pragma mark --若是首次提交，直接显示提交成功，返回上一个页面
            if (self.shopInfoVO.settleAccountInfo.authStatus.intValue == 0 || self.shopInfoVO.settleAccountInfo.authStatus.intValue == 2) {
                [AlertBox show:@"提交成功"];
                PaymentView *paymentView = nil;
                PaymentTypeView *paymentVc = nil;
                for (UIViewController *vc in strongSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[PaymentView class]]) {
                        paymentView = (PaymentView *)vc;
                        [paymentView loadData];
                    }
                    if ([vc isKindOfClass:[PaymentTypeView class]]) {
                        paymentVc = (PaymentTypeView *)vc;
                        [paymentVc loadData];
                    }
                }
                [XHAnimalUtil animal:strongSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [strongSelf.navigationController popViewControllerAnimated:NO];
            } else{
#pragma mark -- 若是进件过要变更，则跳转到变更等待页面
                NSInteger auditStatus = 1;
                LSPaymentStatusController *vc = [[LSPaymentStatusController alloc] init];
                vc.status = auditStatus;
                [strongSelf.navigationController pushViewController:vc animated:NO];
                [XHAnimalUtil animal:strongSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            }
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    
}

- (BOOL)isValid
{
    
    for (id obj in self.scrollView.subviews) {
        if ([obj isKindOfClass:[EditItemBase class]]) {
            EditItemBase *editItemBase = (EditItemBase *)obj;
            if (editItemBase.hidden == NO) {
                NSString *str;
                if ([obj isKindOfClass:[LSEditItemList class]]) {
                    LSEditItemList *view = (LSEditItemList *)obj;
                    if ([NSString isBlank:[view getStrVal]]) {
                        str = [NSString stringWithFormat:@"%@不能为空",view.lblName.text];
                        [AlertBox show:str];
                        return NO;
                    }
                }
                if ([obj isKindOfClass:[LSEditItemText class]]) {
                    LSEditItemText *editItemText = (LSEditItemText *)obj;
                    if ([NSString isBlank:[editItemText getStrVal]]) {
                        str = [NSString stringWithFormat:@"%@不能为空",editItemText.lblName.text];
                        [AlertBox show:str];
                        return NO;
                    }
                }
            }
        }
    }
//    if(![NSString isChineseCharacter:self.txtAccountName.txtVal.text]) {
//        [AlertBox show:[NSString stringWithFormat:@"请输入正确的中文%@",self.txtAccountName.lblName.text]];
//        return NO;
//    }
    
    
    if (self.txtAcctountNumberOfAccount.hidden == NO && [[self.lstAccountTypeOfAccount getStrVal] isEqualToString:@"1"]) {
            //身份证
            if ([NSString isNotNumAndLetter:self.txtAcctountNumberOfAccount.txtVal.text]) {
                [AlertBox show:@"请输入合法的证件号码!"];
                return NO;
            }
    }
    
    if (![NSString validateMobile:[self.txtAccountMobileOfAccount getStrVal]]) {
        [AlertBox show:@"开户人手机填写有误，请填写正确的手机号码！"];
        return NO;
    }

    if ([self.lstBank getStrVal].length <= 5) {
        [AlertBox show:@"银行账号长度不能小于6位"];
        return NO;
    }
    if (![NSString validateMobile:[self.txtMobile getStrVal]]) {
        [AlertBox show:@"负责人手机填写有误，请填写正确的手机号码！"];
        return NO;
    }
    if (self.btnCheck.selected == NO) {
        [AlertBox show:@"请您阅读并同意《电子支付代收代付协议》"];
        return NO;
    }

    return YES;
}

- (NSMutableDictionary *)param
{
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param setValue:[[Platform Instance] getkey:PAY_ENTITY_ID]  forKey:@"entityId"];
    [_param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    if ([self.lstAccountType.lblVal.text isEqualToString:@"个人账户"]){
        [_param setValue:@"1" forKey:@"accountType"];
        [_param setValue:[self.txtAcctountNumberOfAccount getStrVal] forKey:@"holderCardNo"];
    }else{
        [_param setValue:@"2" forKey:@"accountType"];
        [_param setValue:[self.txtOrgCode getStrVal] forKey:@"orgNo"];
    }
    if ([self.lstAccountTypeOfAccount.lblVal.text isEqualToString:@"身份证"]){
        [_param setValue:@"1" forKey:@"holderCardType"];
    }else{
        [_param setValue:@"2" forKey:@"holderCardType"];
    }
    [_param setValue:[self.txtAccountMobileOfAccount getStrVal] forKey:@"holderPhone"];
    [_param setValue:self.bankName forKey:@"bankName"];
    [_param setValue:self.provinceNo forKey:@"bankProvNo"];
    [_param setValue:self.cityNo forKey:@"bankCityNo"];
    [_param setValue:self.bankSubNo forKey:@"bankSubNo"];
    [_param setValue:[self.lstBank getStrVal] forKey:@"bankCardNumber"];
    [_param setValue:self.txtAccountName.txtVal.text forKey:@"bankAccount"];
    //新增
    [_param setValue:[self.lstProvince getStrVal] forKey:@"locusProvince"];
    [_param setValue:[self.lstCity getStrVal] forKey:@"locusCity"];
    [_param setValue:[self.txtName getStrVal]  forKey:@"ownerName"];
    [_param setValue:[self.txtMobile getStrVal] forKey:@"ownerPhone"];
    [_param setValue:[self.txtAddress getStrVal] forKey:@"detailAddress"];
    return _param;
}


@end
