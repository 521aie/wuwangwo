//
//  SRGoodsView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SRGoodsView.h"
#import "NSString+Estimate.h"

@implementation SRGoodsView


+ (SRGoodsView *)loadFromNib {
    SRGoodsView* titleView = [[[NSBundle mainBundle] loadNibNamed:@"SRGoodsView" owner:nil options:nil] objectAtIndex:0];
    [titleView configViews];
    return titleView;
}

- (void)configViews {
    //促销标志
    self.lblType.font = [UIFont systemFontOfSize:10];
    self.lblType.textColor = [UIColor whiteColor];
    self.lblType.backgroundColor = RGB(1, 178, 43);
    self.lblType.layer.cornerRadius = 4;
    self.lblType.layer.masksToBounds = YES;
    self.lblType.textAlignment = NSTextAlignmentCenter;
    //折扣率
    self.lblRatio.textColor = [ColorHelper getGreenColor];
    //折扣价
//    self.lblFinalRatioFee.textColor = [ColorHelper getTipColor3];

}
//积分兑换订单

// 退货商品
- (void)initData:(RetailInstanceVo *)retailInstanceVo {
    
    self.retailInstanceVo = retailInstanceVo;
    self.lblGoodsName.text = retailInstanceVo.originalGoodsName;
    NSString *code = nil;
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        //服鞋
        code = retailInstanceVo.innerCode;
    } else {
        code = retailInstanceVo.barCode;
    }
    self.lblBarCode.text = code?:@"";
    // 服鞋：显示尺码和颜色
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        self.lblColor.text = [NSString stringWithFormat:@"%@ %@", retailInstanceVo.colorVal, retailInstanceVo.sizeVal];
    } else {
        self.lblColor.text = @"";
    }
    self.lblFinalRatioFee.text = [NSString stringWithFormat:@"￥%.2f", retailInstanceVo.salesPrice];
    self.lblAccountNum.text = [NSString stringWithFormat:@"×%.0f", retailInstanceVo.accountNum];
    
    NSString *price = [NSString stringWithFormat:@"￥%.2f", retailInstanceVo.price];
    if([self.lblFinalRatioFee.text isEqualToString:price]){
        self.lblPrice.hidden = YES;
        self.lblFinalRatioFee.text = [NSString stringWithFormat:@"￥%.2f",retailInstanceVo.price];
    } else {
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:price
                                                                     attributes: @{ NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                    NSStrikethroughColorAttributeName:RGB(102, 102, 102)}];
        self.lblPrice.attributedText = attrStr;
    }
     [self updateSize1];
}

//销售订单
- (void)initOrderData:(InstanceVo *)instanceVo orderType:(int)orderType {
    self.instanceVo = instanceVo;
    self.lblGoodsName.text = instanceVo.originalGoodsName;
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
        self.lblBarCode.text = instanceVo.innerCode;
    } else {
        self.lblBarCode.text = instanceVo.barCode;
    }
    //颜色 尺码 服鞋版时表示
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue]==101) {
        self.lblColor.text = instanceVo.sku;
    } else {
        self.lblColor.text = @"";
    }
    
    //购买数量
    self.lblAccountNum.text = [NSString stringWithFormat:@"×%.0f", instanceVo.accountNum];
    self.lblFinalRatioFee.text = [NSString stringWithFormat:@"￥%.2f", instanceVo.sales_price];
    if (instanceVo.price == instanceVo.sales_price) {
        self.lblPrice.text = @"";
         [self.lblType setHidden:YES];
        self.lblRatio.hidden = YES;
    } else {
        NSString *price = [NSString stringWithFormat:@"￥%.2f", instanceVo.price];
        
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:price
                                                                     attributes: @{ NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                    NSStrikethroughColorAttributeName:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]}];
        self.lblPrice.attributedText = attrStr;
    }
    //折扣率
    self.lblRatio.text = [NSString stringWithFormat:@"%.2f%%", instanceVo.ratio];
    //设置促销标志
    int discountType = instanceVo.discountType;
    if (0 == discountType) {
        [self.lblType setHidden:YES];
    } else if (1 == discountType) {
        self.lblType.text = @"会";
    } else if (2 == discountType) {
        self.lblType.text = @"折";
    } else if (3 == discountType) {
        self.lblType.text = @"赠";
    } else if (4 == discountType) {
        self.lblType.text = @"换";
    } else if (5 == discountType) {
        self.lblType.text = @"特";
    } else if (6 == discountType) {
        self.lblType.text = @"批";
    } else if (7 == discountType) {
        self.lblType.text = @"折";
    } else if (8 == discountType) {
        self.lblType.text = @"会";
        self.lblType.backgroundColor = RGB(255, 179, 0);
    }else if (9 == discountType) {
        self.lblType.text = @"折";
        self.lblType.backgroundColor = RGB(255, 179, 0);
    }

     [self updateSize];
}

//积分兑换订单
- (void)initPointOrderData:(InstanceVo *)instanceVo {
    self.instanceVo = instanceVo;
    self.lblGoodsName.text = instanceVo.originalGoodsName;
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
        self.lblBarCode.text = instanceVo.innerCode;
    } else {
        self.lblBarCode.text = instanceVo.barCode;
    }
    //颜色 尺码 服鞋版时表示
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue]==101) {
        self.lblColor.text = instanceVo.sku;
    } else {
        self.lblColor.text = @"";
    }
    
    //购买数量
    self.lblAccountNum.text = [NSString stringWithFormat:@"×%.0f", instanceVo.accountNum];
    self.lblPrice.text = @"";
    
    self.lblFinalRatioFee.text = [NSString stringWithFormat:@"%@积分", instanceVo.consumePoints];
     [self updateSize1];
}
- (void)updateSize {
    CGFloat y = 20;
    //商品名称
    NSString *goodsName = self.retailInstanceVo ? self.retailInstanceVo.originalGoodsName : self.instanceVo.originalGoodsName;
    CGSize sizeGoodsName = [NSString sizeWithText:goodsName maxSize:CGSizeMake(225, MAXFLOAT) font:self.lblGoodsName.font];
    self.lblGoodsName.ls_size = sizeGoodsName;
    self.lblGoodsName.ls_top = y;
    //商品店内码
    self.lblBarCode.ls_top = self.lblGoodsName.ls_bottom + 5;
    //颜色尺码
    self.lblColor.ls_top = self.lblBarCode.ls_bottom + 5;
    

    //商品折扣率
    y = 5;
    self.lblRatio.ls_top = y;
    y = y + self.lblRatio.ls_height;
    
    //商品折扣价
    self.lblFinalRatioFee.ls_top = y;
    [self.lblFinalRatioFee sizeToFit];
    self.lblFinalRatioFee.ls_height = 20;
    y = y + self.lblFinalRatioFee.ls_height;
    self.lblFinalRatioFee.ls_right = self.lblPrice.ls_right;
    //折扣类型
    self.lblType.ls_centerY = self.lblFinalRatioFee.ls_centerY;
    self.lblType.ls_right = self.lblFinalRatioFee.ls_left - 10;
    //商品原价
    self.lblPrice.ls_top = y;
    y = y + self.lblPrice.ls_height;
  
    
    
    //商品数量
    self.lblAccountNum.ls_top = y;
//    y = y + self.lblAccountNum.ls_height;
    y = MAX(self.lblColor.ls_bottom, self.lblAccountNum.ls_bottom) + 5;
    self.viewLine.ls_top = y;
    y = y + 1;
    self.ls_height = y;
   
}

- (void)updateSize1 {
    self.lblType.hidden = YES;
    self.lblRatio.hidden = YES;
    CGFloat y = 5;
    //商品名称
    NSString *goodsName = self.retailInstanceVo ? self.retailInstanceVo.originalGoodsName : self.instanceVo.originalGoodsName;
    CGSize sizeGoodsName = [NSString sizeWithText:goodsName maxSize:CGSizeMake(225, MAXFLOAT) font:self.lblGoodsName.font];
    self.lblGoodsName.ls_size = sizeGoodsName;
    //商品折扣价
    self.lblFinalRatioFee.ls_top = y;
    y = y + self.lblGoodsName.ls_height + 5;
    //商品店内码
    self.lblBarCode.ls_top = y;
    //商品原价
    self.lblPrice.ls_top = y;
    y = y + self.lblPrice.ls_height + 5;
    //商品数量
    self.lblAccountNum.ls_top = y;
    self.lblColor.ls_top = y;
    y = y + self.lblAccountNum.ls_height + 5;
    self.viewLine.ls_top = y;
    y = y + 1;
    self.ls_height = y;
}

    
@end
