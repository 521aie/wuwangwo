//
//  StyleItem.m
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StyleItem.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "UIImageView+SDAdd.h"
#import "NSString+Estimate.h"

@implementation StyleItem

+ (StyleItem *)loadFromNib
{
    StyleItem *styleItem = [[[NSBundle mainBundle] loadNibNamed:@"StyleItem" owner:self options:nil] lastObject];
    styleItem.pic.layer.masksToBounds = YES;
    styleItem.pic.layer.cornerRadius = 4.0;
    return styleItem;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)loadDataWithPath:(NSString *)filePath withName:(NSString *)name withCode:(NSString *)code withPrice:(NSString *)price
{
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil];
    self.lblName.text = name;
    self.lblStyleCode.text = code;
    self.lblPrice.text = price;
}

- (void)changeUIWithPriceName:(NSString *)priceName withPrice:(NSString *)price isEdit:(BOOL)isEdit
{
    self.priceButton.enabled = isEdit;
    self.lblPriceName.text = priceName;
    self.lblPrice.textColor = isEdit?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
    self.imgNext.hidden = !isEdit;
    NSDictionary *attribute = @{NSFontAttributeName: self.lblPriceName.font};
    CGRect nameRect = [priceName boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    [self.lblPriceName setLs_width:nameRect.size.width];
    [self initStretchWidth:price];
}

- (void)initStretchWidth:(NSString *)price
{
    self.lblPrice.text = price;
    CGRect priceRect = [price boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.lblPriceName.font} context:nil];
    [self.lblPrice setLs_width:priceRect.size.width];
    CGFloat left = self.lblPriceName.ls_origin.x+self.lblPriceName.ls_width;
    [self.lblPrice setLs_left:left];
    [self.priceButton setLs_left:left];
    [self.imgNext setLs_left:left+self.lblPrice.ls_width+2];
    [self.priceButton setLs_width:self.lblPrice.ls_width+2+self.imgNext.ls_width];
}


- (IBAction)onEditPriceClick:(id)sender
{
    if (self.styleItemDelegate&&[self.styleItemDelegate respondsToSelector:@selector(inputNumber)]) {
        [self.styleItemDelegate inputNumber];
    }
}


@end
