//
//  ItemCertId.m
//  RestApp
//
//  Created by zxh on 14-10-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemCertId.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"

@implementation ItemCertId

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ItemCertId" owner:self options:nil];
    self.view.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 200);
    [self addSubview:self.view];
    [self borderLine:self.bgView];
}

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

- (void)initLabel:(NSString*)label delegate:(id<IEditItemImageEvent>)delegate
{
    self.delegate=delegate;
    self.lblTitle.text=label;
}

- (void)initView:(NSString *)filePath
{
    self.currentVal = [NSString getImagePath:filePath];
    self.oldVal = [NSString getImagePath:filePath];

    if ([NSString isBlank:filePath]) {
        [self showAddUI:YES];
    } else {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil];
        [self showAddUI:NO];
    }
}

- (void)showAddUI:(BOOL)flag
{
    [self.addView setHidden:!flag];
    [self.imgView setHidden:flag];
    [self.imgDel setHidden:flag];
    [self.btnDel setHidden:flag];
}

#pragma  ui is changing.
- (void) changeImg:(NSString*)filePath img:(UIImage*)img
{
    self.currentVal = filePath;
    if([NSString isBlank:filePath]){
        self.imgView.image=nil;
    }else{
        self.imgView.image=img;
    }
    [self showAddUI:NO];
}

- (BOOL)isChange {
    if ([self.currentVal isEqualToString:self.oldVal]) {
        return NO;
    } else {
        return YES;
    }

}

#pragma image del event
- (IBAction)onDelClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确认要删除当前的图片吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认", nil];
    sheet.tag=2;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma image add event
- (IBAction)onBtnClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    sheet.tag=1;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //获取点击按钮的标题
    if (actionSheet.tag==2) {
        if (buttonIndex==0) {
            [self.delegate onDelImgClickWithTag:self.tag];
            self.imgView.image=nil;
            [self showAddUI:YES];
        }
    } else {
        if (buttonIndex==0 || buttonIndex==1) {
            [self.delegate onConfirmImgClickWithTag:buttonIndex tag:self.tag];
        }
    }
}

- (void)setOnlyShow {
    [self.addView setHidden:YES];
    [self.btnAdd setHidden:YES];
    [self.imgView setHidden:NO];
    [self.imgDel setHidden:YES];
    [self.btnDel setHidden:YES];
}

@end
