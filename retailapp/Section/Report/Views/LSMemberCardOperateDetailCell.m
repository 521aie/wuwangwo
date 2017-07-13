//
//  LSMemberCardOperateDetailCell.m
//  retailapp
//
//  Created by wuwangwo on 17/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardOperateDetailCell.h"
#import "DateUtils.h"
#import "EditItemView.h"

@interface LSMemberCardOperateDetailCell ()
@property (nonatomic, strong) EditItemView *cardNum; //会员卡号
@property (nonatomic, strong) EditItemView *cardType; //会员卡类型
@property (nonatomic, strong) EditItemView *memberName; //会员姓名
@property (nonatomic, strong) EditItemView *phoneNum; //手机号
@property (nonatomic, strong) EditItemView *operateType; //操作类型
@property (nonatomic, strong) EditItemView *operater; //操作人/员工姓名
@property (nonatomic, strong) EditItemView *employeeID; //员工工号
@property (nonatomic, strong) EditItemView *shopName; //所属门店
@property (nonatomic, strong) EditItemView *operateTime; //操作时间
//@property (nonatomic, strong) NSNumber *operateTime; //操作时间
@property (nonatomic, strong) UIView *viewLine;//分割线
@end

@implementation LSMemberCardOperateDetailCell

+ (instancetype)shopColllectionDetailListCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSMemberCardOperateDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSMemberCardOperateDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    /*
    self.cardNum = [[UILabel alloc] init];
    self.cardNum.font = [UIFont systemFontOfSize:13];
    self.cardNum.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.cardNum];
    
    self.cardType = [[UILabel alloc] init];
    self.cardType.font = [UIFont systemFontOfSize:13];
    self.cardType.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.cardType];
    
    self.memberName = [[UILabel alloc] init];
    self.memberName.font = [UIFont systemFontOfSize:13];
    self.memberName.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.memberName];
    
    self.phoneNum = [[UILabel alloc] init];
    self.phoneNum.font = [UIFont systemFontOfSize:13];
    self.phoneNum.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.phoneNum];
    
    self.operateType = [[UILabel alloc] init];
    self.operateType.font = [UIFont systemFontOfSize:13];
    self.operateType.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.operateType];
    
    self.operater = [[UILabel alloc] init];
    self.operater.font = [UIFont systemFontOfSize:13];
    self.operater.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.operater];
    
    self.shopName = [[UILabel alloc] init];
    self.shopName.font = [UIFont systemFontOfSize:13];
    self.shopName.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.shopName];
    
    self.operateTime = [[UILabel alloc] init];
    self.operateTime.font = [UIFont systemFontOfSize:13];
    self.operateTime.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.operateTime];

    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
     */
}

- (void)configConstraints {
    /*
    CGFloat margin = 10;
    __weak typeof(self) wself = self;
    [self.cardNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    [self.cardType makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    [self.memberName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    [self.phoneNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    [self.operateType makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    [self.operater makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    [self.shopName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    [self.operateTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY);
    }];

    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
    */
     
}
/*
- (void)setStaffHandoverPayTypeVo:(LSStaffHandoverPayTypeVo *)staffHandoverPayTypeVo {
    _staffHandoverPayTypeVo = staffHandoverPayTypeVo;
    NSMutableAttributedString *userNameStaffIdAttr = [[NSMutableAttributedString alloc] initWithString:staffHandoverPayTypeVo.staffName];
    [userNameStaffIdAttr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(工号:%@)", staffHandoverPayTypeVo.staffId] attributes: @{NSForegroundColorAttributeName : [ColorHelper getTipColor6], NSFontAttributeName : [UIFont systemFontOfSize:13]}]];
    self.lblNameStaffId.attributedText = userNameStaffIdAttr;
    self.lblAmount.textColor = [staffHandoverPayTypeVo.salesAmount doubleValue]<0?[ColorHelper getGreenColor]:[ColorHelper getRedColor];
    self.lblRoleName.text = staffHandoverPayTypeVo.staffRole;
    self.lblAmount.text = [NSString stringWithFormat:@"￥%.2f",[staffHandoverPayTypeVo.salesAmount doubleValue]];
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
