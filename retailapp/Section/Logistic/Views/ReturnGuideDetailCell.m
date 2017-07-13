//
//  GoodsSingleAttributeCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReturnGuideDetailCell.h"
#import "ReturnGuideListVo.h"
@implementation ReturnGuideDetailCell
- (void)initWithReturnGuideListVo:(ReturnGuideListVo *)returnGuideListVo {
    self.lblName.text = returnGuideListVo.styleName;
    self.lblCode.text = [NSString stringWithFormat:@"款号: %@",returnGuideListVo.styleCode];
    self.lblReturnAbleCount.text = [NSString stringWithFormat:@"可退总量: %@",returnGuideListVo.returnAbleCount];
    self.lblNowReturnAbleCount.text = [NSString stringWithFormat:@"当前可退量: %@",returnGuideListVo.nowReturnAbleCount];
}

@end
