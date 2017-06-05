//
//  LSPaymentOrderDetailFooterView.m
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPaymentOrderDetailFooterView.h"
@interface LSPaymentOrderDetailFooterView()
@end

@implementation LSPaymentOrderDetailFooterView
+ (instancetype)paymentOrderDetailFooterView {
    LSPaymentOrderDetailFooterView *view = [[LSPaymentOrderDetailFooterView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_W, 400);
    return view;
}
- (void)setOrderInfoVo:(OrderInfoVo *)orderInfoVo onlineChargeVo:(OnlineChargeVo *)onlineChargeVo settlements:(NSDictionary *)settlements {
    self.backgroundColor = [UIColor clearColor];
    //白色背景
    UIView *viewBg = [[UIView alloc] init];
    viewBg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [self addSubview:viewBg];
    __weak typeof(self) wself = self;
    //每一行的高度
    CGFloat height = 25;
    //分割线距离左右的间距
    CGFloat marginLine = 10;
    //内容距离分割线的间距
    CGFloat margin = 5;
    UIColor *lineColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    //左边文字的颜色
    UIColor *leftLblColor = [ColorHelper getTipColor3];
    //字体的大小
    UIFont *font = [UIFont systemFontOfSize:13];
    //当前控件距离顶部的距离
    __block CGFloat topMargin = margin;
    //左边分割线
    UIView *viewLeftLine = [[UIView alloc] init];
    viewLeftLine.backgroundColor = [UIColor redColor];
    viewLeftLine.backgroundColor = lineColor;
    [self addSubview:viewLeftLine];
    //右边分割线
    UIView *viewRightLine = [[UIView alloc] init];
    viewRightLine.backgroundColor = [UIColor brownColor];
    viewRightLine.backgroundColor = lineColor;
    [self addSubview:viewRightLine];
    //商品合计总价 配送费
    UILabel *lblGoodsTotalName = [[UILabel alloc] init];
    lblGoodsTotalName.font = font;
    lblGoodsTotalName.text = @"合计";
    lblGoodsTotalName.textColor = leftLblColor;
    [self addSubview:lblGoodsTotalName];
    [lblGoodsTotalName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewLeftLine.left).offset(margin);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(height);
    }];
    UILabel *lblGoodsTotalVal = [[UILabel alloc] init];
    lblGoodsTotalVal.font = font;
    lblGoodsTotalVal.textColor = leftLblColor;
    [self addSubview:lblGoodsTotalVal];
    [lblGoodsTotalVal makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewRightLine.right).offset(-margin);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(height);
    }];
    //订单金额(元)
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", orderInfoVo.resultAmount]
                                                                             attributes:@{NSForegroundColorAttributeName:RGB(204, 0, 0)}];
    if (orderInfoVo.outFee > 0) {
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (含配送费：¥%.2f)", orderInfoVo.outFee]
                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[ColorHelper getTipColor6]}]];
    } else {
        if ([orderInfoVo.outType isEqualToString:@"weixin"]) {
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@" (免配送费)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[ColorHelper getTipColor6] }]];
        }
    }
    lblGoodsTotalVal.attributedText = attr;
    topMargin = topMargin + height;
    //底部横线
    topMargin = topMargin + margin;
    UIView *viewCenterLine = [[UIView alloc] init];
    viewCenterLine.backgroundColor = lineColor;
    [self addSubview:viewCenterLine];
    [viewCenterLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewLeftLine);
        make.right.equalTo(viewRightLine);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(1);
    }];
    topMargin = topMargin + 1 + margin;
    //左边分割线约束
    [viewLeftLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(marginLine);
        make.top.equalTo(wself);
        make.width.equalTo(1);
        make.bottom.equalTo(viewCenterLine.top);
    }];
    //右边分割线约束
    [viewRightLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.right).offset(-marginLine);
        make.top.equalTo(wself);
        make.width.equalTo(1);
        make.bottom.equalTo(viewCenterLine.top);
    }];
    [self layoutIfNeeded];
    //订单状态
    topMargin = topMargin + margin + 1;
     NSString *txtStatus = [self getStatusString:orderInfoVo.status];
    if ([NSString isNotBlank:txtStatus]) {
        UILabel *lblOrderStatus = [[UILabel alloc] init];
        lblOrderStatus.font = font;
        lblOrderStatus.textColor  = [ColorHelper getTipColor6];
        lblOrderStatus.text = [NSString stringWithFormat:@"订单状态：%@", txtStatus];
        [self addSubview:lblOrderStatus];
        height = 20;
        [lblOrderStatus makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lblGoodsTotalName);
            make.top.equalTo(wself).offset(topMargin);
            make.height.equalTo(height);
        }];
        topMargin = topMargin + height;

    }
    //订单来源
    UILabel *lblOrderSource = [[UILabel alloc] init];
    lblOrderSource.font = font;
    lblOrderSource.textColor  = [ColorHelper getTipColor6];
    if ([orderInfoVo.outType isEqualToString:@"weixin"]) {
        lblOrderSource.text = @"订单来源 : 微店订单";
    } else {
        lblOrderSource.text = @"订单来源 : 实体订单";
    }
    [self addSubview:lblOrderSource];
    [lblOrderSource makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblGoodsTotalName);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(height);
    }];
    topMargin = topMargin + height;
    height = 20;
    //支付方式
    UILabel *lblPayType = [[UILabel alloc] init];
    lblPayType.font = font;
    lblPayType.textColor = [ColorHelper getTipColor6];
    lblPayType.numberOfLines = 0;
    //支付方式
    NSString *txtPayType = @"";
    txtPayType = [self getPayModeString:orderInfoVo.payMode];
    NSString *is_cash = [NSString stringWithFormat:@"%@",orderInfoVo.is_cash_on_delivery];
    if ([ObjectUtil isNotNull:orderInfoVo.is_cash_on_delivery] && ![is_cash isEqualToString:@"null"]) {
        txtPayType = [NSString stringWithFormat:@"%@（货到付款）", txtPayType];
    }
    if (orderInfoVo.payMode == 0) {
        if ([ObjectUtil isNotNull:settlements]) {
            for (NSString *key in settlements.allKeys) {
                NSString *val = [NSString stringWithFormat:@"%.2f",[settlements[key] doubleValue]];
                txtPayType = [txtPayType stringByAppendingString:[NSString stringWithFormat:@"\n                  %@   %@元",key,val]];
            }
            if ([txtPayType hasPrefix:@"\n                  "]) {
                txtPayType = [txtPayType substringFromIndex:19];
            }
        }
    }
    lblPayType.text = [NSString stringWithFormat:@"支付方式：%@",txtPayType];
    [self addSubview:lblPayType];
    
    [lblPayType makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblGoodsTotalName);
        make.top.equalTo(wself).offset(topMargin);
    }];
    [self layoutIfNeeded];
    topMargin = lblPayType.ls_bottom + 20;
    topMargin = topMargin + 40;
    //设置白色背景
    [viewBg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.height.equalTo(topMargin);
        make.top.equalTo(wself);
    }];
    //设置底部图片
    
    //底部图片
    UIImageView *imgViewBottom = [[UIImageView alloc] init];
    imgViewBottom.image = [UIImage imageNamed:@"img_bill_btm"];
    imgViewBottom.alpha = 0.8;
    [self addSubview:imgViewBottom];
    [imgViewBottom makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(5);
    }];
    topMargin = topMargin + 5;
    self.ls_height = topMargin + 40;

    
}
- (NSString *)getStatusString:(short)status {
    //销售订单  状态:11待付款、12付款中、13待分配、15待处理、20配送中、21交易成功、16拒绝配送、22交易取消、23交易关闭 24配送完成
    NSDictionary *statusDic = @{ @"11":@"待付款", @"13":@"待分配", @"15":@"待处理", @"16":@"拒绝配送", @"20":@"配送中", @"21":@"交易成功", @"22":@"交易取消", @"23":@"交易关闭",@"24":@"配送完成"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

- (NSString *)getPayModeString:(short)status {
    //1:会员卡;2:优惠券;3:支付宝;4:支付宝;5:现金;6:微支付;99:其他'
    NSDictionary *statusDic = @{@"1":@"会员卡", @"2":@"优惠券", @"3":@"支付宝", @"4":@"银行卡", @"5":@"现金", @"6":@"[微信]", @"99":@"其他",@"8":@"[支付宝]",@"9":@"[微信]",@"50":@"货到付款",@"51":@"手动退款", @"52":@"[QQ钱包]"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}


@end
