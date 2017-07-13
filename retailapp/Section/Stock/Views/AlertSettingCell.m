//
//  VirtualStockCell.m
//  retailapp
//
//  Created by guozhi on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AlertSettingCell.h"
#import "ColorHelper.h"
#import "UIImageView+WebCache.h"
#import "UIView+Sizes.h"
#import "GoodsVo.h"

@implementation AlertSettingCell

- (void)setObj:(GoodsVo *)obj {
    _obj = obj;
    [self.img sd_setImageWithURL:[NSURL URLWithString:obj.filePath] placeholderImage:[UIImage imageNamed:@"img_default"]];
    self.labName.text = obj.goodsName;
    self.labCode.text = obj.barCode;
}

@end
