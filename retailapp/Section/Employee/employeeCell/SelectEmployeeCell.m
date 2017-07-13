//
//  EmployeeCell.m
//  retailapp
//
//  Created by qingmei on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectEmployeeCell.h"
#import "EmlpoyeeUserIntroVo.h"
#import "UserPerformanceTargetVo.h"
#import "UIImageView+WebCache.h"
#import "ObjectUtil.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"

@implementation SelectEmployeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (id)getInstance{
    SelectEmployeeCell *item = [[[NSBundle mainBundle]loadNibNamed:@"SelectEmployeeCell" owner:self options:nil]lastObject];
    return item;
}
- (void)loadCell:(id)obj{
    
    //设置字体颜色
    self.lblName.textColor = [ColorHelper getTipColor3];
    self.lblDetail1.textColor = [ColorHelper getTipColor6];
    self.lblDetail2.textColor = [ColorHelper getTipColor6];
    
    self.imgHead.layer.cornerRadius = 4.0;
    self.imgHead.layer.borderColor = [ColorHelper getTipColor6].CGColor;
    self.imgHead.layer.borderWidth = 0;
    self.imgHead.layer.masksToBounds = YES;
    
    if ([obj isKindOfClass:[EmlpoyeeUserIntroVo class]]) {
        EmlpoyeeUserIntroVo *userIntro = (EmlpoyeeUserIntroVo*)obj;
        self.lblName.text = userIntro.name;
        self.lblDetail1.text = [NSString stringWithFormat:@"工号:%@",userIntro.staffId];
        if ([ObjectUtil isNotNull:userIntro.mobile] && ![userIntro.mobile isEqualToString:@""]) {
            self.lblDetail2.text = [NSString stringWithFormat:@"手机:%@",userIntro.mobile];
        }else{
            self.lblDetail2.text = [NSString stringWithFormat:@"手机:%@",@"无"];
        }
        self.lblRole.text = userIntro.roleName;
        if([NSString isNotBlank:userIntro.fileName]){
            [self.imgHead sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:userIntro.fileName]] placeholderImage:nil];
            
            self.imgRoleBG.hidden = NO;
            self.lblRole.textColor = [ColorHelper getWhiteColor];
        }else{
            self.imgRoleBG.hidden = YES;
            self.lblRole.textColor = [ColorHelper getTipColor3];
            if (userIntro.sex == 2) {//女
                [self.imgHead setImage:[UIImage imageNamed:@"img_employee_cellbg_female.png"]];
            }else{//男
                [self.imgHead setImage:[UIImage imageNamed:@"img_employee_cellbg_male.png"]];
            }

        }
    }
}
@end
