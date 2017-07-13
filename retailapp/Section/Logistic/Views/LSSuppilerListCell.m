//
//  LSSuppilerListCell.m
//  retailapp
//
//  Created by guozhi on 2017/2/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSuppilerListCell.h"

@interface LSSuppilerListCell ()
/** 供应商名称 */
@property (nonatomic, strong) UILabel *lblSuppileName;
/** 供应商联系人 */
@property (nonatomic, strong) UILabel *lblSuppileContact;
/** 供应商手机号 */
@property (nonatomic, strong) UILabel *lblSuppilerMobile;
/** 下一个图标 */
@property (nonatomic, strong) UIImageView *imgView;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation LSSuppilerListCell
+ (instancetype)suppilerListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSSuppilerListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSSuppilerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //供应商名称
    self.lblSuppileName = [[UILabel alloc] init];
    self.lblSuppileName.font = [UIFont systemFontOfSize:15];
    self.lblSuppileName.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.lblSuppileName];
    
    //供应商联系人
    self.lblSuppileContact = [[UILabel alloc] init];
    self.lblSuppileContact.font = [UIFont systemFontOfSize:13];
    self.lblSuppileContact.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblSuppileContact];
    
    //供应商手机号
    self.lblSuppilerMobile = [[UILabel alloc] init];
    self.lblSuppilerMobile.font = [UIFont systemFontOfSize:13];
    self.lblSuppilerMobile.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.lblSuppilerMobile];
    
    //下一个图标
    self.imgView = [[UIImageView alloc] init];
    self.imgView.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.imgView];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //供应商名称
    [self.lblSuppileName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(10);
        make.top.equalTo(wself.contentView).offset(15);
        make.right.equalTo(wself.contentView).offset(-10);
    }];
  
    //供应商联系人
    [self.lblSuppileContact makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(10);
        make.bottom.equalTo(wself.contentView).offset(-15);
        make.right.equalTo(wself.lblSuppilerMobile.left).offset(-10);
    }];
    
    //供应商手机号
    [self.lblSuppilerMobile makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wself.contentView).offset(-15);
        make.right.equalTo(wself.imgView.left);
    }];
    [self.lblSuppilerMobile setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    //下一个图标
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.right).offset(-10);
        make.size.equalTo(22);
        make.centerY.equalTo(wself.contentView);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];

}

- (void)setObj:(SupplyVo *)obj {
    self.lblSuppileName.text = obj.supplyName;
    self.lblSuppileContact.text = [NSString stringWithFormat:@"联系人：%@", obj.relation];
    self.lblSuppilerMobile.text = [NSString stringWithFormat:@"手机：%@", obj.mobile];
}
@end
