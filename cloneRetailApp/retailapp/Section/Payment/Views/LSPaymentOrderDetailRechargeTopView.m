//
//  LSPaymentOrderDetailRechargeTopView.m
//  retailapp
//
//  Created by wuwangwo on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPaymentOrderDetailRechargeTopView.h"
#import "LSPersonDetailVO.h"

@interface LSPaymentOrderDetailRechargeTopView ()

/** 白色背景 */
@property (nonatomic, strong) UIView *viewBg;
/** 会员头像 */
@property (nonatomic, strong) UIImageView *imgViewIcon;
/** 会员名字（手机号） */
@property (nonatomic, strong) UILabel *lblNameAndTel;
/** 会员卡类型 */
@property (nonatomic, strong) UILabel *lblType;
/** 卡号 */
@property (nonatomic, strong) UILabel *lblCardNum;
/** 底部锯齿图片 */
@property (nonatomic, strong) UIImageView *imgViewBottom;
@end

@implementation LSPaymentOrderDetailRechargeTopView

+ (instancetype)paymentOrderDetailRechargeTopView{
    
    LSPaymentOrderDetailRechargeTopView *view = [[LSPaymentOrderDetailRechargeTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 85)];
    view.backgroundColor = [UIColor clearColor];
    [view configViews];
    [view configConstraints];
    
    return view;
}

- (void)configViews {
    
    //中间白色背景
    self.viewBg = [[UIView alloc] init];
    self.viewBg.backgroundColor = [UIColor whiteColor];
    self.viewBg.alpha = 0.8;
    [self addSubview:self.viewBg];
    
    //会员头像
    self.imgViewIcon = [[UIImageView alloc] init];
    self.imgViewIcon.layer.cornerRadius = 30;
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
    
    //余额
    self.lblCardNum = [[UILabel alloc] init];
    self.lblCardNum.font = [UIFont systemFontOfSize:13];
    self.lblCardNum.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblCardNum];
    
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
        make.top.equalTo(wself.top).offset(10);
        make.left.equalTo(wself.left).offset(10);
        make.size.equalTo(60);
    }];
    
    //会员名字
    [self.lblNameAndTel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgViewIcon.right).offset(10);
        make.top.equalTo(wself.imgViewIcon.top);
        make.height.equalTo(20);
    }];
    
    //会员卡类型
    [self.lblType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblNameAndTel.bottom);
        make.left.right.equalTo(wself.lblNameAndTel);
        make.height.equalTo(wself.lblNameAndTel);
    }];
    
    //卡号
    [self.lblCardNum makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblType.bottom);
        make.left.right.equalTo(wself.lblNameAndTel);
        make.bottom.equalTo(wself.imgViewIcon.bottom);
    }];
    
    //底部锯齿图片
    [self.imgViewBottom makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.viewBg.bottom);
        make.height.equalTo(5);
    }];
}

- (void)setPersonDetailVO:(LSPersonDetailVO *)personDetailVO cardNo:(NSString *)cardNo{
    
    //设置会员头像会员头像：若无，显示默认头像
    //暂无图片
    UIImage* placeholder = [UIImage imageNamed:@"img_nopic_user"];
    [self.imgViewIcon sd_setImageWithURL:[NSURL URLWithString:personDetailVO.picPath] placeholderImage:placeholder];
    
    //会员名称会员名称：若无，显示“无名氏”
    //设置会员名手机号
    NSString *txtName = personDetailVO.payName;
    txtName = [NSString text:txtName subToIndex:8];
    NSString *txtTel = [NSString stringWithFormat:@"（%@）",personDetailVO.mobile];
    NSMutableAttributedString *attrName,*attrTel;
    
    if ([NSString isNotBlank:txtName]) {
        
        attrName = [[NSMutableAttributedString alloc] initWithString:txtName attributes:@{NSForegroundColorAttributeName:[ColorHelper getTipColor6],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        
    }else{
        
        txtName = @"无名氏";
        attrName = [[NSMutableAttributedString alloc] initWithString:txtName attributes:@{NSForegroundColorAttributeName:[ColorHelper getTipColor6],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    }
    
    if ([NSString isNotBlank:txtTel]) {
        
        attrTel = [[NSMutableAttributedString alloc] initWithString:txtTel attributes:@{NSForegroundColorAttributeName:[ColorHelper getTipColor6]}];
        [attrName appendAttributedString:attrTel];
    }    
    self.lblNameAndTel.attributedText = attrName;
    
    //设置会员卡类型
    if ([NSString isNotBlank:personDetailVO.kindCardName]) {
        
        NSString *txtRation = [NSString stringWithFormat:@"%@ (优惠：%@)",personDetailVO.kindCardName,personDetailVO.Ratioway];
        self.lblType.text = txtRation;
    }
    
    //卡号
    if ([ObjectUtil isNotNull:cardNo]) {
        
        self.lblCardNum.text = [NSString stringWithFormat:@"No.%@",cardNo];
    }
    
    [self layoutIfNeeded];
}

@end
