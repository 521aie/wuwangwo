//
//  ItemCell.m
//  retailapp
//
//  Created by guozhi on 15/10/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemCell.h"
#import "ColorHelper.h"

@implementation ItemCell
- (void)initLable:(NSString *)title withVal:(NSString *)val {
    self.lblName.text = title;
    self.lblVal.text = val;
    self.lblName.textColor = [ColorHelper getTipColor3];
}

@end
