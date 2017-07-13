//
//  GoodsSingleAttributeCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReturnGuideCell.h"
#import "ReturnGoodsGuideVo.h"
#import "ColorHelper.h"

@implementation ReturnGuideCell

- (void)initWithReturnGoodsGuidoVo:(ReturnGoodsGuideVo *)returnGoodsGuideVo {
    self.lblName.text = returnGoodsGuideVo.name;
    self.lblCode.text = returnGoodsGuideVo.code;
    self.lblCode.textColor = [ColorHelper getBlueColor];
    
    
}
@end
