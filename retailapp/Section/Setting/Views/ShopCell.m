//
//  ShopCell.m
//  retailapp
//
//  Created by hm on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopCell.h"
#import "UIView+Sizes.h"
#import "TreeItem.h"
@implementation ShopCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initDelegate:(id<ShopCellDelegate>)delegateTemp withItem:(TreeItem*)item
{
    _delegate = delegateTemp;
    _item = item;
}

- (void)showImg:(BOOL)show withType:(NSInteger)type
{
    if (type==1) {
        //下属机构列表，分支查询结构列表
        self.expandBtn.hidden = YES;
        self.shopImage.image = [UIImage imageNamed:@"icon_shop.png"];
        self.shopImage.hidden = !show;
        [self setLevel:1];
    }else{
        //分支树状结构
        
        if (_item.subItems==nil||_item.subItems.count==0) {
            //没有下级，隐藏
            self.shopImage.hidden = YES;
            self.expandBtn.hidden = YES;
        }else{
            self.shopImage.hidden = NO;
            self.expandBtn.hidden = NO;
        }
        if (show) {
            //门店显示图标
            self.shopImage.hidden = NO;
            self.shopImage.image = [UIImage imageNamed:@"icon_shop.png"];
        }else{
            self.shopImage.image =_item.isSubItemOpen? [UIImage imageNamed:@"icon_sanjiao2"]:[UIImage imageNamed:@"icon_sanjiao1"];
        }
        [self setLevel:_item.level];
    }
}

//根据层级设置偏移量
- (void)setLevel:(NSInteger)level
{
    [self.shopImage updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(level*10);
    }];
}
//伸缩子级
- (IBAction)expandBtnClick:(id)sender
{
    self.shopImage.image =!_item.isSubItemOpen? [UIImage imageNamed:@"icon_sanjiao2"]:[UIImage imageNamed:@"icon_sanjiao1"];
    if (_delegate&&[_delegate respondsToSelector:@selector(expandCell:)]) {
        [_delegate expandCell:self];
    }
}

@end
