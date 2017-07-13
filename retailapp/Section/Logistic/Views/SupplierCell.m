//
//  SupplierCell.m
//  retailapp
//
//  Created by hm on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SupplierCell.h"
#import "UIView+Sizes.h"

@implementation SupplierCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataWithName:(NSString *)name withDetail:(NSString *)detail withShow:(BOOL)isShow withCheck:(BOOL)isHideCheck
{
    [self showView:isShow];
    self.lblName.text = name;
    self.lblDetail.text = detail;
    self.warehousePic.hidden = !isShow;
    self.checkPic.hidden = isHideCheck;
    self.nextPic.hidden = !isHideCheck;
}

- (void)showView:(BOOL)isShow
{
    __weak typeof(self) wself = self;
    [self.lblName updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(isShow ? wself.warehousePic.right : wself.contentView.left).offset(10);
    }];
    [self.lblDetail updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(isShow ? wself.warehousePic.right : wself.contentView.left).offset(10);
    }];
}

- (void)showImageType:(BOOL)shopType
{
    __weak typeof(self) wself = self;
    [self.lblName updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.warehousePic.right).offset(10);
    }];
    [self.lblDetail updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.warehousePic.right).offset(10);
    }];
    [self.warehousePic updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(shopType ? 34 : 24);
    }];
    self.warehousePic.hidden = NO;
    self.warehousePic.image = shopType?[UIImage imageNamed:@"icon_shop"]:[UIImage imageNamed:@"ico_warehouse"];
}

@end
