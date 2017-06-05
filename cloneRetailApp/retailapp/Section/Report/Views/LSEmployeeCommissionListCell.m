//
//  LSEmployeeCommissionListCell.m
//  retailapp
//
//  Created by guozhi on 2016/11/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSEmployeeCommissionListCell.h"
@interface LSEmployeeCommissionListCell()
/** 员工名称工号 */
@property (nonatomic, strong) UILabel *lblNameStaffId;
/** 员工角色 */
@property (nonatomic, strong) UILabel *lblRole;
/** 下一个图标 */
@property (nonatomic, strong) UIImageView *imgNext;
/** 提成 */
@property (nonatomic, strong) UILabel *lblCommission;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSEmployeeCommissionListCell
+ (instancetype)employeeCommissionListCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSEmployeeCommissionListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSEmployeeCommissionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //员工角色
    self.lblRole = [[UILabel alloc] init];
    self.lblRole.font = [UIFont systemFontOfSize:13];
    self.lblRole.textColor = [ColorHelper getTipColor6];
    self.lblRole.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.lblRole];
    //提成
    self.lblCommission = [[UILabel alloc] init];
    self.lblCommission.font = [UIFont systemFontOfSize:13];
    self.lblCommission.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblCommission];
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
    
    //员工角色
    [self.lblRole makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblNameStaffId);
        make.centerY.equalTo(wself.centerY).offset(15);
    }];
    //提成
    [self.lblCommission makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.imgNext.left);
        make.centerY.equalTo(wself.lblRole.centerY);
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

- (void)setEmployeeCommissionVo:(LSEmployeeCommissionVo *)employeeCommissionVo {
    _employeeCommissionVo = employeeCommissionVo;
    //员工姓名工号
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:employeeCommissionVo.staffName];
    [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"（工号：%@）", employeeCommissionVo.staffId] attributes:@{NSForegroundColorAttributeName : [ColorHelper getTipColor6], NSFontAttributeName : [UIFont systemFontOfSize:13]}]];
    self.lblNameStaffId.attributedText = attr;
    //员工角色
    self.lblRole.text = employeeCommissionVo.staffRole;
    //提成
    attr = [[NSMutableAttributedString alloc] initWithString:@"提成："];
    UIColor *color = nil;
    if (employeeCommissionVo.commissionAmount.doubleValue < 0) {
        color = [ColorHelper getGreenColor];
    } else {
        color = [ColorHelper getRedColor];
    }
     [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", employeeCommissionVo.commissionAmount.doubleValue] attributes:@{NSForegroundColorAttributeName : color}]];
   
    self.lblCommission.attributedText = attr;
}


@end
