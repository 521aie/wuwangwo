//
//  ShoesClothingCell.m
//  retailapp
//
//  Created by hm on 15/9/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShoesClothingCell.h"
#import "ColorHelper.h"
#import "PaperDetailVo.h"
@implementation ShoesClothingCell


- (void)loadData:(PaperDetailVo*)item isEdit:(BOOL)isEdit isSearchPrice:(BOOL)isSearchPrice
{
    
    self.lblName.text = item.goodsName;
    self.lblStyleNo.text = [NSString stringWithFormat:@"款号：%@",item.styleCode];
    self.lblStyleCount.text = [NSString stringWithFormat:@"x%.0f",item.goodsSum];
    self.lblTotalMoney.text = [NSString stringWithFormat:@"￥%.2f", item.goodsTotalPrice];
    [self showMarkRed:([ObjectUtil isNotNull:item.styleCanReturn] && [item.styleCanReturn integerValue] < item.goodsSum)];
}

- (void)showMarkRed:(BOOL)show
{
    self.lblName.textColor = show?[ColorHelper getRedColor]:[ColorHelper getTipColor3];
    self.lblStyleNo.textColor = show?[ColorHelper getRedColor]:[ColorHelper getTipColor6];
    self.lblStyleCount.textColor = show?[ColorHelper getRedColor]:[ColorHelper getTipColor6];
    self.lblTotalMoney.textColor = show?[ColorHelper getRedColor]:[ColorHelper getTipColor6];
}

@end
