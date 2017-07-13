//
//  LSMenuLeftCell.m
//  retailapp
//
//  Created by guozhi on 2017/2/27.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMenuLeftCell.h"
@interface LSMenuLeftCell()
/** 图标 */
@property (nonatomic, strong) UIImageView *imgIcon;
/** 名称 */
@property (nonatomic, strong) UILabel *lblName;
/** 加锁图标 */
@property (nonatomic, strong) UIImageView *imgLock;
@end
@implementation LSMenuLeftCell
+ (instancetype)menuLeftCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSMenuLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSMenuLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
    //图标
    self.imgIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgIcon];
    //名称
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:14];
    self.lblName.textColor = [ColorHelper getWhiteColor];
    [self.contentView addSubview:self.lblName];
    //加锁图片
    self.imgLock = [[UIImageView alloc] init];
    self.imgLock.image = [UIImage imageNamed:@"icon_lock"];
    [self.contentView addSubview:self.imgLock];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //图标
    [wself.imgIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(30);
        make.centerY.equalTo(wself.contentView);
        make.size.equalTo(22);
    }];
    //名称
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgIcon.right).offset(10);
        make.centerY.equalTo(wself.centerY);
    }];
    //加锁图片
    [self.imgLock makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.right).offset(-25);
        make.centerY.equalTo(wself.contentView);
        make.size.equalTo(22);
    }];
}

- (void)setObj:(LSModuleModel *)obj {
    _obj = obj;
    //图标
    self.imgIcon.image = [UIImage imageNamed:obj.path];
    //名称
    self.lblName.text = obj.name;
    //加锁图标
    self.imgLock.hidden = ![[Platform Instance] lockAct:obj.code];
}

@end
