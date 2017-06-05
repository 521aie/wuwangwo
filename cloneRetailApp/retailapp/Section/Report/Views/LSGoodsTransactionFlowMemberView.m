//
//  LSGoodsTransactionFlowMemberView.m
//  retailapp
//
//  Created by guozhi on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsTransactionFlowMemberView.h"
@interface LSGoodsTransactionFlowMemberView ()
/** 会员头像 */
@property (nonatomic, strong) UIImageView *imgViewIcon;
/** 会员名字 */
@property (nonatomic, strong) UILabel *lblName;
/** 会员卡类型及卡号 */
@property (nonatomic, strong) UILabel *lblTypeAndCradNumber;
/** 本次积分 */
@property (nonatomic, strong) UILabel *lblIntegral;
/** 余额 */
@property (nonatomic, strong) UILabel *lblBalance;
/** 白色背景 */
@property (nonatomic, strong) UIView *viewBg;
/** 底部锯齿图片 */
@property (nonatomic, strong) UIImageView *imgViewBottom;
@end

@implementation LSGoodsTransactionFlowMemberView

+ (instancetype)goodsTransactionFlowMemberView {
    LSGoodsTransactionFlowMemberView *view = [[LSGoodsTransactionFlowMemberView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_W, view.ls_height);
    return view;
}
- (instancetype)init {
    if (self = [super init]) {
        [self configViews];
        [self configConstraints];
    }
    return self;
}

- (void)configViews {
    self.backgroundColor = [UIColor clearColor];
    //中间白色背景
    self.viewBg = [[UIView alloc] init];
    self.viewBg.backgroundColor = [UIColor whiteColor];
    self.viewBg.alpha = 0.8;
    [self addSubview:self.viewBg];
    //会员头像
    self.imgViewIcon = [[UIImageView alloc] init];
    self.imgViewIcon.layer.cornerRadius = 4;
    self.imgViewIcon.layer.masksToBounds = YES;
    [self.viewBg addSubview:self.imgViewIcon];
    //会员名字
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:15];
    self.lblName.textColor = [ColorHelper getTipColor3];
    [self.viewBg addSubview:self.lblName];
    //会员卡类型及卡号
    self.lblTypeAndCradNumber = [[UILabel alloc] init];
    self.lblTypeAndCradNumber.font = [UIFont systemFontOfSize:13];
    self.lblTypeAndCradNumber.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblTypeAndCradNumber];
    //本次积分
    self.lblIntegral = [[UILabel alloc] init];
    self.lblIntegral.font = [UIFont systemFontOfSize:13];
    self.lblIntegral.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblIntegral];
    //余额
    self.lblBalance = [[UILabel alloc] init];
    self.lblBalance.font = [UIFont systemFontOfSize:13];
    self.lblBalance.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblBalance];
    //底部锯齿图片
    self.imgViewBottom = [[UIImageView alloc] init];
    self.imgViewBottom.image = [UIImage imageNamed:@"img_bill_btm"];
    self.imgViewBottom.alpha = 0.8;
    [self addSubview:self.imgViewBottom];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //中间白色背景
    [self.viewBg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.bottom.equalTo(wself.imgViewIcon.bottom).offset(10);
        make.top.equalTo(wself.top);
    }];
    //会员头像
    [self.imgViewIcon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.viewBg.top).offset(10);
        make.left.equalTo(wself.viewBg.left).offset(10);
        make.size.equalTo(60);
    }];
    //会员名字
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgViewIcon.right).offset(10);
        make.top.equalTo(wself.imgViewIcon.top);
    }];
    //会员卡类型及卡号
    [self.lblTypeAndCradNumber makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblName.left);
        make.centerY.equalTo(wself.imgViewIcon.centerY);
    }];
    //本次积分
    [self.lblIntegral makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(wself.lblName.left);
        make.bottom.equalTo(wself.imgViewIcon.bottom);
    }];
    //余额
    [self.lblBalance makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lblIntegral);
        make.right.equalTo(wself.viewBg.right).offset(-10);
    }];
    //底部锯齿图片
    [self.imgViewBottom makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.viewBg.bottom);
        make.height.equalTo(5);
    }];
    [self layoutIfNeeded];
    self.ls_height = self.imgViewBottom.ls_bottom;
}

/**
 设置交易流水会员信息

 @param orderReportVo 会员信息
 */
- (void)setOrderReportVo:(LSOrderReportVo *)orderReportVo {
    _orderReportVo = orderReportVo;
    //设置会员头像会员头像：若无，显示默认头像
    //暂无图片
    UIImage* placeholder = [UIImage imageNamed:@"img_nopic_user"];
    [self.imgViewIcon sd_setImageWithURL:[NSURL URLWithString:orderReportVo.memberHeaderImg] placeholderImage:placeholder];
    //会员名称会员名称：若无，显示“无名氏”
    NSString *memberName = orderReportVo.memberName;
    if ([NSString isBlank:memberName]) {
        memberName = @"无名氏";
    }
    self.lblName.text = memberName;
    //会员卡类型 & 卡号： {卡类型}  NO. {卡号}
    
    NSString *cardKind = orderReportVo.cardKind;
    //截取前16个字节可能放不下 
    cardKind = [NSString text:cardKind subToIndex:16];
    self.lblTypeAndCradNumber.text = [NSString stringWithFormat:@"%@ NO.%@", cardKind, orderReportVo.cardId];
    //本次积分
    if ([NSString isBlank:orderReportVo.cardKind]) {//退卡时没有会员卡类型 不显示这一项
        self.lblTypeAndCradNumber.hidden = YES;
        self.lblBalance.hidden = YES;
    }
    self.lblIntegral.text = [NSString stringWithFormat:@"本次积分：%d分", orderReportVo.memberCredits.intValue];
    //余额
    if ([ObjectUtil isNotNull:orderReportVo.balance]) {
        self.lblBalance.text = [NSString stringWithFormat:@"余额：%.2f元", orderReportVo.balance.doubleValue];
    } else {
        self.lblBalance.text = @"余额：0元";
    }
    
    [self layoutIfNeeded];
    //余额先隐掉
    self.lblBalance.hidden = YES;
    self.ls_height = self.imgViewBottom.ls_bottom;
}

@end
