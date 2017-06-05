//
//  SelectMicShopItem.m
//  retailapp
//
//  Created by guozhi on 16/3/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectMicShopItem.h"
#import "ColorHelper.h"
#import "MicroOrderDealVo.h"
@interface SelectMicShopItem()
@end
@implementation SelectMicShopItem
- (void)setMicroOrderDealVo:(MicroOrderDealVo *)microOrderDealVo {
    _microOrderDealVo = microOrderDealVo;
    [self initName:_microOrderDealVo.name val:_microOrderDealVo.code];
}

- (void)initName:(NSString *)name val:(NSString *)val {
    self.lblName.text = name;
    self.lblVal.text = val;
    self.lblName.textColor = [ColorHelper getTipColor3];
    self.lblVal.textColor = [ColorHelper getTipColor6];
}
@end
