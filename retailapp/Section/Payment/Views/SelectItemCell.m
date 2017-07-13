//
//  SelectItemCell.m
//  retailapp
//
//  Created by guozhi on 16/5/15.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectItemCell.h"


@implementation SelectItemCell

- (void)initWithData:(id<INameItem>)data isSelected:(BOOL)isSelected
{
    self.lblName.text = [data obtainItemName];
    [self setSelect:isSelected];
}
- (void)setSelect:(BOOL)isSelected
{
    if (isSelected) {
        self.img.image = [UIImage imageNamed:@"ico_check.png"];
    } else {
        self.img.image = [UIImage imageNamed:@"ico_uncheck.png"];
    }
}

@end
