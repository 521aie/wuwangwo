//
//  GoodsAndStyleCell.m
//  retailapp
//
//  Created by qingmei on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsAndStyleCell.h"
#import "RoleCommissionVo.h"
#import "RoleCommissionDetailVo.h"
#import "ObjectUtil.h"
#import "ColorHelper.h"

@implementation GoodsAndStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (id)getInstance{
    GoodsAndStyleCell *item = [[[NSBundle mainBundle]loadNibNamed:@"GoodsAndStyleCell" owner:self options:nil]lastObject];
    return item;
}


- (void)loadCell:(id)obj{
    
    //设置字体颜色
    self.lblTitle.textColor = [ColorHelper getTipColor3];
    self.lblLeft.textColor = [ColorHelper getTipColor6];
    self.lblRight.textColor = [ColorHelper getTipColor6];
    
    if ([obj isKindOfClass:[RoleCommissionDetailVo class]]) {
        RoleCommissionDetailVo *temp = obj;
        
        self.lblTitle.text = temp.goodsName;
        if (1 == temp.goodsType) {
            self.lblLeft.text = temp.goodsBar;
        }
        else if (2 == temp.goodsType){
            NSString *str = [NSString stringWithFormat:@"款号: %@",temp.goodsBar];
            self.lblLeft.text = str;
        }
        
        NSMutableString *str =  [NSMutableString stringWithString:@"提成比例(%):  "];
        NSString *ratio = [NSString stringWithFormat:@"%.2f",temp.commissionRatio];
        [str appendString:ratio];
        
        
        
        self.lblRight.text = str;
        
    }
}

@end
