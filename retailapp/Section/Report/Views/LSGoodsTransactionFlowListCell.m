//
//  LSGoodsTransactionFlowListCell.m
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsTransactionFlowListCell.h"
#import "DateUtils.h"

@interface LSGoodsTransactionFlowListCell ()

/** 单号 */
@property (nonatomic, strong) UILabel *lblOrderNumber;
/** 金额 */
@property (nonatomic, strong) UILabel *lblAmount;
/** 下一个图标 */
@property (nonatomic, strong) UIImageView *imgNext;
/** 订单时间 */
@property (nonatomic, strong) UILabel *lblOrderTime;
/** 微店图标 */
@property (nonatomic, strong) UIImageView *imgStatus;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSGoodsTransactionFlowListCell
+ (instancetype)goodsTransactionFlowListCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSGoodsTransactionFlowListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSGoodsTransactionFlowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //单号
    self.lblOrderNumber = [[UILabel alloc] init];
    self.lblOrderNumber.font = [UIFont systemFontOfSize:15];
    self.lblOrderNumber.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblOrderNumber];
    //金额
    self.lblAmount = [[UILabel alloc] init];
    self.lblAmount.font = [UIFont systemFontOfSize:13];
    self.lblAmount.textColor = [ColorHelper getTipColor6];
    self.lblAmount.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.lblAmount];
    //订单时间
    self.lblOrderTime = [[UILabel alloc] init];
    self.lblOrderTime.font = [UIFont systemFontOfSize:13];
    self.lblOrderTime.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblOrderTime];
    //微店图标
    self.imgStatus = [[UIImageView alloc] init];
    self.imgStatus.image = [UIImage imageNamed:@"weixin"];
    [self.contentView addSubview:self.imgStatus];
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
    //单号
    [self.lblOrderNumber makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY).offset(-20);
    }];

    //金额
    [self.lblAmount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblOrderNumber);
        make.centerY.equalTo(wself.centerY).offset(20);
    }];
    //订单时间
    [self.lblOrderTime makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.imgNext.left);
        make.centerY.equalTo(wself.lblAmount);
    }];
    //微店标志
    [self.imgStatus makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(60, 15));
        make.right.equalTo(wself.imgNext.left);
        make.centerY.equalTo(wself.lblOrderNumber.centerY);
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

- (void)setOrderReportVo:(LSOrderReportVo *)orderReportVo {
    _orderReportVo = orderReportVo;
     NSString *waternumber = [NSString shortStringForOrderID:orderReportVo.waternumber];
    //订单单号
    self.lblOrderNumber.text = waternumber;
    
    //订单金额颜色
    UIColor *color = nil;
    if (orderReportVo.orderKind.intValue == 1) {//销售单
        color = [ColorHelper getRedColor];
    } else {
        color = [ColorHelper getGreenColor];
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"实收金额："];
    double cost = [orderReportVo.totalmoney doubleValue];
    BOOL isOrder = [self isOrder:orderReportVo.waternumber];
    if (!isOrder && cost == 0) {
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"-￥0.00" attributes: @{NSForegroundColorAttributeName : color}]];
    } else {
        if (orderReportVo.totalmoney.doubleValue < 0) {
            [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"-￥%.2f" ,orderReportVo.totalmoney.doubleValue * -1] attributes: @{NSForegroundColorAttributeName : color}]];
        } else {
             [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f" ,orderReportVo.totalmoney.doubleValue] attributes: @{NSForegroundColorAttributeName : color}]];
        }
       
    }
    self.lblAmount.attributedText = attr;
    //订单时间
    self.lblOrderTime.text = orderReportVo.salesTime;
    
    if ([orderReportVo.outType isEqualToString:@"weixin"]) {//微信订单
        self.imgStatus.hidden = NO;
    } else {//实体订单
        self.imgStatus.hidden = YES;
    }
}

//根据流水号判断是订货单还是退货单
- (BOOL)isOrder:(NSString *)waterNumber{
    NSString *begin = [waterNumber substringToIndex:1];
    NSString *beginThree = [waterNumber substringToIndex:3];
    if ([begin isEqualToString:@"2"] || [beginThree isEqualToString:@"RBW"]) {
        return NO;//退货单
    }else{
        return YES;//订货单
    }
}


@end
