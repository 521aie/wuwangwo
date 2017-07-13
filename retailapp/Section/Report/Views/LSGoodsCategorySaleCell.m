//
//  LSGoodsCategorySaleCell.m
//  retailapp
//
//  Created by guozhi on 2016/11/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsCategorySaleCell.h"
#import "LSGoodsSalesReportVo.h"
#import "LSSaleGoodsSummaryVo.h"

@interface LSGoodsCategorySaleCell()
/** 商品名称 */
@property (nonatomic, strong) UILabel *lblGoodsName;
/** 净销量 */
@property (nonatomic, strong) UILabel *lblNetSales;
/** 净销售额 */
@property (nonatomic, strong) UILabel *lblNetAmount;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
/*<箭头图标>*/
@property (nonatomic ,strong) UIImageView *arrowImageView;
@end

@implementation LSGoodsCategorySaleCell
+ (instancetype)goodsCategorySaleCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSGoodsCategorySaleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSGoodsCategorySaleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //商品名称
    self.lblGoodsName = [[UILabel alloc] init];
    self.lblGoodsName.font = [UIFont systemFontOfSize:15];
    self.lblGoodsName.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblGoodsName];
    //净销量
    self.lblNetSales = [[UILabel alloc] init];
    self.lblNetSales.font = [UIFont systemFontOfSize:13];
    self.lblNetSales.textColor = [ColorHelper getRedColor];
    [self.contentView addSubview:self.lblNetSales];
    //净销售额
    self.lblNetAmount = [[UILabel alloc] init];
    self.lblNetAmount.font = [UIFont systemFontOfSize:13];
    self.lblNetAmount.textColor = [ColorHelper getRedColor];
    [self.contentView addSubview:self.lblNetAmount];
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
    
    //箭头图标
    self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.arrowImageView.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.arrowImageView];
}

- (void)configConstraints {
    CGFloat leftMargin = 10;
    CGFloat topMargin = 20;
    __weak typeof(self) wself = self;
    //配置商品名称
    [self.lblGoodsName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView.top).offset(topMargin);
        make.left.equalTo(wself.contentView.left).offset(leftMargin);
    }];
    //配置净销量
    [self.lblNetSales makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wself.contentView.bottom).offset(-topMargin);
        make.left.equalTo(wself.lblGoodsName.left);
    }];
    //配置净销售额
    [self.lblNetAmount makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wself.lblNetSales.bottom);
        make.right.equalTo(wself.arrowImageView.mas_left);
    }];
    //配置分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
    
    //配置箭头图标
    [self.arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.mas_right).offset(-leftMargin);
        make.width.and.height.equalTo(@.0);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
}

- (void)updateConstraints {
    [super updateConstraints];
    __weak typeof(self) wself = self;
    CGFloat arrowSide = !self.model ? 22.0 : 0.0;
    [wself.arrowImageView updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.mas_right).offset(-10);
        make.width.and.height.equalTo(@(arrowSide));
        make.centerY.equalTo(wself.contentView.centerY);
    }];
}

//设置数据
-(void)setModel:(LSGoodsSalesReportVo *)model {
    _model = model;
    //设置商品名称
    self.lblGoodsName.text = model.name;
    //设置净销量
    NSString *netSales = nil;
    if ([model.netSales.stringValue containsString:@"."]) {
        netSales = [NSString stringWithFormat:@"净销量：%.3f",model.netSales.doubleValue];
    } else {
        netSales = [NSString stringWithFormat:@"净销量：%.f",model.netSales.doubleValue];
    }
    NSMutableAttributedString *netSalesAttr = [[NSMutableAttributedString alloc] initWithString:netSales];
    [netSalesAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getTipColor6] range:NSMakeRange(0, 4)];
    self.lblNetSales.attributedText = netSalesAttr;
    //设置净销量
    NSString *netAmounts = [NSString stringWithFormat:@"净销售额：¥%.2f",model.netAmount.doubleValue];
    NSMutableAttributedString *netAmountsAttr = [[NSMutableAttributedString alloc] initWithString:netAmounts];
    [netAmountsAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getTipColor6] range:NSMakeRange(0, 5)];
    self.lblNetAmount.attributedText =netAmountsAttr;
}

- (void)fillSaleGoodsSummaryVo:(LSSaleGoodsSummaryVo *)model {
    
    //设置商品名称:按分类/按品牌
    if ([NSString isNotBlank:model.categoryName]) {
        self.lblGoodsName.text = model.categoryName;
    } else if ([NSString isNotBlank:model.brandName]) {
        self.lblGoodsName.text = model.brandName;
    }
    
    //设置净销量
    NSString *netSales = nil;
    if ([model.netSales.stringValue containsString:@"."]) {
        netSales = [NSString stringWithFormat:@"净销量：%.3f",model.netSales.doubleValue];
    } else {
        netSales = [NSString stringWithFormat:@"净销量：%.f",model.netSales.doubleValue];
    }
    NSMutableAttributedString *netSalesAttr = [[NSMutableAttributedString alloc] initWithString:netSales];
    [netSalesAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getTipColor6] range:NSMakeRange(0, 4)];
    self.lblNetSales.attributedText = netSalesAttr;
    //设置净销量
    NSString *netAmounts = [NSString stringWithFormat:@"净销售额：¥%.2f",model.netAmount.doubleValue];
    NSMutableAttributedString *netAmountsAttr = [[NSMutableAttributedString alloc] initWithString:netAmounts];
    [netAmountsAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getTipColor6] range:NSMakeRange(0, 5)];
    self.lblNetAmount.attributedText =netAmountsAttr;
}

@end
