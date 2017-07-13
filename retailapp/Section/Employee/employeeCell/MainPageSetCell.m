//
//  MainPageSetCell.m
//  retailapp
//
//  Created by qingmei on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MainPageSetCell.h"
#import "HomeShowVo.h"
#import "ShowTypeVo.h"
#import "ColorHelper.h"
@implementation MainPageSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (id)getInstance{
    MainPageSetCell *item = [[[NSBundle mainBundle]loadNibNamed:@"MainPageSetCell" owner:self options:nil]lastObject];
    return item;
}


- (void)loadCell:(id)obj{
    
    //设置字体颜色
    self.lblName.textColor = [ColorHelper getTipColor3];
    self.lbldetail.textColor = [ColorHelper getTipColor6];
    
    
    if ([obj isKindOfClass:[HomeShowVo class]]) {
        HomeShowVo *temp = obj;
        self.lblName.text = temp.roleName;
        NSMutableString *strShow = [NSMutableString string];
        for (ShowTypeVo *typeVo in temp.showTypeVoList) {
            if (typeVo.isShow) {
                [strShow appendString:typeVo.showTypeName];
                [strShow appendString:@"、"];
            }
        }
        NSString *str = [NSString string];
        if (strShow.length >1) {
          str = [strShow substringToIndex:strShow.length - 1];
        }
        
        self.lbldetail.text = str;
        
    }
}

@end
