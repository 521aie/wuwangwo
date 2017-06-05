//
//  LSPaymentOrderDetailCell.m
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPaymentOrderDetailCell.h"
@interface LSPaymentOrderDetailCell()
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
@end

@implementation LSPaymentOrderDetailCell
+ (instancetype)paymentOrderDetailCellWithTable:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSPaymentOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSPaymentOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //商品名称
    [self.lblGoodsName makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.viewCenterLeftLine.left);
        make.top.equalTo(wself.lblGoodsAmmount);
        make.left.equalTo(wself.viewLeftLine.right).offset(5);
    }];
    //商品数量
    [self.lblGoodsNum makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.viewCenterRightLine.left);
        make.width.equalTo(40);
        make.top.equalTo(wself.lblGoodsAmmount);
    }];
    //商品金额
    [self.lblGoodsAmmount makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.viewRightLine.left).offset(-10);
        make.width.equalTo(90);
        make.top.equalTo(wself.contentView.top).offset(10);
    }];
    [self layoutIfNeeded];
}
- (void)setGoodsInfo:(InstanceVo *)goodsInfo {
    //商品名称
    NSString *goodsName = goodsInfo.originalGoodsName;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:goodsName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [ColorHelper getTipColor3]}];
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101 && [NSString isNotBlank:goodsInfo.innerCode]) {//服鞋显示  商品名称\n店内码\n颜色尺码
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n%@", goodsInfo.innerCode, goodsInfo.sku]]];
    } else if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 102 && [NSString isNotBlank:goodsInfo.barCode]){//商超显示  商品名称\n商品条码
        //商超没有显示颜色尺码
        //条形码
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", goodsInfo.barCode]]];
    }
    //设置行间距
    if ([goodsInfo.originalGoodsName containsString:@"\n"]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
    }
    self.lblGoodsName.attributedText = attr;
    //商品数量
    self.lblGoodsNum.text = [NSString stringWithFormat:@"%.f",goodsInfo.accountNum];
    
    //商品金额
    //价格
    NSString *price = [NSString stringWithFormat:@"￥%.2f",goodsInfo.price * goodsInfo.accountNum];
    //优惠后价格
    NSString *reduce = [NSString stringWithFormat:@"￥%.2f",goodsInfo.sales_price * goodsInfo.accountNum];
    if ([price isEqualToString:reduce]) {
        self.lblGoodsAmmount.text = price;
    } else {
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:8];
        paragraphStyle1.alignment = NSTextAlignmentRight;
        attr = [[NSMutableAttributedString alloc] init];
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
    [self layoutIfNeeded];
    goodsInfo.cellHeight = self.viewBottomLine.ls_bottom;
    
    
}


@end
