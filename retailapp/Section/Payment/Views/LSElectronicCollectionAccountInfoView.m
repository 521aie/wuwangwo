//
//  LSElectronicCollectionAccountInfoView.m
//  retailapp
//
//  Created by guozhi on 2016/12/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSElectronicCollectionAccountInfoView.h"
@interface LSElectronicCollectionAccountInfoView()
/** 电子收款未到账总额 */
@property (nonatomic, strong) UILabel *lblNotTotalAmountName;
/** 电子收款未到账总额 */
@property (nonatomic, strong) UILabel *lblNotTotalAmountVal;
/** 某天收入 */
@property (nonatomic, strong) UILabel *lblOneDayIncomeName;
/** 某天收入 */
@property (nonatomic, strong) UILabel *lblOneDayIncomeVal;
/** 某天已到账 */
@property (nonatomic, strong) UILabel *lblOneDayAccountName;
/** 某天已到账 */
@property (nonatomic, strong) UILabel *lblOneDayAccountVal;
/** 本月收入 */
@property (nonatomic, strong) UILabel *lblOneMonthIncomeName;
/** 本月收入 */
@property (nonatomic, strong) UILabel *lblOneMonthIncomeVal;
/** 本月已到账 */
@property (nonatomic, strong) UILabel *lblOneMonthAccountName;
/** 本月已到账 */
@property (nonatomic, strong) UILabel *lblOneMonthAccountVal;
/** 已扣除折扣率 */
@property (nonatomic, strong) UILabel *lblFee;
/** 上面白色分割线 */
@property (nonatomic, strong) UIView *viewTopLine;
/** 下面白色分割线 */
@property (nonatomic, strong) UIView *viewBottomLine;
/** 未绑卡时出现感叹号图片 */
@property (nonatomic, strong) UIImageView *imgViewWarning;
/** 未绑卡时出现 */
@property (nonatomic, strong) UILabel *lblWarning;
/** 提示文字 */
@property (nonatomic, strong) UILabel *lblText;


@end
@implementation LSElectronicCollectionAccountInfoView
+ (instancetype)electronicCollectionAccountInfoView {
    LSElectronicCollectionAccountInfoView *view = [[LSElectronicCollectionAccountInfoView alloc] init];
    [view configViews];
    [view configConstraints];
    return view;
}

- (void)configViews {
 
    UIColor *lightWhite = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //白色背景
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    //电子收款未到账总额
    self.lblNotTotalAmountName = [[UILabel alloc] init];
    self.lblNotTotalAmountName.textColor = lightWhite;
    self.lblNotTotalAmountName.font = [UIFont systemFontOfSize:14];
    self.lblNotTotalAmountName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lblNotTotalAmountName];
    self.lblNotTotalAmountName.text = @"电子收款未到帐总额(元)";
    //电子收款未到账总额
    self.lblNotTotalAmountVal = [[UILabel alloc] init];
    self.lblNotTotalAmountVal.textColor = [UIColor whiteColor];
    self.lblNotTotalAmountVal.font = [UIFont boldSystemFontOfSize:18];
    self.lblNotTotalAmountVal.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lblNotTotalAmountVal];
    self.lblNotTotalAmountVal.text = @"9302.00";
    //某天收入
    self.lblOneDayIncomeName = [[UILabel alloc] init];
    self.lblOneDayIncomeName.textColor = lightWhite;
    self.lblOneDayIncomeName.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.lblOneDayIncomeName];
    self.lblOneDayIncomeName.text = @"12月02日电子收款收入(元)";
    //某天收入
    self.lblOneDayIncomeVal = [[UILabel alloc] init];
    self.lblOneDayIncomeVal.textColor = [UIColor whiteColor];
    self.lblOneDayIncomeVal.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:self.lblOneDayIncomeVal];
    self.lblOneDayIncomeVal.text = @"0.00";
    //某天已到账
    self.lblOneDayAccountName = [[UILabel alloc] init];
    self.lblOneDayAccountName.textColor = lightWhite;
    self.lblOneDayAccountName.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.lblOneDayAccountName];
    self.lblOneDayAccountName.text = @"12月02日已到账金额(元)";
    //某天已到账
    self.lblOneDayAccountVal = [[UILabel alloc] init];
    self.lblOneDayAccountVal.textColor = [UIColor whiteColor];
    self.lblOneDayAccountVal.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:self.lblOneDayAccountVal];
    self.lblOneDayAccountVal.text = @"0.00";
    
    //本月收入
    self.lblOneMonthIncomeName = [[UILabel alloc] init];
    self.lblOneMonthIncomeName.textColor = lightWhite;
    self.lblOneMonthIncomeName.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.lblOneMonthIncomeName];
    self.lblOneMonthIncomeName.text = @"本月累计电子收款收入(元)";
    //本月收入
    self.lblOneMonthIncomeVal = [[UILabel alloc] init];
    self.lblOneMonthIncomeVal.textColor = [UIColor whiteColor];
    self.lblOneMonthIncomeVal.font = [UIFont boldSystemFontOfSize:14];;
    [self addSubview:self.lblOneMonthIncomeVal];
    self.lblOneMonthIncomeVal.text = @"0.00";
    //本月已到账
    self.lblOneMonthAccountName = [[UILabel alloc] init];
    self.lblOneMonthAccountName.textColor = lightWhite;
    self.lblOneMonthAccountName.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.lblOneMonthAccountName];
    self.lblOneMonthAccountName.text = @"本月累计已到账金额(元)";
    //本月已到账
    self.lblOneMonthAccountVal = [[UILabel alloc] init];
    self.lblOneMonthAccountVal.textColor = [UIColor whiteColor];
    self.lblOneMonthAccountVal.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:self.lblOneMonthAccountVal];
    self.lblOneMonthAccountVal.text = @"0.00";
    //已扣服务费
    self.lblFee = [[UILabel alloc] init];
    self.lblFee.font = [UIFont systemFontOfSize:8];
    self.lblFee.textColor = [UIColor whiteColor];
    [self addSubview:self.lblFee];
    self.lblFee.text = @"(已扣除服务费)";
    //⚠️图片
    self.imgViewWarning = [[UIImageView alloc] init];
    self.imgViewWarning.image = [UIImage imageNamed:@"ico_warning_r"];
    [self addSubview:self.imgViewWarning];
    //警告文字
    self.lblWarning = [[UILabel alloc] init];
    self.lblWarning.textColor = [UIColor redColor];
    self.lblWarning.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.lblWarning];
    self.lblWarning.text = @"未绑定电子支付";
    //说明文字
    self.lblText = [[UILabel alloc] init];
    self.lblText.textColor = lightWhite;
    self.lblText.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.lblText];
    self.lblText.numberOfLines = 0;
    self.lblText.text = @"1231241278478127841278478921478921874912879478129478217984218741289412894812412841124124124124124";
    //绑定按钮
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"btn_full_r"] forState:UIControlStateNormal];
    [self.btn setTitle:@"立即绑定收款账户，开始收款" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.btn];
    
    //上面分割线
    self.viewTopLine = [[UIView alloc] init];
    self.viewTopLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    [self addSubview:self.viewTopLine];
    //下面分割线
    self.viewBottomLine = [[UIView alloc] init];
    self.viewBottomLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    [self addSubview:self.viewBottomLine];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //电子收款未到账总额
    [self.lblNotTotalAmountName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself).offset(20);
        make.centerX.equalTo(wself);
    }];
    //电子收款未到账总额
    [self.lblNotTotalAmountVal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblNotTotalAmountName.bottom).offset(10);
        make.centerX.equalTo(wself.lblNotTotalAmountName.centerX);
    }];
    //某天收入
    [self.lblOneDayIncomeName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(5);
        make.top.equalTo(wself.lblNotTotalAmountVal.bottom).offset(20);
    }];
    //某天收入
    [self.lblOneDayIncomeVal makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblOneDayIncomeName);
        make.top.equalTo(wself.lblOneDayIncomeName.bottom).offset(10);
    }];
    //某天已到账
    [self.lblOneDayAccountName makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.right).offset(-5);
        make.top.equalTo(wself.lblOneDayIncomeName.top);
    }];
    //某天已到账
    [self.lblOneDayAccountVal makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblOneDayAccountName.left);
        make.top.equalTo(wself.lblOneDayIncomeVal.top);
    }];
    //本月收入
    [self.lblOneMonthIncomeName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblOneDayIncomeName.left);
        make.top.equalTo(wself.lblOneDayIncomeVal.bottom).offset(20);
    }];
    
    //本月收入
    [self.lblOneMonthIncomeVal makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblOneDayIncomeName.left);
        make.top.equalTo(wself.lblOneMonthIncomeName.bottom).offset(10);
    }];
    //本月已到账
    [self.lblOneMonthAccountName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblOneDayAccountName.left);
        make.top.equalTo(wself.lblOneMonthIncomeName.top);
    }];
    //本月已到账
    [self.lblOneMonthAccountVal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblOneMonthIncomeVal.top);
        make.left.equalTo(wself.lblOneDayAccountName.left);
    }];
    //已扣服务费
    [self.lblFee makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblOneDayAccountName.left);
        make.top.equalTo(wself.lblOneDayAccountVal.bottom).offset(5);
    }];
    //警告文字
    [self.lblWarning makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblOneMonthIncomeVal.bottom).offset(20);
        make.centerX.equalTo(wself.centerX).offset(15);
    }];
    //⚠️图片
    [self.imgViewWarning makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(22);
        make.centerY.equalTo(wself.lblWarning);
        make.right.equalTo(wself.lblWarning.left).offset(-10);
    }];
   
    //说明文字
    [self.lblText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(10);
        make.right.equalTo(wself.right).offset(-10);
        make.top.equalTo(wself.imgViewWarning.bottom).offset(10);
    }];
    //绑定按钮
    [self.btn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.lblText);
        make.height.equalTo(40);
        make.top.equalTo(wself.lblText.bottom).offset(20);
    }];
    //上面分割线
    [self.viewTopLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblOneDayIncomeName.top);
        make.bottom.equalTo(wself.lblOneDayIncomeVal.bottom);
        make.width.equalTo(1);
        make.centerX.equalTo(wself.centerX).offset(5);
    }];
    //下面分割线
    [self.viewBottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblOneMonthIncomeName.top);
        make.bottom.equalTo(wself.lblOneMonthIncomeVal.bottom);
        make.width.equalTo(1);
        make.centerX.equalTo(wself.viewTopLine.centerX);
    }];
    [self layoutIfNeeded];
    self.ls_height = self.btn.ls_bottom + 50;
    

}
/**
 设置电子收款信息
 
 @param shopInfoVo   门店信息
 @param name         电子/微信/支付宝
 @param date         某一天的数据
 @param account      电子收款未到账总额
 @param monthAccount 本月累计电子收款已到账
 @param monthIncome  本月累计电子收入
 @param dayAccount   某天累计电子收款已到账
 @param dayIncome    某天累计电子收款收入
 */
- (void)setShopInfoVo:(ShopInfoVO *)shopInfoVo name:(NSString *)name date:(NSString *)date unAccount:(NSString *)account monthAccount:(NSString *)monthAccount monthIncome:(NSString *)monthIncome dayAccount:(NSString *)dayAccount dayIncome:(NSString *)dayIncome {
    if ([name isEqualToString:@"电子"]) {
        self.lblFee.text = @"(已扣除服务费)";
    }
    self.lblOneDayAccountName.text = [NSString stringWithFormat:@"%@已到帐金额(元)",date];
    self.lblOneDayIncomeName.text = [NSString stringWithFormat:@"%@电子收款收入(元)",date];
    
    //电子收款未到账总额
    self.lblNotTotalAmountVal.text = account;
    //某天累计电子收款已到账
    self.lblOneDayAccountVal.text = dayAccount;
    //某天累计电子收款收入
    self.lblOneDayIncomeVal.text = dayIncome;
    //本月累计电子收款收入
    self.lblOneMonthAccountVal.text = monthAccount;
    //本月累计电子收入
    self.lblOneMonthIncomeVal.text = monthIncome;
    BOOL isAccount = [NSString isNotBlank:shopInfoVo.bankAccount];
    self.lblFee.hidden = !isAccount;
    self.imgViewWarning.hidden = isAccount;
    self.lblWarning.hidden = isAccount;
    self.btn.hidden = isAccount;
    //默认没有绑定账户
    __weak typeof(self) wself = self;
    if (isAccount) {//已经绑定了账户
        [self.lblText remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.left).offset(10);
            make.right.equalTo(wself.right).offset(-10);
            make.top.equalTo(wself.lblOneMonthIncomeVal.bottom).offset(20);
        }];
        [self layoutIfNeeded];
        self.ls_height = self.lblText.ls_bottom + 20;
    } else {
        [self.lblText remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.left).offset(10);
            make.right.equalTo(wself.right).offset(-10);
            make.top.equalTo(wself.imgViewWarning.bottom).offset(10);
        }];
        [self layoutIfNeeded];
        self.ls_height = self.btn.ls_bottom + 20;

    }
    if ([[Platform Instance] lockAct:ACTION_WEI_PAY_SUMMARIZE_SEARCH]) {
        self.ls_height = 0;
        self.hidden = YES;
        
    }
    
}



@end
