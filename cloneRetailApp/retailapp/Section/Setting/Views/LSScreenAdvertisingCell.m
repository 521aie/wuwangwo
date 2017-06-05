//
//  LSScreenAdvertisingCell.m
//  retailapp
//
//  Created by guozhi on 2016/11/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSScreenAdvertisingCell.h"
#import "ColorHelper.h"

@implementation LSScreenAdvertisingCell
+ (instancetype)screenAdvertisingCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"cell";
    LSScreenAdvertisingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LSScreenAdvertisingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}
- (void)configViews {
    //logo
    self.imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgView];
    //标题
    self.lblName = [[UILabel alloc] init];
    self.lblName.textColor = [UIColor blackColor];
    self.lblName.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:self.lblName];
    //详情
    self.lblDetail = [[UILabel alloc] init];
    self.lblDetail.textColor = [ColorHelper getTipColor6];
    self.lblDetail.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.lblDetail];
}

- (void)configConstraints {
    CGFloat margin = 20;
    __weak typeof(self) wself = self;
    //配置logo
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(64);
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.centerY.equalTo(wself.contentView.centerY);
    }];
    
    //配置标题
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgView.right).offset(margin);
        make.top.equalTo(wself.imgView.top).offset(5);
        make.right.equalTo(wself.contentView.right).offset(-margin);
    }];
    
    //配置说明
    [self.lblDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgView.right).offset(margin);
        make.bottom.equalTo(wself.imgView.bottom).offset(-5);
        make.right.equalTo(wself.contentView.right).offset(-margin);
    }];

}

- (void)setDict:(NSDictionary *)dict {
    self.imgView.image = [UIImage imageNamed:dict[@"path"]];
    self.lblName.text = dict[@"name"];
    self.lblDetail.text = dict[@"detail"];
    
}


@end
