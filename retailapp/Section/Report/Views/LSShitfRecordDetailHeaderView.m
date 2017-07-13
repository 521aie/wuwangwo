//
//  LSShitfRecordDetailHeaderView.m
//  retailapp
//
//  Created by wuwangwo on 2017/4/2.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSShitfRecordDetailHeaderView.h"
#import "LSUserHandoverVo.h"
#import "DateUtils.h"
#import "ColorHelper.h"
#import "ObjectUtil.h"

@interface LSShitfRecordDetailHeaderView ()
/** 背景 */
@property (nonatomic, strong) UIView *viewBig;
/** 员工头像 */
@property (nonatomic, strong) UIImageView *imgView;
/** 员工名称 */
@property (nonatomic, strong) UILabel *lblName;
/** 工号 */
@property (nonatomic, strong) UILabel *lblNum;
/** 所属门店（单店不显示“所属门店”） */
@property (nonatomic, strong) UILabel *lblShop;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLineF;
/** 交接时间 */
@property (nonatomic, strong) UIImageView *startImg;
@property (nonatomic, strong) UIImageView *secondImg;
@property (nonatomic, strong) UILabel *lblStartTime;
@property (nonatomic, strong) UILabel *lblEndTime;
/** 角色*/
@property (nonatomic,strong) UILabel *lblRole;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLineS;
/** 营收概况背景 */
@property (nonatomic, strong) UIView *viewBg;
@property (nonatomic, strong) UILabel *lblPracticalAmountTxt;
@property (nonatomic, strong) UILabel *lblPracticalAmount;
@property (nonatomic, strong) UILabel *lblMemberRechargeTxt;
@property (nonatomic, strong) UILabel *lblMemberRecharge;
@end

@implementation LSShitfRecordDetailHeaderView

+ (instancetype)shitfRecordDetailHeaderView {
    LSShitfRecordDetailHeaderView *view = [[LSShitfRecordDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 235)];
    [view configViews];
    [view configConstraints];
    return view;
}

- (void)configViews {
    self.backgroundColor = [UIColor clearColor];
    
    self.viewBig = [[UIView alloc] init];
    self.viewBig.backgroundColor = [UIColor clearColor];
    [self addSubview:self.viewBig];
    
    //员工头像
    self.imgView = [[UIImageView alloc] init];
    self.imgView.layer.cornerRadius = 68/2;
    self.imgView.layer.masksToBounds = YES;
    [self.viewBig addSubview:self.imgView];
    
    //员工名称
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:15];
    self.lblName.textColor = [ColorHelper getTipColor3];
    self.lblName.numberOfLines = 0;
    [self.viewBig addSubview:self.lblName];
    
    //工号
    self.lblNum = [[UILabel alloc] init];
    self.lblNum.font = [UIFont systemFontOfSize:12];
    self.lblNum.textColor = [ColorHelper getTipColor3];
    self.lblNum.numberOfLines = 0;
    [self.viewBig addSubview:self.lblNum];
    
    //所属门店
    self.lblShop = [[UILabel alloc] init];
    self.lblShop.font = [UIFont systemFontOfSize:12];
    self.lblShop.textColor = [ColorHelper getTipColor3];
    [self.viewBig addSubview:self.lblShop];
    
    //分割线
    self.viewLineF = [[UIView alloc] init];
    self.viewLineF.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.viewBig addSubview:self.viewLineF];
    
    //交接时间
    self.startImg = [[UIImageView alloc] init];
    self.startImg.image =  [UIImage imageNamed:@"ico_report_shiftRecord_start"];
    self.startImg.layer.cornerRadius = 6;
    self.startImg.layer.masksToBounds = YES;
    [self.viewBig addSubview:self.startImg];
    
    self.secondImg = [[UIImageView alloc] init];
    self.secondImg.image = [UIImage imageNamed:@"ico_report_shiftRecord_end"];
    self.secondImg.layer.cornerRadius = 6;
    self.secondImg.layer.masksToBounds = YES;
    [self.viewBig addSubview:self.secondImg];
    
    self.lblStartTime = [[UILabel alloc] init];
    self.lblStartTime.font = [UIFont systemFontOfSize:12];
    self.lblStartTime.textColor = [ColorHelper getTipColor3];
    [self.viewBig addSubview:self.lblStartTime];
    
    self.lblEndTime = [[UILabel alloc] init];
    self.lblEndTime.font = [UIFont systemFontOfSize:12];
    self.lblEndTime.textColor = [ColorHelper getTipColor3];
    [self.viewBig addSubview:self.lblEndTime];
    
    //角色
    self.lblRole = [[UILabel alloc] init];
    self.lblRole.font = [UIFont systemFontOfSize:15];
    self.lblRole.textColor = [ColorHelper getTipColor6];
    self.lblRole.textAlignment = 2;
    [self.viewBig addSubview:self.lblRole];
    
    //分割线
    self.viewLineS = [[UIView alloc] init];
    self.viewLineS.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.viewBig addSubview:self.viewLineS];
    
    //营收概况背景
    self.viewBg = [[UIView alloc] init];
    self.viewBg.backgroundColor = [UIColor colorWithRed:0.82 green:0.81 blue:0.80 alpha:1.00];
    self.viewBg.layer.cornerRadius = 6;
    self.viewBg.layer.masksToBounds = YES;
    [self.viewBig addSubview:self.viewBg];
    
    //销售实收/应收金额
    self.lblPracticalAmountTxt = [[UILabel alloc] init];
    self.lblPracticalAmountTxt.font = [UIFont systemFontOfSize:13];
    self.lblPracticalAmountTxt.textColor = [ColorHelper getTipColor3];
    self.lblPracticalAmountTxt.textAlignment = 1;
    [self.viewBg addSubview:self.lblPracticalAmountTxt];
    
    self.lblPracticalAmount = [[UILabel alloc] init];
    self.lblPracticalAmount.font = [UIFont systemFontOfSize:13];
    self.lblPracticalAmount.textColor = [ColorHelper getTipColor3];
    self.lblPracticalAmount.textAlignment = 1;
    [self.viewBg addSubview:self.lblPracticalAmount];
    
    //会员充值实收/实收金额
    self.lblMemberRechargeTxt = [[UILabel alloc] init];
    self.lblMemberRechargeTxt.font = [UIFont systemFontOfSize:13];
    self.lblMemberRechargeTxt.textColor = [ColorHelper getTipColor3];
    self.lblMemberRechargeTxt.textAlignment = 1;
    [self.viewBg addSubview:self.lblMemberRechargeTxt];
    
    self.lblMemberRecharge = [[UILabel alloc] init];
    self.lblMemberRecharge.font = [UIFont systemFontOfSize:13];
    self.lblMemberRecharge.textColor = [ColorHelper getTipColor3];
    self.lblMemberRecharge.textAlignment = 1;
    [self.viewBg addSubview:self.lblMemberRecharge];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.viewBig makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(wself);
        make.right.bottom.equalTo(wself);
    }];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself).offset(14);
        make.left.equalTo(wself).offset(14);
        make.size.equalTo(64);
    }];
    
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself).offset(15);
        make.left.equalTo(wself.imgView.right).offset(10);
        make.right.equalTo(wself.right).offset(-SCREEN_W/3);
        make.height.equalTo(20);
    }];
    
    //单店不显示“所属门店”
    if ([[Platform Instance] getShopMode] == 1) {
        [self.lblNum makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.lblName.left);
            make.top.equalTo(wself.lblName.bottom).offset(20);
            make.right.equalTo(wself);
            make.height.equalTo(15);
        }];
    } else {
        [self.lblNum makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.lblName.left);
            make.top.equalTo(wself.lblName.bottom).offset(5);
            make.right.equalTo(wself);
            make.height.equalTo(15);
        }];
        
        [self.lblShop makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.lblName.left);
            make.top.equalTo(wself.lblNum.bottom).offset(5);
            make.right.equalTo(wself.lblNum.right);
        }];
    }
    
    [self.lblRole makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblName.right);
        make.top.equalTo(wself.lblName.top);
        make.right.equalTo(wself).offset(-10);
        make.height.equalTo(wself.lblName);
    }];
    
    [self.viewLineF makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.imgView.bottom).offset(14);
        make.height.equalTo(1);
    }];
    
    [self.startImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgView.left);
        make.top.equalTo(wself.viewLineF.bottom).offset(13);
        make.width.equalTo(30);
        make.height.equalTo(18);
    }];
    
    [self.lblStartTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.startImg.right).offset(5);
        make.top.bottom.equalTo(wself.startImg);
        make.right.equalTo(wself).offset(-SCREEN_W/2);
    }];
    
    [self.secondImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblStartTime.right).offset(15);
        make.top.bottom.equalTo(wself.startImg);
        make.width.equalTo(wself.startImg);
    }];
    
    [self.lblEndTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.secondImg.right).offset(5);
        make.top.bottom.equalTo(wself.startImg);
        make.width.equalTo(wself.lblStartTime);
    }];
    
    [self.viewLineS makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.viewLineF.bottom).offset(44);
        make.height.equalTo(1);
    }];
    
    [self.viewBg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.viewLineS.bottom).offset(10);
        make.left.equalTo(wself).offset(10);
        make.right.equalTo(wself).offset(-10);
        make.height.equalTo(80);
    }];
    
    UIView *firstLine = [[UIView alloc] init];
    firstLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.viewBg addSubview:firstLine];
    
    [firstLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself).offset(SCREEN_W/2-0.5);
        make.top.equalTo(wself.viewBg.top).offset(10);
        make.bottom.equalTo(wself.viewBg.bottom).offset(-10);
        make.width.equalTo(1);
    }];
    
    [self.lblPracticalAmountTxt makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(wself.viewBg).offset(15);
        make.right.equalTo(firstLine.left).offset(-15);
        make.height.equalTo(21);
    }];
    
    [self.lblPracticalAmount makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.lblPracticalAmountTxt);
        make.bottom.equalTo(wself.viewBg).offset(-15);
        make.height.equalTo(wself.lblPracticalAmountTxt);
    }];
    
    [self.lblMemberRechargeTxt makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblPracticalAmountTxt.top);
        make.right.equalTo(wself.viewBg.right).offset(-15);
        make.width.height.equalTo(wself.lblPracticalAmountTxt);
    }];
    
    [self.lblMemberRecharge makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblPracticalAmount.top);
        make.right.equalTo(wself.lblMemberRechargeTxt);
        make.width.height.equalTo(wself.lblPracticalAmount);
    }];
}

- (void)setShiftHeader :(LSUserHandoverVo *)obj {
    _userHandoverVo = obj;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:obj.filePath] placeholderImage:[UIImage imageNamed:@"img_default"]];
    
    NSString *sex = nil;
    if ([obj.sex  isEqual: @1]) {
        sex = @"男";
    } else if ([obj.sex  isEqual: @2]){
        sex = @"女";
    }else {
        sex = @"-";
    }
    self.lblName.text = [NSString stringWithFormat:@"%@(%@)",obj.userName,sex];
    
    self.lblNum.text = [NSString stringWithFormat:@"工号:%@",obj.staffId];
    
    //交接班详情的所属门店仅连锁时显示，单店不显示门店
    if ([[Platform Instance] getShopMode] != 1) {
        if ([NSString isNotBlank:self.shopName]) {
            self.lblShop.text = [NSString stringWithFormat:@"门店:%@",self.shopName];
        }
    }
    
    if ([ObjectUtil isNotNull:obj.startWorkTime]) {
        self.lblStartTime.text = [DateUtils formateTime:[obj.startWorkTime longLongValue]];
    }
    
    if ([ObjectUtil isNotNull:obj.endWorkTime]) {
        self.lblEndTime.text = [DateUtils formateTime:[obj.endWorkTime longLongValue]];
    }
    
    if ([NSString isNotBlank:obj.roleName]) {
        self.lblRole.text = obj.roleName;
    }
    
    if ([obj.handoverSrc  isEqual: @3]) {
        
        if ([ObjectUtil isNotNull:obj.recieveAmount]) {
            self.lblPracticalAmountTxt.text = @"销售实收（元）";
            self.lblPracticalAmount.text = [NSString stringWithFormat:@"%.2f",[obj.recieveAmount doubleValue]];
        }
        
        if ([ObjectUtil isNotNull:obj.chargeAmount]) {
            self.lblMemberRechargeTxt.text = @"会员充值实收（元)";
            self.lblMemberRecharge.text = [NSString stringWithFormat:@"%.2f",[obj.chargeAmount doubleValue]];
        }
    } else {
        
        if ([ObjectUtil isNotNull:obj.totalResultAmount])  {
            self.lblPracticalAmountTxt.text = @"应收金额（元）";
            self.lblPracticalAmount.text = [NSString stringWithFormat:@"%.2f",[obj.totalResultAmount doubleValue]];
        }
        
        if ([ObjectUtil isNotNull:obj.totalRecieveAmount])  {
            self.lblMemberRechargeTxt.text = @"实收金额（元）";
            self.lblMemberRecharge.text = [NSString stringWithFormat:@"%.2f",[obj.totalRecieveAmount doubleValue]];
        }
    }
    
    [self layoutIfNeeded];
}

@end

