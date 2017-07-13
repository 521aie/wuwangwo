//
//  StyleItem.m
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StyleItem1.h"
#import "NSString+Estimate.h"

@implementation StyleItem1

+ (StyleItem1 *)loadFromNib {
    StyleItem1 *styleItem = [[[NSBundle mainBundle] loadNibNamed:@"StyleItem1" owner:self options:nil] lastObject];
    return styleItem;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)loadDataWithPath:(NSString *)filePath withName:(NSString *)name withCode:(NSString *)code withPrice:(NSString *)price {
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil];
    self.lblName.text = name;
    self.lblStyleCode.text = code;
}

- (void)resetHeight {
    
    CGFloat rawHeight = 88.0;
    CGFloat vitualHeight = 54.0;
    CGFloat maxWidth = SCREEN_W - CGRectGetMaxX(_pic.frame) - 16;
    if ([NSString isNotBlank:_lblName.text]) {
        CGFloat height = [NSString getTextSizeWithText:_lblName.text font:_lblName.font maxSize:CGSizeMake(maxWidth, CGFLOAT_MAX)].height + 1;
        vitualHeight += height;
    }

    if (vitualHeight < rawHeight) {
        vitualHeight = rawHeight;
    }
    self.ls_height = vitualHeight;
}

@end
