//
//  RoleCell.m
//  retailapp
//
//  Created by qingmei on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RoleCell.h"
#import "RoleVo.h"
#import "RoleCommissionVo.h"
#import "ColorHelper.h"

@implementation RoleCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (id)getInstance{
    RoleCell *item = [[[NSBundle mainBundle]loadNibNamed:@"RoleCell" owner:self options:nil]lastObject];
    return item;
}



//1、按商品提成比例
//2、按单提成
//3、按营业额提成
//4、按商品设置提成/按款式设置提成
- (void)loadCell:(id)obj{
    
    //设置字体颜色
    self.lbName.textColor = [ColorHelper getTipColor3];
    self.lbDetail.textColor = [ColorHelper getTipColor3];
    
    if ([obj isKindOfClass:[RoleVo class]]) {
        RoleVo *role = (RoleVo*)obj;
        self.lbName.text = role.roleName;
        self.lbName.font = [UIFont systemFontOfSize:15];
        self.lbDetail.text = @"";
    }
    if ([obj isKindOfClass:[RoleCommissionVo class]]) {
        RoleCommissionVo *roleCommission = (RoleCommissionVo*)obj;
        self.lbName.text = roleCommission.roleName;
        if (roleCommission.isCommission) {
            if (1 == roleCommission.commissionType) {
                self.lbDetail.text = @"使用商品提成比例";
            }else if (2 == roleCommission.commissionType){
                self.lbDetail.text = @"按单提成";
            }else if (3 == roleCommission.commissionType){
                self.lbDetail.text = @"按销售额提成";
            }else if (4 == roleCommission.commissionType){
                self.lbDetail.text = @"按商品设置提成";
            }
        }
        else{
            self.lbDetail.text = @"不提成";
        }
        
    }
}
@end
