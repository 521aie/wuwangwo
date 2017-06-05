//
//  LSPaymentOrderDetailRechargeBottomView.m
//  retailapp
//
//  Created by wuwangwo on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPaymentOrderDetailRechargeBottomView.h"
#import "OnlineChargeVo.h"
#import "OrderInfoVo.h"
#import "DateUtils.h"
#import "ObjectUtil.h"

@interface LSPaymentOrderDetailRechargeBottomView ()

/** 白色背景 */
@property (nonatomic, strong) UIView *viewBg;
/** 顶部锯齿图片 */
@property (nonatomic, strong) UIImageView *imgViewTop;
/** 底部锯齿图片 */
@property (nonatomic, strong) UIImageView *imgViewBottom;
/** 付款金额*/
@property (nonatomic,strong) UILabel *lblPayCountTex;
@property (nonatomic,strong) UILabel *lblPayCount;
/** 类型*/
@property (nonatomic,strong) UILabel *lblType;
/** line*/
@property (nonatomic,strong) UIView *viewLine;
/** 交易流水号*/
@property (nonatomic,strong) UILabel *lblSerialNum;
/** 充值方式*/
@property (nonatomic,strong) UILabel *lblRecharge;
/** 支付方式*/
@property (nonatomic,strong) UILabel *lblPayType;
/** 操作人*/
@property (nonatomic,strong) UILabel *lblOperater;
/** 充值时间*/
@property (nonatomic,strong) UILabel *lblRechargeTime;
@end

@implementation LSPaymentOrderDetailRechargeBottomView

+ (instancetype)paymentOrderDetailRechargeBottomView{
    
    LSPaymentOrderDetailRechargeBottomView *view = [[LSPaymentOrderDetailRechargeBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 210)];
    view.backgroundColor = [UIColor clearColor];
    [view configViews];
    [view configConstraints];
    
    return view;
}

- (void)configViews {
    
    //顶部图片
    self.imgViewTop = [[UIImageView alloc] init];
    self.imgViewTop.image = [UIImage imageNamed:@"img_bill_top"];
    self.imgViewTop.alpha = 0.8;
    [self addSubview:self.imgViewTop];
    
    //中间白色背景
    self.viewBg = [[UIView alloc] init];
    self.viewBg.backgroundColor = [UIColor whiteColor];
    self.viewBg.alpha = 0.8;
    [self addSubview:self.viewBg];
    
    //付款金额
    self.lblPayCountTex = [[UILabel alloc] init];
    self.lblPayCountTex.font = [UIFont systemFontOfSize:15];
    self.lblPayCountTex.textColor = [ColorHelper getBlackColor];
    self.lblPayCountTex.text = @"付款金额：";
    [self addSubview:self.lblPayCountTex];
    
    self.lblPayCount = [[UILabel alloc] init];
    self.lblPayCount.font = [UIFont systemFontOfSize:15];
    [self.viewBg addSubview:self.lblPayCount];
    
    //类型
    self.lblType = [[UILabel alloc] init];
    self.lblType.font = [UIFont systemFontOfSize:13];
    self.lblType.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblType];
    
    //
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.viewBg addSubview:self.viewLine];
    
    //交易流水号
    self.lblSerialNum = [[UILabel alloc] init];
    self.lblSerialNum.font = [UIFont systemFontOfSize:13];
    self.lblSerialNum.textColor = [ColorHelper getTipColor6];
    self.lblSerialNum.numberOfLines = 0;
    self.lblSerialNum.lineBreakMode = NSLineBreakByCharWrapping;
    [self.viewBg addSubview:self.lblSerialNum];
    
    //充值方式
    self.lblRecharge = [[UILabel alloc] init];
    self.lblRecharge.font = [UIFont systemFontOfSize:13];
    self.lblRecharge.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblRecharge];
    
    //支付方式
    self.lblPayType = [[UILabel alloc] init];
    self.lblPayType.font = [UIFont systemFontOfSize:13];
    self.lblPayType.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblPayType];
    
    //操作人
    self.lblOperater = [[UILabel alloc] init];
    self.lblOperater.font = [UIFont systemFontOfSize:13];
    self.lblOperater.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblOperater];
    
    //充值时间
    self.lblRechargeTime = [[UILabel alloc] init];
    self.lblRechargeTime.font = [UIFont systemFontOfSize:13];
    self.lblRechargeTime.textColor = [ColorHelper getTipColor6];
    [self.viewBg addSubview:self.lblRechargeTime];
    
    //底部锯齿图片
    self.imgViewBottom = [[UIImageView alloc] init];
    self.imgViewBottom.image = [UIImage imageNamed:@"img_bill_btm"];
    self.imgViewBottom.alpha = 0.8;
    [self addSubview:self.imgViewBottom];
}

- (void)configConstraints {
    
    __weak typeof(self) wself = self;
    CGFloat margin = 10.0f;
    
    //顶部图片
    [self.imgViewTop makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.top);
        make.height.equalTo(5);
    }];
    
    //中间白色背景
    [self.viewBg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.imgViewTop.bottom);
        make.left.right.equalTo(wself);
        make.bottom.equalTo(wself.bottom).offset(-5);
    }];
    
    [self.lblPayCountTex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(wself.viewBg).offset(10);
        make.width.equalTo(80);
        make.height.equalTo(15);
    }];
    
    [self.lblPayCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblPayCountTex.top);
        make.left.equalTo(wself.lblPayCountTex.right);
        make.right.equalTo(wself).offset(-margin);
        make.height.equalTo(wself.lblPayCountTex);
    }];
    
    [self.lblType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblPayCountTex.bottom).offset(margin);
        make.left.equalTo(wself.lblPayCountTex);
        make.right.equalTo(wself).offset(-margin);
        make.height.equalTo(13);
    }];
    
    [self.viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblType.bottom).offset(margin);
        make.left.right.equalTo(wself);
        make.height.equalTo(1);
    }];
    
    [self.lblSerialNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.viewLine.bottom).offset(margin);
        make.left.right.equalTo(wself.lblType);
        make.height.equalTo(wself.lblPayCount);
    }];
    
    [self.lblRecharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblSerialNum.bottom).offset(margin);
        make.left.right.equalTo(wself.lblSerialNum);
        make.height.equalTo(wself.lblSerialNum);
    }];
    
    [self.lblPayType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblRecharge.bottom).offset(margin);
        make.left.right.equalTo(wself.lblSerialNum);
        make.height.equalTo(wself.lblSerialNum);
    }];
    
    [self.lblOperater mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblPayType.bottom).offset(margin);
        make.left.right.equalTo(wself.lblSerialNum);
        make.height.equalTo(wself.lblSerialNum);
    }];
    
    [self.lblRechargeTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblOperater.bottom).offset(10);
        make.left.right.equalTo(self.lblSerialNum);
        make.height.equalTo(self.lblSerialNum);
    }];
    
    //底部锯齿图片
    [self.imgViewBottom makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.lblRechargeTime.bottom).offset(10);
        make.height.equalTo(5);
    }];
}

- (NSString *)getPayModeString:(short)status {
    
    //1:会员卡;2:优惠券;3:支付宝;4:支付宝;5:现金;6:微支付;99:其他'
    NSDictionary *statusDic = @{@"1":@"会员卡", @"2":@"优惠券", @"3":@"支付宝", @"4":@"银行卡", @"5":@"现金", @"6":@"[微信]", @"99":@"其他",@"8":@"[支付宝]",@"9":@"[微信]",@"50":@"货到付款",@"51":@"手动退款"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    
    if ([NSString isNotBlank:statusString]) {
        
        return statusString;
        
    } else {
        
        return @"";
    }
}

- (void)setRechargeOnlineChargeVo:(OnlineChargeVo *)onlineChargeVo settlements:(NSDictionary *)settlements{
    
    //付款金额
     if ([ObjectUtil isNotNull:onlineChargeVo.pay]) {
         
         self.lblPayCount.text = [NSString stringWithFormat:@"￥%@",onlineChargeVo.pay];
         
         if (onlineChargeVo.pay < 0) {
             
             self.lblPayCount.textColor = [ColorHelper getGreenColor];
             
         } else {
             
             self.lblPayCount.textColor = [ColorHelper getRedColor];
         }
    }
    
    //储值（额外赠送：）/计次服务：（名称），积分
    NSString *txt = nil;
    if ([ObjectUtil isNull:onlineChargeVo.free_rule]&& [ObjectUtil isNull:onlineChargeVo.free_degree]) {
       
        txt = @"";
        
    } else if ([self isNull:onlineChargeVo.free_rule]&& [self isNotNull:onlineChargeVo.free_degree]) {
        
        txt = [NSString stringWithFormat:@"额外赠送    %d积分",onlineChargeVo.free_degree.intValue];
        
    } else if ([self isNotNull:onlineChargeVo.free_rule]&& [self isNull:onlineChargeVo.free_degree]) {
        
        txt = [NSString stringWithFormat:@"额外赠送    ¥%.2f",onlineChargeVo.free_rule.doubleValue];
        
    } else if ([self isNotNull:onlineChargeVo.free_rule]&& [self isNotNull:onlineChargeVo.free_degree]) {
       
        txt = [NSString stringWithFormat:@"额外赠送    ¥%.2f，%d积分",onlineChargeVo.free_rule.doubleValue,onlineChargeVo.free_degree.intValue];
    }
    
    if ([NSString isNotBlank:txt]) {
        
        self.lblType.text = txt;
    }

    //充值流水号
    self.lblSerialNum.text = [NSString stringWithFormat:@"充值流水号 : %@",onlineChargeVo.serialNo];
    
    //充值方式:实体充值（计次服务暂只支持实体充值）
    if ([onlineChargeVo.channelType  isEqual: @1]) {
        
        self.lblRecharge.text = @"充值方式：实体充值";
        
    } else {
        
        self.lblRecharge.text = @"充值方式：微店充值";
    }
    
    //支付方式
    NSString *payMode = [self getPayModeString:onlineChargeVo.payMode];
    self.lblPayType.text = [NSString stringWithFormat:@"支付方式 : %@",payMode];
    
    //操作人
    if ([NSString isBlank:onlineChargeVo.operatorName] && [NSString isBlank:onlineChargeVo.operatorNo]) {
        
        self.lblOperater.hidden = YES;
        
        [self.lblRechargeTime remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblPayType.bottom).offset(10);
            make.left.right.equalTo(self.lblSerialNum);
            make.height.equalTo(self.lblSerialNum);
        }];
        
    }else{
        
        self.lblOperater.text = [NSString stringWithFormat:@"操作人 : %@(工号：%@)",onlineChargeVo.operatorName,onlineChargeVo.operatorNo];
    }
    
    //充值时间
    NSString *creatTime = [DateUtils formateTime:onlineChargeVo.createTime];
    
    if ([NSString isNotBlank:creatTime]) {
        
        self.lblRechargeTime.text = [NSString stringWithFormat:@"充值时间 : %@",creatTime];
    }
    
    [self layoutIfNeeded];
    self.ls_height = self.imgViewBottom.ls_bottom;
}

- (BOOL)isNull:(id)object
{
    if (object == nil || object == [NSNull null]) {
        
        return YES;
    }
    
    if ([object doubleValue] == 0.0) {
        
        return YES;
    }
    
    return NO;
}

- (BOOL)isNotNull:(id)object
{
    if (object != nil && object != [NSNull null] && [object doubleValue] != 0.0) {
        
        return YES;
    }
    
    return NO;
}

@end
