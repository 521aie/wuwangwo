//
//  ItemCertId.m
//  RestApp
//
//  Created by zxh on 14-10-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectImgItem3.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"

@implementation SelectImgItem3

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
    self.path = pathP;
    filePath = filePathP;
    [self borderLine:self.bgView];
    
    if ([NSString isBlank:filePath]) {
    
        [self showAddUI:YES];
    }else {
        
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *loadingIcon = [UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"icon_loading" ofType:@"jpg"]];
        //图片加载时，显示加载中提示图片，如果失败显示加载失败提示图片，成功则显示加载成功的图片
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:loadingIcon completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error && !image) {
                UIImage *loadFailIcon = [UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"icon_load_fail" ofType:@"jpg"]];
                self.imgView.image = loadFailIcon;
            }
        }];
        [self showAddUI:NO];
    }
}

- (void)initWithImage:(UIImage *)image path:(NSString *)pathP
{
    self.path = pathP;
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
    [self.imgDel setHidden:flag];
    [self.btnDel setHidden:flag];
    [self.btnItem setHidden:!flag];
}

#pragma image del event
- (IBAction)onDelClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确认要删除当前的图片吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认", nil];
    sheet.tag=2;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)UP:(id)sender {
    
    [self.delegate upImg:self.path];
    
    
}

- (IBAction)DOWN:(id)sender {
    [self.delegate downImg:self.path];
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
            [self.delegate onDelImgClickWithPath:self.path];
        }
    } else {
        if (buttonIndex==0 || buttonIndex==1) {
            [self.delegate onConfirmImgClickWithTag:buttonIndex tag:self.tag];
        }
    }
}



@end
