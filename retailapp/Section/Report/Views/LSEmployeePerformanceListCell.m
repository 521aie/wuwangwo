//
//  LSEmployeePerformanceListCell.m
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSEmployeePerformanceListCell.h"
#import "DateUtils.h"

@interface LSEmployeePerformanceListCell ()

/** 员工名称工号 */
@property (nonatomic, strong) UILabel *lblNameStaffId;
/** 净销售额 */
@property (nonatomic, strong) UILabel *lblNetSaleAmount;
/** 下一个图标 */
@property (nonatomic, strong) UIImageView *imgNext;
/** 净销量 */
@property (nonatomic, strong) UILabel *lblNetSaleNum;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSEmployeePerformanceListCell
+ (instancetype)employeePerformanceListCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSEmployeePerformanceListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSEmployeePerformanceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //员工名称工号
    self.lblNameStaffId = [[UILabel alloc] init];
    self.lblNameStaffId.font = [UIFont systemFontOfSize:15];
    self.lblNameStaffId.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblNameStaffId];
    //净销售额
    self.lblNetSaleAmount = [[UILabel alloc] init];
    self.lblNetSaleAmount.font = [UIFont systemFontOfSize:13];
    self.lblNetSaleAmount.textColor = [ColorHelper getTipColor3];
    self.lblNetSaleAmount.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.lblNetSaleAmount];
    //净销量
    self.lblNetSaleNum = [[UILabel alloc] init];
    self.lblNetSaleNum.font = [UIFont systemFontOfSize:13];
    self.lblNetSaleNum.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblNetSaleNum];
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
    //员工名称工号
    [self.lblNameStaffId makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY).offset(-15);
    }];

    //净销售额
    [self.lblNetSaleAmount makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lblNetSaleNum);
        make.right.equalTo(wself.imgNext.left);
    }];
    //净销量
    [self.lblNetSaleNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblNameStaffId);
        make.centerY.equalTo(wself.centerY).offset(15);
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

- (void)setEmployeePerformanceVo:(LSEmployeePerformanceVo *)employeePerformanceVo {
    _employeePerformanceVo = employeePerformanceVo;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    //员工名称工号
    if ([NSString isNotBlank:employeePerformanceVo.staffName]) {//员工删除后是没有名字的
        [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:employeePerformanceVo.staffName]];
    }
    [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(工号:%@)", employeePerformanceVo.staffId] attributes: @{NSForegroundColorAttributeName : [ColorHelper getTipColor6], NSFontAttributeName : [UIFont systemFontOfSize:13]}]];
    self.lblNameStaffId.attributedText = attr;
    //净销售额
    attr = [[NSMutableAttributedString alloc] initWithString:@"净销售额："];
    double netSalesAmount = fabs(employeePerformanceVo.netSalesAmount.doubleValue);
    if (employeePerformanceVo.netSalesAmount.doubleValue < 0) {
         [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"-¥%.2f", netSalesAmount] attributes: @{NSForegroundColorAttributeName : [ColorHelper getGreenColor],}]];
    } else {
         [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", netSalesAmount] attributes: @{NSForegroundColorAttributeName : [ColorHelper getRedColor],}]];
    }
   
    self.lblNetSaleAmount.attributedText = attr;
    //净销量
    if ([employeePerformanceVo.netSalesNum.stringValue containsString:@"."]) {
        self.lblNetSaleNum.text = [NSString stringWithFormat:@"净销量：%.3f", employeePerformanceVo.netSalesNum.doubleValue];
    } else {
        self.lblNetSaleNum.text = [NSString stringWithFormat:@"净销量：%.f", employeePerformanceVo.netSalesNum
                                   .doubleValue];
    }

}


@end
