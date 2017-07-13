//
//  LSShopColllectionDetailListCell.m
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSShopColllectionDetailListCell.h"
#import "DateUtils.h"

@interface LSShopColllectionDetailListCell ()

/** 员工名称工号 */
@property (nonatomic, strong) UILabel *lblNameStaffId;
/** 金额 */
@property (nonatomic, strong) UILabel *lblAmount;
/** 员工角色名称 */
@property (nonatomic, strong) UILabel *lblRoleName;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSShopColllectionDetailListCell
+ (instancetype)shopColllectionDetailListCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSShopColllectionDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSShopColllectionDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //金额
    self.lblAmount = [[UILabel alloc] init];
    self.lblAmount.font = [UIFont systemFontOfSize:13];
    self.lblAmount.textColor = [ColorHelper getRedColor];
    self.lblAmount.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.lblAmount];
    //员工角色名称
    self.lblRoleName = [[UILabel alloc] init];
    self.lblRoleName.font = [UIFont systemFontOfSize:13];
    self.lblRoleName.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblRoleName];
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

    //金额
    [self.lblAmount makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.contentView);
        make.right.equalTo(wself.contentView.right).offset(-margin);
    }];
    //员工角色名称
    [self.lblRoleName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblNameStaffId);
        make.centerY.equalTo(wself.centerY).offset(15);
    }];
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
    
}

- (void)setStaffHandoverPayTypeVo:(LSStaffHandoverPayTypeVo *)staffHandoverPayTypeVo {
    
    _staffHandoverPayTypeVo = staffHandoverPayTypeVo;
    NSMutableAttributedString *userNameStaffIdAttr = [[NSMutableAttributedString alloc] initWithString:staffHandoverPayTypeVo.staffName];
    [userNameStaffIdAttr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(工号:%@)", staffHandoverPayTypeVo.staffId] attributes: @{NSForegroundColorAttributeName : [ColorHelper getTipColor6], NSFontAttributeName : [UIFont systemFontOfSize:13]}]];
    self.lblNameStaffId.attributedText = userNameStaffIdAttr;
    self.lblAmount.textColor = [staffHandoverPayTypeVo.salesAmount doubleValue]<0?[ColorHelper getGreenColor]:[ColorHelper getRedColor];
    self.lblRoleName.text = staffHandoverPayTypeVo.staffRole;
    self.lblAmount.text = [NSString stringWithFormat:@"￥%.2f",[staffHandoverPayTypeVo.salesAmount doubleValue]];
}




@end
