//
//  LSModuleCell.m
//  retailapp
//
//  Created by guozhi on 2016/11/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSModuleCell.h"

@interface LSModuleCell ()
/** 菜单图片 */
@property (nonatomic, strong) UIImageView *imgMenu;
/** 加锁图片权限控制 */
@property (nonatomic, strong) UIImageView *imgLock;
/** 菜单标题 */
@property (nonatomic, strong) UILabel *lblName;
/** 菜单详情 */
@property (nonatomic, strong) UILabel *lblDetail;
/** 白色背景 */
@property (nonatomic, strong) UIView *bgView;
@end

@implementation LSModuleCell
+ (instancetype)moduleCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSModuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //白色背景
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.contentView addSubview:self.bgView];
    
    //菜单图片
    self.imgMenu = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgMenu];
    
    //加锁图片
    self.imgLock = [[UIImageView alloc] init];
    self.imgLock.image = [UIImage imageNamed:@"ico_pw"];
    [self.contentView addSubview:self.imgLock];
    
    //菜单内容
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont boldSystemFontOfSize:18];
    self.lblName.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.lblName];
    
    //菜单详情
    self.lblDetail = [[UILabel alloc] init];
    self.lblDetail.font = [UIFont boldSystemFontOfSize:13];
    self.lblDetail.textColor = [ColorHelper getTipColor6];
    self.lblDetail.numberOfLines = 2;
    [self.contentView addSubview:self.lblDetail];
    
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //配置白色背景
    [self.bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(wself.contentView);
        make.bottom.equalTo(wself.contentView).offset(-1);
    }];
    //配置菜单图片
    [self.imgMenu makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView).offset(20);
        make.size.equalTo(CGSizeMake(64, 64));
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    //配置加锁图片
    [self.imgLock makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(22);
        make.right.equalTo(wself.contentView).offset(-15);
        make.top.equalTo(wself.contentView.top);
    }];
    //配置菜单内容
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.imgMenu.top).offset(5);
        make.left.equalTo(wself.imgMenu.right).offset(20);
        make.right.equalTo(wself.contentView.right).offset(-20);
    }];
    //配置菜单详情
    [self.lblDetail makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wself.imgMenu.bottom).offset(-5);
        make.left.equalTo(wself.imgMenu.right).offset(20);
        make.right.equalTo(wself.contentView.right);
    }];
}

- (void)setModel:(LSModuleModel *)model {
    self.lblName.text = model.name;
    self.lblDetail.text = model.detail;
    __weak typeof(self) wself = self;
    if ([NSString isBlank:model.detail]) {//顾客评价是没有详情的 这时标题需要居中显示
        //配置菜单内容
        [self.lblName remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wself.imgMenu.centerY);
            make.left.equalTo(wself.imgMenu.right).offset(20);
            make.right.equalTo(wself.contentView.right).offset(-20);
        }];
    } else {
        //配置菜单内容
        [self.lblName remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wself.imgMenu.top).offset(5);
            make.left.equalTo(wself.imgMenu.right).offset(20);
            make.right.equalTo(wself.contentView.right).offset(-20);
        }];
    }
    self.imgMenu.image = [UIImage imageNamed:model.path];
    self.imgLock.hidden = !([[Platform Instance] lockAct:model.code]);
}

@end
