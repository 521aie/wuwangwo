//
//  LSShiftRecordListCell.m
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSShiftRecordListCell.h"
#import "DateUtils.h"

@interface LSShiftRecordListCell ()

/** 员工名称工号 */
@property (nonatomic, strong) UILabel *lblNameStaffId;
/** 实收金额 */
@property (nonatomic, strong) UILabel *lblRecieveAmount;
/** 下一个图标 */
@property (nonatomic, strong) UIImageView *imgNext;
/** 时间 */
@property (nonatomic, strong) UILabel *lblTime;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSShiftRecordListCell
+ (instancetype)shiftRecordListCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSShiftRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSShiftRecordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //实收金额
    self.lblRecieveAmount = [[UILabel alloc] init];
    self.lblRecieveAmount.font = [UIFont systemFontOfSize:13];
    self.lblRecieveAmount.textColor = [ColorHelper getTipColor6];
    self.lblRecieveAmount.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.lblRecieveAmount];
    //时间
    self.lblTime = [[UILabel alloc] init];
    self.lblTime.font = [UIFont systemFontOfSize:13];
    self.lblTime.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblTime];
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
        make.centerY.equalTo(wself.contentView.centerY).offset(-20);
    }];

    //实收金额
    [self.lblRecieveAmount makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lblNameStaffId);
        make.right.equalTo(wself.imgNext.left);
    }];
    //时间
    [self.lblTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblNameStaffId);
        make.centerY.equalTo(wself.centerY).offset(20);
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

- (void)setUserHangoverVo:(LSUserHandoverVo *)userHangoverVo {
    _userHangoverVo = userHangoverVo;
    NSMutableAttributedString *userNameStaffIdAttr = [[NSMutableAttributedString alloc] init];
    if ([NSString isNotBlank:userHangoverVo.userName]) {
        [userNameStaffIdAttr appendAttributedString:[[NSAttributedString alloc] initWithString:userHangoverVo.userName]];
    }
    [userNameStaffIdAttr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(工号:%@)", userHangoverVo.staffId] attributes: @{NSForegroundColorAttributeName : [ColorHelper getTipColor6], NSFontAttributeName : [UIFont systemFontOfSize:13]}]];
    self.lblNameStaffId.attributedText = userNameStaffIdAttr;
    
    self.lblTime.text = [NSString stringWithFormat:@"%@~%@",[DateUtils formateTime:[userHangoverVo.startWorkTime longLongValue]],[DateUtils formateTime:[userHangoverVo.endWorkTime longLongValue]]];
    //实收金额
    self.lblRecieveAmount.text = [NSString stringWithFormat:@"实收金额：¥%.2f",  [userHangoverVo.totalRecieveAmount doubleValue]];
   
    
}


@end
