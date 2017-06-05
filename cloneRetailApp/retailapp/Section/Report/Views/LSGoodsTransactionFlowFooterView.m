//
//  LSGoodsTransactionFlowFooterView.m
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsTransactionFlowFooterView.h"
@interface LSGoodsTransactionFlowFooterView()
/** <#注释#> */
@property (nonatomic, strong) LSOrderReportVo *orderReportVo;
@end

@implementation LSGoodsTransactionFlowFooterView
+ (instancetype)goodsTransactionFlowFooterView {
    LSGoodsTransactionFlowFooterView *view = [[LSGoodsTransactionFlowFooterView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_W, 400);
    return view;
}

/**
 设置订单信息

 @param orderReportVo 订单信息
 @param settlements   
 settlements": [{
 "payCode": "现金123123",
 "payMoney": 44.99
	}, {
 "payCode": "[微信]",
 "payMoney": 0.01
	}]
 @param userorderopt  
 userorderopt": {
 "收银": "话梅(工号:1)"
	}
 */
- (void)setOrderReportVo:(LSOrderReportVo *)orderReportVo settlements:(NSArray *)settlements userorderopt:(NSArray *)userorderopt{
    self.backgroundColor = [UIColor clearColor];
    //白色背景
    UIView *viewBg = [[UIView alloc] init];
    viewBg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [self addSubview:viewBg];
    __weak typeof(self) wself = self;
    _orderReportVo = orderReportVo;
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
    //是否是销售单
    BOOL isOrder = orderReportVo.orderKind.integerValue == 1;
    //左边分割线
    UIView *viewLeftLine = [[UIView alloc] init];
    viewLeftLine.backgroundColor = [UIColor redColor];
    viewLeftLine.backgroundColor = lineColor;
    [self addSubview:viewLeftLine];
    [viewLeftLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(marginLine);
        make.top.equalTo(wself);
        make.width.equalTo(1);
    }];
    //右边分割线
    UIView *viewRightLine = [[UIView alloc] init];
    viewRightLine.backgroundColor = [UIColor brownColor];
    viewRightLine.backgroundColor = lineColor;
    [self addSubview:viewRightLine];
    [viewRightLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.right).offset(-marginLine);
        make.top.equalTo(wself);
        make.width.equalTo(1);
        make.bottom.equalTo(viewLeftLine);
    }];
    //商品合计
    UILabel *lblGoodsTotalName = [[UILabel alloc] init];
    lblGoodsTotalName.font = font;
    lblGoodsTotalName.text = @"商品合计";
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
    //原始费用加横线
    if (orderReportVo.shouldMoney.doubleValue != orderReportVo.totalmoney.doubleValue) {
        NSMutableAttributedString *attrVal = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", orderReportVo.shouldMoney.doubleValue] attributes:@{NSForegroundColorAttributeName : [ColorHelper getTipColor6]}];
        //下面开始是设置线条的风格：
        //第一个参数addAttribute:是设置要中线（删除线）还是下划线。
        //NSStrikethroughStyleAttributeName：这种是从文本中间穿过，也就是删除线。
        //NSUnderlineStyleAttributeName：这种是下划线。
        
        //第二个参数value：是设置线条的风格：虚线，实现，点线......
        //第二参数需要同时设置Pattern和style才能让线条显示。
        
        //第三个参数range:是设置线条的长度，切记，不能超过字符串的长度，否则会报错。
        [attrVal addAttributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle), NSBaselineOffsetAttributeName : @(0 )} range:NSMakeRange(0, attrVal.length)];
        
        //下列是设置线条的颜色
        //第一个参数就是选择设置中线的颜色还是下划线的颜色，如果上面选择的是中线，这里就要选择中线，否则颜色设置不上去。
        //第二个参数很简单，就是颜色而已。
        //第三个参数：同上。
        [attrVal addAttribute:NSStrikethroughColorAttributeName value:[ColorHelper getTipColor6] range:NSMakeRange(0, attrVal.length)];
        [attrVal appendAttributedString:[[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  ¥%.2f", orderReportVo.totalmoney.doubleValue] attributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleNone)}]]];
        lblGoodsTotalVal.attributedText = attrVal;
    } else {
        lblGoodsTotalVal.text = [NSString stringWithFormat:@"  ¥%.2f", orderReportVo.totalmoney.doubleValue];
    }
    topMargin = topMargin + height;
    if (isOrder) {//销售单
        if ([ObjectUtil isNotNull:orderReportVo.reducePrice] && orderReportVo.reducePrice.doubleValue != 0.0) {
            //满减合计
            UILabel *lblFullCutName = [[UILabel alloc] init];
            lblFullCutName.font = font;
            lblFullCutName.textColor  =leftLblColor;
            lblFullCutName.text = @"满减";
            [self addSubview:lblFullCutName];
            [lblFullCutName makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lblGoodsTotalName);
                make.top.equalTo(wself).offset(topMargin);
                make.height.equalTo(height);
            }];
            UILabel *lblFullCutVal = [[UILabel alloc] init];
            lblFullCutVal.font = font;
            lblFullCutVal.textColor = [ColorHelper getTipColor6];
            lblFullCutVal.text = [NSString stringWithFormat:@"-¥%.2f", orderReportVo.reducePrice.doubleValue];
            [self addSubview:lblFullCutVal];
            [lblFullCutVal makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(lblGoodsTotalVal);
                make.top.equalTo(wself).offset(topMargin);
                make.height.equalTo(height);
            }];
            topMargin = topMargin + height;
        }
        //整单折扣
        if ([ObjectUtil isNotNull:orderReportVo.wholeDiscountFee] && orderReportVo.wholeDiscountFee.doubleValue != 0.0) {
            UILabel *lblSingleDiscountName = [[UILabel alloc] init];
            lblSingleDiscountName.font = font;
            lblSingleDiscountName.textColor  =leftLblColor;
            lblSingleDiscountName.text = @"整单折扣";
            [self addSubview:lblSingleDiscountName];
            [lblSingleDiscountName makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lblGoodsTotalName);
                make.top.equalTo(wself).offset(topMargin);
                make.height.equalTo(height);
            }];
            UILabel *lblSingleDiscountVal = [[UILabel alloc] init];
            lblSingleDiscountVal.font = font;
            lblSingleDiscountVal.textColor = [ColorHelper getTipColor6];
            lblSingleDiscountVal.text = [NSString stringWithFormat:@"-¥%.2f", orderReportVo.wholeDiscountFee.doubleValue];
            [self addSubview:lblSingleDiscountVal];
            [lblSingleDiscountVal makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(lblGoodsTotalVal);
                make.top.equalTo(wself).offset(topMargin);
                make.height.equalTo(height);
            }];
            topMargin = topMargin + height;
        }
        //配送费
        if ([orderReportVo.outType isEqualToString:@"weixin"]) { //微店订单才有配送费
            UILabel *lblOutFeeName = [[UILabel alloc] init];
            lblOutFeeName.font = font;
            lblOutFeeName.textColor  =leftLblColor;
            lblOutFeeName.text = @"配送费";
            [self addSubview:lblOutFeeName];
            [lblOutFeeName makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lblGoodsTotalName);
                make.top.equalTo(wself).offset(topMargin);
                make.height.equalTo(height);
            }];
            UILabel *lblOutFeeVal = [[UILabel alloc] init];
            lblOutFeeVal.font = font;
            lblOutFeeVal.textColor = [ColorHelper getTipColor6];
            lblOutFeeVal.text = [NSString stringWithFormat:@"¥%.2f", orderReportVo.outFee.doubleValue];
            [self addSubview:lblOutFeeVal];
            [lblOutFeeVal makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(lblGoodsTotalVal);
                make.top.equalTo(wself).offset(topMargin);
                make.height.equalTo(height);
            }];
            topMargin = topMargin + height;
        }
    }
    //上方下划线
    topMargin = topMargin + margin;
    UIView *viewTopLine = [[UIView alloc] init];
    viewTopLine .backgroundColor = lineColor;
    [self addSubview:viewTopLine];
    [viewTopLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewLeftLine);
        make.right.equalTo(viewRightLine);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(1);
    }];
    topMargin = topMargin + 1 + margin;
    //应收金额 应退金额
    UILabel *lblShouldAmountName = [[UILabel alloc] init];
    lblShouldAmountName.font = font;
    lblShouldAmountName.textColor  =leftLblColor;
    if (isOrder) {//销售订单
         lblShouldAmountName.text = @"应收金额";
    } else {
         lblShouldAmountName.text = @"应退金额";
    }
   
    [self addSubview:lblShouldAmountName];
    [lblShouldAmountName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblGoodsTotalName);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(height);
    }];
    UILabel *lblShouldAmountVal = [[UILabel alloc] init];
    lblShouldAmountVal.font = font;
    lblShouldAmountVal.textColor = [ColorHelper getRedColor];
    lblShouldAmountVal.text = [NSString stringWithFormat:@"¥%.2f", orderReportVo.resultMoney.doubleValue];
    [self addSubview:lblShouldAmountVal];
    [lblShouldAmountVal makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lblGoodsTotalVal);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(height);
    }];
    topMargin = topMargin + height;
    //实收金额 实退金额
    UILabel *lblActualAmountName = [[UILabel alloc] init];
    lblActualAmountName.font = font;
    lblActualAmountName.textColor  =leftLblColor;
    if (isOrder) {//销售订单
        lblActualAmountName.text = @"实收金额";
    } else {
        lblActualAmountName.text = @"实退金额";
    }
    
    [self addSubview:lblActualAmountName];
    [lblActualAmountName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblGoodsTotalName);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(height);
    }];
    UILabel *lblActualAmountVal = [[UILabel alloc] init];
    lblActualAmountVal.font = font;
    lblActualAmountVal.textColor = [ColorHelper getRedColor];
    lblActualAmountVal.text = [NSString stringWithFormat:@"¥%.2f", orderReportVo.discountAmount.doubleValue];
    [self addSubview:lblActualAmountVal];
    [lblActualAmountVal makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lblGoodsTotalVal);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(height);
    }];
    topMargin = topMargin + height;
    //不计入销售额 销售单才有
    if (isOrder && orderReportVo.includedSalesAmount.doubleValue != 0) {
        UILabel *lblNotIncludeSalesName = [[UILabel alloc] init];
        lblNotIncludeSalesName.font = font;
        lblNotIncludeSalesName.textColor  =leftLblColor;
        lblNotIncludeSalesName.text = @"不计入销售额";
        [self addSubview:lblNotIncludeSalesName];
        [lblNotIncludeSalesName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lblGoodsTotalName);
            make.top.equalTo(wself).offset(topMargin);
            make.height.equalTo(height);
        }];
        UILabel *lblNotIncludeSalesVal = [[UILabel alloc] init];
        lblNotIncludeSalesVal.font = font;
        lblNotIncludeSalesVal.textColor = [ColorHelper getRedColor];
        lblNotIncludeSalesVal.text = [NSString stringWithFormat:@"¥%.2f", orderReportVo.includedSalesAmount.doubleValue];
        [self addSubview:lblNotIncludeSalesVal];
        [lblNotIncludeSalesVal makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lblGoodsTotalVal);
            make.top.equalTo(wself).offset(topMargin);
            make.height.equalTo(height);
        }];
        topMargin = topMargin + height;
    }
    //损益
    if (orderReportVo.loss.doubleValue != 0) {
        UILabel *lblLossName = [[UILabel alloc] init];
        lblLossName.font = font;
        lblLossName.textColor  =leftLblColor;
        lblLossName.text = @"损益";
        [self addSubview:lblLossName];
        [lblLossName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lblGoodsTotalName);
            make.top.equalTo(wself).offset(topMargin);
            make.height.equalTo(height);
        }];
        UILabel *lblLossVal = [[UILabel alloc] init];
        lblLossVal.font = font;
        if (isOrder) {//销售单
            lblLossVal.textColor = [ColorHelper getGreenColor];
        } else {
            lblLossVal.textColor = [ColorHelper getRedColor];
        }
        CGFloat loss = fabs(orderReportVo.loss.doubleValue);
        if (orderReportVo.loss.doubleValue < 0) {
             lblLossVal.text = [NSString stringWithFormat:@"-¥%.2f", loss];
        } else {
             lblLossVal.text = [NSString stringWithFormat:@"¥%.2f", loss];
        }
       
        [self addSubview:lblLossVal];
        [lblLossVal makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lblGoodsTotalVal);
            make.top.equalTo(wself).offset(topMargin);
            make.height.equalTo(height);
        }];
        topMargin = topMargin + height;

    }
    //中间横线
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
    //支付明细
    UILabel *lblPayDetailName = [[UILabel alloc] init];
    lblPayDetailName.font = font;
    lblPayDetailName.textColor  =leftLblColor;
    lblPayDetailName.text = @"支付明细";
    [self addSubview:lblPayDetailName];
    [lblPayDetailName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblGoodsTotalName);
        make.top.equalTo(wself).offset(topMargin);
    }];
    UILabel *lblPayDetailVal = [[UILabel alloc] init];
    lblPayDetailVal.font = font;
    lblPayDetailVal.textColor = [ColorHelper getBlueColor];
    lblPayDetailVal.numberOfLines = 0;
    lblPayDetailVal.textAlignment = NSTextAlignmentRight;
    /*settlements": [{
    "payCode": "现金123123",
    "payMoney": 44.99
}, {
    "payCode": "[微信]",
    "payMoney": 0.01
}],*/
    NSMutableString *payDetailStr = [NSMutableString string];
    [settlements enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *payCode = obj[@"payCode"];
        NSString *payMoney = obj[@"payMoney"];
        if (isOrder) {//销售单
            [payDetailStr appendFormat:@" , %@ : ¥%.2f", payCode, payMoney.doubleValue];
        } else {//退货单
            [payDetailStr appendFormat:@" , %@ : -¥%.2f", payCode, payMoney.doubleValue];
        }
        
    }];
    if (payDetailStr.length > 3) {//有可能是空的
        lblPayDetailVal.text = [payDetailStr substringFromIndex:3];
    }
    [self addSubview:lblPayDetailVal];
    [self layoutIfNeeded];
    [lblPayDetailVal makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lblGoodsTotalVal);
        make.top.equalTo(wself).offset(topMargin);
        make.left.equalTo(lblPayDetailName.right).offset(20);
    }];
    [self layoutIfNeeded];
    
    topMargin = MAX(lblPayDetailName.ls_bottom, lblPayDetailVal.ls_bottom) + 5;
    //下方横线
    UIView *viewBottomLine = [[UIView alloc] init];
    viewBottomLine.backgroundColor = lineColor;
    [self addSubview:viewBottomLine];
    [viewBottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewLeftLine);
        make.right.equalTo(viewRightLine);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(1);
    }];
    [viewLeftLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewBottomLine.bottom);
    }];
    
    //订单来源
    topMargin = topMargin + margin + 1;
    UILabel *lblOrderSource = [[UILabel alloc] init];
    lblOrderSource.font = font;
    lblOrderSource.textColor  = [ColorHelper getTipColor6];
    if ([orderReportVo.outType isEqualToString:@"weixin"]) {
        lblOrderSource.text = @"订单来源 : 微店订单";
    } else {
        lblOrderSource.text = @"订单来源 : 实体订单";
    }
    [self addSubview:lblOrderSource];
    height = 20;
    [lblOrderSource makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblGoodsTotalName);
        make.top.equalTo(wself).offset(topMargin);
        make.height.equalTo(height);
    }];
    topMargin = topMargin + height;

    //交易门店：单店模式下隐藏该字段，在连锁模式下，在微店的消费记录，显示该微店所属的实体门店名称
    if ([[Platform Instance] getShopMode] != 1){
        //交易门店
        UILabel *lblTransactionShop = [[UILabel alloc] init];
        lblTransactionShop.font = font;
        lblTransactionShop.textColor  = [ColorHelper getTipColor6];
        lblTransactionShop.text = [NSString stringWithFormat:@"交易门店 : %@",orderReportVo.shopName];
        [self addSubview:lblTransactionShop];
        [lblTransactionShop makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lblGoodsTotalName);
            make.top.equalTo(wself).offset(topMargin);
            make.height.equalTo(height);
        }];
        topMargin = topMargin + height;
    }
    /*收银userorderopt": [{
     "payCode": null,
     "payMoney": null,
     "outType": "收银",
     "userName": "话梅(工号:1)"
     }]*/
    if ([ObjectUtil isNotEmpty:userorderopt]) {
        [userorderopt enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *lblOperator = [[UILabel alloc] init];
            lblOperator.font = font;
            lblOperator.textColor  = [ColorHelper getTipColor6];
            lblOperator.text = [NSString stringWithFormat:@"%@ : %@", obj[@"outType"], obj[@"userName"]];
            [self addSubview:lblOperator];
            [lblOperator makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lblGoodsTotalName);
                make.top.equalTo(wself).offset(topMargin);
                make.height.equalTo(height);
            }];
            topMargin = topMargin + height;
        }];
       
    }
    
    /*备注备注
    未添加备注时，该行隐藏；
    显示全部备注内容，显示不下则换行显示*/
    NSString *text = @"";
    if ([NSString isNotBlank:_orderReportVo.memo]&&[NSString isNotBlank:_orderReportVo.salesInfo]) {
        text = [NSString stringWithFormat:@"%@\n%@",_orderReportVo.memo,_orderReportVo.salesInfo];
    } else if ([NSString isNotBlank:_orderReportVo.memo]) {
        text = _orderReportVo.memo;
    } else {
        text = _orderReportVo.salesInfo;
    }
    if ([NSString isNotBlank:text]) {
        UILabel *lblRemark = [[UILabel alloc] init];
        lblRemark.font = font;
        lblRemark.textColor  = [ColorHelper getTipColor6];
        lblRemark.numberOfLines = 0;
        lblRemark.text = [NSString stringWithFormat:@"备注 : %@",text];
        [self addSubview:lblRemark];
        [lblRemark makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lblGoodsTotalName);
            make.right.equalTo(lblGoodsTotalVal);
            make.top.equalTo(wself).offset(topMargin);
        }];
        [self layoutIfNeeded];
        topMargin = lblRemark.ls_bottom;
    }
    
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


@end
