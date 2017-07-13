//
//  EditItemImage3.m
//  retailapp
//
//  Created by zhangzt on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemImage3.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@implementation EditItemImage3

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemImage" owner:self options:nil];
    [self addSubview:self.view];
    [self borderLine:self.borderView];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"EditItemImage3" owner:self options:nil];
        [self addSubview:self.view];
        [self borderLine:self.borderView];
    }
    return self;
}

-(void) borderLine:(UIView*)view
{
    CALayer *layer=[view layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    UIColor* color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [layer setBorderColor:[color CGColor]];
}

#pragma  initHit.
- (void)initHit:(NSString *)hit
{
    self.lblDetail.text=nil;
    [self.lblDetail setLs_width:300];
    self.lblDetail.text=hit;
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if ([NSString isBlank:hit]) {
        [self.lblDetail setLs_height:0];
        [self.line setLs_top:250];
    } else {
        [self.lblDetail sizeToFit];
        [self.line setLs_top:(self.lblDetail.ls_top+self.lblDetail.ls_height+2)];
    }
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (float) getHeight
{
    return self.line.ls_top + self.line.ls_height + 1;
}

- (void)initLabel:(NSString*)label withHit:(NSString *)hit
{
    self.lblName.text=label;
    [self initHit:hit];
}

- (void)initLabel:(NSString*)label withHit:(NSString *)hit delegate:(id<IEditItemImageEvent>)delegate
{
    self.lblName.text=label;
    self.delegate=delegate;
    [self initHit:hit];
    
}
//微店款式 颜色id新增
- (void)initLabel:(NSString*)label colorId:(NSString *) colorId withHit:(NSString *)hit delegate:(id<IEditItemImageEvent>)delegate
{
    self.lblName.text=label;
    self.colorId=colorId;
    self.delegate=delegate;
    [self initHit:hit];
    
}

- (void)changeImg:(NSString *)filePath img:(UIImage*)image
{
    self.imgFilePath = filePath;
    self.currentVal = filePath;
    self.changed = YES;
    if (image != nil) {
        [self showAdd:NO];
        self.img.contentMode = UIViewContentModeScaleAspectFill;
        [self.img setImage:image];
    } else {
        [self showAdd:YES];
        [self.img setImage:nil];
    }
    [self changeStatus];
}

-(IBAction)btnAddClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    sheet.tag=1;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(IBAction)btnDelClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确认要删除当前的图片吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认", nil];
    sheet.tag=2;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)initView:(NSString *)filePath path:(NSString *)path
{
    self.oldVal=filePath;
    self.currentVal=filePath;
    self.imgFilePath=path;
    if([NSString isBlank:filePath]){
        [self showAdd:YES];
    } else {
        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil];
        [self showAdd:NO];
    }
    self.changed = NO;
    [self changeStatus];
}

- (void)showAdd:(BOOL)showAdd
{
    [self.img setHidden:showAdd];
    [self.imgDel setHidden:showAdd];
    [self.btnDel setHidden:showAdd];
    [self.imgAdd setHidden:!showAdd];
    [self.lblAdd setHidden:!showAdd];
}

- (void)changeStatus
{
    [super isChange];
}

- (NSString *)getImageFilePath
{
    return self.imgFilePath;
}

- (NSString *)getColorId
{
    return self.colorId;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==2) {
        if (buttonIndex==0) {
            [self.delegate onDelImgClick:self];
        }
    } else {
        if(buttonIndex==0 || buttonIndex==1) {
            [self.delegate onConfirmImgClick:buttonIndex Event:self];
        }
    }
}

// 编辑设置
- (void)imageItemEditable:(BOOL)editable {
    
    self.btnDel.hidden = !editable;
    self.imgDel.hidden = !editable;
    self.btnAdd.enabled = editable;
    self.userInteractionEnabled = editable;
}


@end
