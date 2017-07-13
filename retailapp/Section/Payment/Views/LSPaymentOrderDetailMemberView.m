//
//  LSPaymentOrderDetailMemberView.m
//  retailapp
//
//  Created by guozhi on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPaymentOrderDetailMemberView.h"
@interface LSPaymentOrderDetailMemberView ()
/** 会员头像 */
@property (nonatomic, strong) UIImageView *imgViewIcon;
/** 会员名字（手机号） */
@property (nonatomic, strong) UILabel *lblNameAndTel;
/** 会员卡类型 */
@property (nonatomic, strong) UILabel *lblType;
/** 优惠 */
@property (nonatomic, strong) UILabel *lblDiscount;
/** 积分 */
@property (nonatomic, strong) UILabel *lblIntegral;
/** 余额 */
@property (nonatomic, strong) UILabel *lblBalance;
/** 白色背景 */
@property (nonatomic, strong) UIView *viewBg;
/** 底部锯齿图片 */
@property (nonatomic, strong) UIImageView *imgViewBottom;
@end

@implementation LSPaymentOrderDetailMemberView

+ (instancetype)paymentOrderDetailMemberView {
    LSPaymentOrderDetailMemberView *view = [[LSPaymentOrderDetailMemberView alloc] init];
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
    self.lblNameAndTel = [[UILabel alloc] init];
    self.lblNameAndTel.font = [UIFont systemFontOfSize:15];
    self.lblNameAndTel.textColor = [ColorHelper getTipColor3];
    [self.viewBg addSubview:self.lblNameAndTel];
    //会员卡类型
    self.lblType = [[UILabel alloc] init];
    self.lblType.font = [UIFont systemFontOfSize:13];
    self.lblType.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblType];
    //本次积分
    self.lblIntegral = [[UILabel alloc] init];
    self.lblIntegral.font = [UIFont systemFontOfSize:13];
    self.lblIntegral.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblIntegral];
    //优惠
    self.lblDiscount = [[UILabel alloc] init];
    self.lblDiscount.font = [UIFont systemFontOfSize:13];
    self.lblDiscount.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblDiscount];
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
    [self.lblNameAndTel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgViewIcon.right).offset(10);
        make.top.equalTo(wself.imgViewIcon.top);
    }];
    //会员卡类型及卡号
    [self.lblType makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblNameAndTel.left);
        make.centerY.equalTo(wself.imgViewIcon.centerY);
    }];
    //本次积分
    [self.lblIntegral makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(wself.lblNameAndTel.left);
        make.bottom.equalTo(wself.imgViewIcon.bottom);
    }];
    //余额
    [self.lblBalance makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lblIntegral);
        make.right.equalTo(wself.viewBg.right).offset(-10);
    }];
    //优惠
    [self.lblDiscount makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lblType);
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

- (void)setPersonDetailVO:(LSPersonDetailVO *)personDetailVO {
    _personDetailVO = personDetailVO;
    //设置会员头像会员头像：若无，显示默认头像
    //暂无图片
    UIImage* placeholder = [UIImage imageNamed:@"img_nopic_user"];
    [self.imgViewIcon sd_setImageWithURL:[NSURL URLWithString:personDetailVO.picPath] placeholderImage:placeholder];
    //会员名称会员名称：若无，显示“无名氏”
    //设置会员名手机号
    NSString *txtName = personDetailVO.payName;
    txtName = [NSString text:txtName subToIndex:8];
    NSString *txtTel = [NSString stringWithFormat:@"（%@）",personDetailVO.mobile];
    NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc] initWithString:txtName attributes:@{NSForegroundColorAttributeName:[ColorHelper getTipColor6],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    NSMutableAttributedString *attrTel = [[NSMutableAttributedString alloc] initWithString:txtTel attributes:@{NSForegroundColorAttributeName:[ColorHelper getTipColor6]}];
    [attrName appendAttributedString:attrTel];
    self.lblNameAndTel.attributedText = attrName;
    
    //设置会员卡类型
    self.lblType.text = personDetailVO.kindCardName;
    //设置优惠方式
    if ([ObjectUtil isNotNull:personDetailVO.Ratioway]) {
        NSString *txtRation = [NSString stringWithFormat:@"优惠：%@",personDetailVO.Ratioway];
        self.lblDiscount.text = txtRation;
    }
   
    //设置积分
    if ([ObjectUtil isNotNull:personDetailVO.degree]) {
        NSString *txtIntergal = [NSString stringWithFormat:@"积分：%@分",self.personDetailVO.degree];
        self.lblIntegral.text = txtIntergal;
    }
   
    
    //设置余额
    if ([ObjectUtil isNotNull:personDetailVO.balance]) {
        NSString *txtBalance = [NSString stringWithFormat:@"余额：%.2f",self.personDetailVO.balance.doubleValue];
        self.lblBalance.text = txtBalance;
    }
    [self layoutIfNeeded];
    //余额先隐掉
    self.lblBalance.hidden = YES;
    self.ls_height = self.imgViewBottom.ls_bottom;

}

@end
