//
//  CheckShopCell.m
//  retailapp
//
//  Created by hm on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CheckShopCell.h"
#import "UIView+Sizes.h"
#import "TreeItem.h"

@implementation CheckShopCell


- (void)initDeleagte:(id<CheckShopCellDelegate>)delegate withItem:(TreeItem*)item
{
    _delegate = delegate;
    _item = item;
}

- (void)showImg:(BOOL)show withType:(NSInteger)type withCheck:(BOOL)check
{
    if (type==1) {
        self.btnExpand.hidden = YES;
        self.shopImage.image = [UIImage imageNamed:@"icon_shop"];
        self.shopImage.hidden = !show;
        self.checkImage.hidden = !check;
        [self changePos:1];
        [self.shopImage updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(24, 34));
        }];
    }else{
        self.checkImage.hidden = !check;
        if (_item.subItems==nil||_item.subItems.count==0) {
            self.shopImage.hidden = YES;
            self.btnExpand.hidden = YES;
        }else{
            self.shopImage.hidden = NO;
            self.btnExpand.hidden = NO;
        }
        if (show) {
            self.shopImage.hidden = NO;
            self.shopImage.image = [UIImage imageNamed:@"icon_shop"];
            [self.shopImage updateConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(24, 34));
            }];
        }else{
            [self.shopImage updateConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(24, 49));
            }];
            self.shopImage.image =_item.isSubItemOpen? [UIImage imageNamed:@"icon_sanjiao2"]:[UIImage imageNamed:@"icon_sanjiao1"];
        }
        [self changePos:_item.level];
    }
}

- (void)changePos:(NSInteger)level
{
    [self.shopImage updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(level*10);
    }];
}

- (IBAction)btnExpandClick:(id)sender
{
    self.shopImage.image =!_item.isSubItemOpen? [UIImage imageNamed:@"icon_sanjiao2"]:[UIImage imageNamed:@"icon_sanjiao1"];
    [_delegate expandCell:self];
}

@end
