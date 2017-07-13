//
//  LSKindPayListCell.m
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSKindPayListCell.h"
@interface LSKindPayListCell ()
/** 支付方式名称 */
@property (nonatomic, strong) UILabel *lblName;
/** 支付类型 */
@property (nonatomic, strong) UILabel *lblType;
/** 下一个图标 */
@property (nonatomic, strong) UIImageView *imgNext;
/** 销售额 */
@property (nonatomic, strong) UILabel *lblSale;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSKindPayListCell

+ (instancetype)kindPayListCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSKindPayListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSKindPayListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];

    }
    return cell;
}

- (void)configViews {
    //支付方式名称
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont boldSystemFontOfSize:15];
    self.lblName.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblName];
    //支付方式类型
    self.lblType = [[UILabel alloc] init];
    self.lblType.font = [UIFont systemFontOfSize:13];
    self.lblType.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblType];
    //销售额
    self.lblSale = [[UILabel alloc] init];
    self.lblSale.font = [UIFont systemFontOfSize:13];
    self.lblSale.textColor = [ColorHelper getGreenColor];
    [self.contentView addSubview:self.lblSale];
    //下一个图标
    self.imgNext = [[UIImageView alloc] init];
    self.imgNext.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.imgNext];
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
    
}
- (void)configConstraints {
    CGFloat margin = 10;
    __weak typeof(self) wself = self;
    //支付方式名称
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY).offset(-15);
    }];
    //支付方式类型
    [self.lblType makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.imgNext.left).offset(-10);
        make.centerY.equalTo(wself.lblName.centerY);
    }];
    //销售额
    [self.lblSale makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(10);
        make.centerY.equalTo(wself.contentView.centerY).offset(15);
    }];
    //下一个图标
    [self.imgNext makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.right).offset(-10);
        make.centerY.equalTo(wself.contentView.centerY);
        make.size.equalTo(22);
    }];
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];

}

- (void)setPaymentVo:(PaymentVo *)paymentVo {
    _paymentVo = paymentVo;
     //支付方式名称
    self.lblName.text = paymentVo.payMentName;
     //支付方式类型
    self.lblType.text = paymentVo.payTyleName;
    //销售额
    if ([ObjectUtil isNull:self.paymentVo.joinSalesMoney] || [self.paymentVo.joinSalesMoney intValue]== 1) {
        self.lblSale.text = @"收入计入销售额";
        self.lblSale.textColor = [ColorHelper getGreenColor];
    } else {
        self.lblSale.text = @"收入不计入销售额";
        self.lblSale.textColor = [ColorHelper getTipColor6];
    }
    
}
@end
