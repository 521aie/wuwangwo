//
//  LSGoodsTransactionFlowDetailCell.m
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsTransactionFlowDetailCell.h"
@interface LSGoodsTransactionFlowDetailCell()
/** 左边分割线 */
@property (nonatomic, strong) UIView *viewLeftLine;
/** 右边分割线 */
@property (nonatomic, strong) UIView *viewRightLine;
/** 中间左边分割线 */
@property (nonatomic, strong) UIView *viewCenterLeftLine;
/** 中间右边分割线 */
@property (nonatomic, strong) UIView *viewCenterRightLine;
/** 底部分割线 */
@property (nonatomic, strong) UIView *viewBottomLine;
/** 商品名称 */
@property (nonatomic, strong) UILabel *lblGoodsName;
/** 商品数量 */
@property (nonatomic, strong) UILabel *lblGoodsNum;
/** 金额 */
@property (nonatomic, strong) UILabel *lblGoodsAmmount;
/** 促销标志 */
@property (nonatomic, strong) UILabel *lblStatus;
/** 商品对象 */
@property (nonatomic, strong) LSOrderDetailReportVo *goodsVo;
@end

@implementation LSGoodsTransactionFlowDetailCell
+ (instancetype)goodsTransactionFlowDetailCellWithTable:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSGoodsTransactionFlowDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSGoodsTransactionFlowDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //左边分割线
    self.viewLeftLine = [[UIView alloc] init];
    self.viewLeftLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.contentView addSubview:self.viewLeftLine];
    //右边分割线
    self.viewRightLine = [[UIView alloc] init];
    self.viewRightLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.contentView addSubview:self.viewRightLine];
    //中间左边分割线
    self.viewCenterLeftLine = [[UIView alloc] init];
    self.viewCenterLeftLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.contentView addSubview:self.viewCenterLeftLine];
    //中间右边分割线
    self.viewCenterRightLine = [[UIView alloc] init];
    self.viewCenterRightLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.contentView addSubview:self.viewCenterRightLine];
    //底部分割线
    self.viewBottomLine = [[UIView alloc] init];
    self.viewBottomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.contentView addSubview:self.viewBottomLine];
    //商品名称
    self.lblGoodsName = [[UILabel alloc] init];
    self.lblGoodsName.font = [UIFont systemFontOfSize:13];
    self.lblGoodsName.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblGoodsName];
    self.lblGoodsName.numberOfLines = 0;
    //商品数量
    self.lblGoodsNum = [[UILabel alloc] init];
    self.lblGoodsNum.font = [UIFont systemFontOfSize:13];
    self.lblGoodsNum.textColor = [ColorHelper getTipColor3];
    self.lblGoodsNum.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.lblGoodsNum];
    //商品金额
    self.lblGoodsAmmount = [[UILabel alloc] init];
    self.lblGoodsAmmount.font = [UIFont systemFontOfSize:13];
    self.lblGoodsAmmount.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblGoodsAmmount];
    self.lblGoodsAmmount.textAlignment = NSTextAlignmentRight;
    self.lblGoodsAmmount.numberOfLines = 0;
    //促销标志
    self.lblStatus = [[UILabel alloc] init];
    self.lblStatus.font = [UIFont systemFontOfSize:10];
    self.lblStatus.textColor = [UIColor whiteColor];
    self.lblStatus.backgroundColor = RGB(1, 178, 43);
    self.lblStatus.layer.cornerRadius = 4;
    self.lblStatus.layer.masksToBounds = YES;
    self.lblStatus.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.lblStatus];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //左边分割线
    [self.viewLeftLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(10);
        make.width.equalTo(1);
        make.top.bottom.equalTo(wself.contentView);
    }];
    //右边分割线
    [self.viewRightLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.right).offset(-10);
        make.width.equalTo(1);
        make.top.bottom.equalTo(wself.contentView);
    }];
    //中间左边分割线
    [self.viewCenterLeftLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.lblGoodsNum.left);
        make.width.equalTo(1);
        make.top.bottom.equalTo(wself.contentView);
    }];
    //中间右边分割线
    [self.viewCenterRightLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblGoodsAmmount.left);
        make.width.equalTo(1);
        make.top.bottom.equalTo(wself.contentView);
    }];
    //底部分割线
    [self.viewBottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.viewLeftLine.left);
        make.right.equalTo(wself.viewRightLine.right);
        make.height.equalTo(1);
        make.bottom.equalTo(wself.lblGoodsAmmount.bottom).offset(10);
    }];
    [self layoutIfNeeded];
}

/**
 设置商品

 @param goodsInfo 上线信息
 @param isOrder   YES 销售单  NO 退货单
 */
- (void)setGoodsInfo:(LSOrderDetailReportVo *)goodsInfo isOrder:(BOOL)isOrder {
    __weak typeof(self) wself = self;
    //商品名称
    [self.lblGoodsName remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.viewCenterLeftLine.left);
        make.top.equalTo(wself.lblGoodsAmmount);
        make.left.equalTo(wself.viewLeftLine.right).offset(5);
    }];
    //商品数量
    [self.lblGoodsNum remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.viewCenterRightLine.left);
        make.width.equalTo(40);
        make.top.equalTo(wself.lblGoodsAmmount);
    }];
    //商品金额
    [self.lblGoodsAmmount remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.viewRightLine.left).offset(-10);
        make.width.equalTo(90);
        make.top.equalTo(wself.contentView.top).offset(10);
    }];
    //促销标志
    [self.lblStatus remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(15);
        make.centerY.equalTo(wself.lblGoodsAmmount);
        make.left.equalTo(wself.viewCenterRightLine.right).offset(10);
    }];
    
    //商品名称
    NSString *goodsName = goodsInfo.goodsName;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:goodsName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [ColorHelper getTipColor3]}];
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {//服鞋显示  商品名称\n店内码\n颜色尺码
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n%@", goodsInfo.goodsInnerCode, goodsInfo.goodsSku]]];
    } else {//商超显示  商品名称\n商品条码
        //商超没有显示颜色尺码
        //条形码
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", goodsInfo.goodsCode]]];
    }
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
 
    self.lblGoodsName.attributedText = attr;
    //商品数量
    if ([goodsInfo.buyNum.stringValue containsString:@"."]) {
        self.lblGoodsNum.text = [NSString stringWithFormat:@"%.3f",[goodsInfo.buyNum doubleValue]];
    } else {
        self.lblGoodsNum.text = [NSString stringWithFormat:@"%d",[goodsInfo.buyNum intValue]];
    }
    
    //商品金额
    //如果折扣率是100%只显示商品单价
    //价格
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    paragraphStyle1.alignment = NSTextAlignmentRight;
    NSString *price = [NSString stringWithFormat:@"￥%.2f",[goodsInfo.price doubleValue]];
    //优惠后价格
    NSString *reduce = [NSString stringWithFormat:@"￥%.2f",[goodsInfo.salesPrice doubleValue]];
    //折扣率
    NSString *ratio = [NSString stringWithFormat:@"%.2f%%",goodsInfo.ratio.doubleValue];
    if (goodsInfo.ratio.intValue == 100) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:price];
        self.lblGoodsAmmount.attributedText = attr;
        self.lblGoodsAmmount.textColor = [ColorHelper getTipColor3];
    } else {//销售单且折扣率不等于100% 显示折扣率\n优惠后单价\n单价
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        if (isOrder) {//销售单显示折扣率
            [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:ratio attributes:@{NSForegroundColorAttributeName : [ColorHelper getGreenColor]}]];
            
        }
        //优惠后单价
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", reduce] attributes:@{NSForegroundColorAttributeName : [ColorHelper getTipColor3]}]];
        //单价带横线
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", price] attributes:@{NSForegroundColorAttributeName : [ColorHelper getTipColor6], NSStrikethroughStyleAttributeName : @(NSUnderlinePatternSolid | NSUnderlineStyleSingle)}]];
        //设置行间距
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, attr.length)];
        self.lblGoodsAmmount.attributedText = attr;
    }
    [self layoutIfNeeded];
    CGFloat maxHeight = MAX(self.lblGoodsName.ls_height, self.lblGoodsAmmount.ls_height);
    [self.lblGoodsAmmount updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(maxHeight);
    }];
    [self.lblGoodsName updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(maxHeight);
    }];
    [self.lblGoodsNum updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(maxHeight);
    }];
    
    //设置促销标志
    if (goodsInfo.ratio.intValue == 100) {
        [self.lblStatus setHidden:YES];
    } else if (0 == [goodsInfo.discountType integerValue]) {
        [self.lblStatus setHidden:YES];
    } else if (1 == [goodsInfo.discountType integerValue]) {
        self.lblStatus.text = @"会";
        [self.lblStatus setHidden:NO];
    } else if (2 == [goodsInfo.discountType integerValue]) {
        self.lblStatus.text = @"折";
        [self.lblStatus setHidden:NO];
    } else if (3 == [goodsInfo.discountType integerValue]) {
        self.lblStatus.text = @"赠";
        [self.lblStatus setHidden:NO];
    } else if (4 == [goodsInfo.discountType integerValue]) {
        self.lblStatus.text = @"换";
        [self.lblStatus setHidden:NO];
    } else if (5 == [goodsInfo.discountType integerValue]) {
        self.lblStatus.text = @"特";
        [self.lblStatus setHidden:NO];
    } else if (6 == [goodsInfo.discountType integerValue]) {
        self.lblStatus.text = @"批";
        [self.lblStatus setHidden:NO];
    } else if (7 == [goodsInfo.discountType integerValue]) {
        self.lblStatus.text = @"折";
        [self.lblStatus setHidden:NO];
    } else if (8 == [goodsInfo.discountType integerValue]) {
        self.lblStatus.text = @"会";
        [self.lblStatus setHidden:NO];
        self.lblStatus.backgroundColor = RGB(255, 179, 0);
    }else if (9 == [goodsInfo.discountType integerValue]) {
        self.lblStatus.text = @"折";
        [self.lblStatus setHidden:NO];
        self.lblStatus.backgroundColor = RGB(255, 179, 0);
    }
    [self layoutIfNeeded];
    goodsInfo.cellHeight = self.viewBottomLine.ls_bottom;

}


@end
