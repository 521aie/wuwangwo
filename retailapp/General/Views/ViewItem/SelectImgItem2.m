//
//  ItemCertId.m
//  RestApp
//
//  Created by zxh on 14-10-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectImgItem2.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"
#import "AlertBox.h"

@implementation SelectImgItem2

- (void)borderLine:(UIView*)view
{
    CALayer *layer=[view layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    UIColor* color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [layer setBorderColor:[color CGColor]];
}

- (int)getHeight
{
    return 200;
}

- (void)initDelegate:(id<IEditItemImageEvent>)delegate
{
    self.delegate=delegate;
}

- (void)initView:(NSString *)filePathP path:(NSString *)pathP
{
    path = pathP;
    filePath = filePathP;
    [self borderLine:self.bgView];
    if ([NSString isBlank:filePath]) {
        [self showAddUI:YES];
    } else {
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil];
        [self showAddUI:NO];
    }
}

- (void)initWithImage:(UIImage *)image path:(NSString *)pathP
{
    path = pathP;
    filePath = nil;
    [self borderLine:self.bgView];
    if (image != nil) {
        [self showAddUI:NO];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imgView setImage:image];
    }
}

- (void)showAddUI:(BOOL)flag
{
    [self.addView setHidden:!flag];
    [self.imgView setHidden:flag];
    [self.btnItem setHidden:NO];
    
}

- (IBAction)UP:(id)sender {
    [self.delegate upImg:path];
}

- (IBAction)DOWN:(id)sender {
    [self.delegate downImg:path];
}

#pragma image add event
- (IBAction)onBtnClick:(id)sender
{
    [self.delegate imgClick:self];
//    [AlertBox show:@"点击%@",_btnItem.tag];
}

@end
