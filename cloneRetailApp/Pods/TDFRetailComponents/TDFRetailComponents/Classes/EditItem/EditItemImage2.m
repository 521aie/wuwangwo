//
//  EditItemImage2.m
//  retailapp
//
//  Created by hm on 15/8/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemImage2.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "NSString+Estimate.h"
#import "ObjectUtil.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@implementation EditItemImage2
+ (instancetype)editItemImage {
    
    EditItemImage2 *itemImage = [[EditItemImage2 alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 80)];
    [itemImage awakeFromNib];
    return itemImage;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemImage2" owner:self options:nil];
    self.view.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 80);
    [self addSubview:self.view];
    [self borderLine:self.borderView];
}

- (void)borderLine:(UIView*)view
{
    CALayer *layer=[view layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:4.0];
    [layer setBorderWidth:1];
    UIColor* color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [layer setBorderColor:[color CGColor]];
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 4.0;
}

- (float)getHeight
{
    return self.line.ls_top + self.line.ls_height;
}

- (void)initLabel:(NSString*)label delegate:(id<IEditItemImageEvent>)delegate title:(NSString*) title
{
    self.lblName.text=label;
    self.delegate=delegate;
    self.title = title;
}

- (void)initImg:(NSString *)filePath img:(UIImage*)img{
    
    self.oldVal=[NSString getImagePath:filePath];
    self.currentVal=[NSString getImagePath:filePath];
    self.imgFilePath=filePath;
    self.changed = NO;
    [self.img setHidden:NO];
    
    if ([ObjectUtil isNotNull:img]) {
        self.img.contentMode = UIViewContentModeScaleAspectFit;
        [self.img setImage:img];
    } else {
        [self.img setImage:nil];
    }
}

- (void)changeImg:(NSString *)filePath img:(UIImage*)image
{
    self.imgFilePath = filePath;
    self.currentVal = filePath;
    self.changed = YES;
    if ([ObjectUtil isNotNull:image]) {
        [self showAdd:NO];
//        self.img.contentMode = UIViewContentModeScaleAspectFit;
        [self.img setImage:image];
    } else {
        [self showAdd:YES];
        [self.img setImage:nil];
    }
    [self changeStatus];
}



-(IBAction)btnAddClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"请选择%@来源", self.title] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    sheet.tag=1;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(IBAction)btnDelClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"您确认要删除当前的%@吗？", self.title] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认", nil];
    sheet.tag=2;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)initView:(NSString *)filePath path:(NSString *)path {
    
    self.oldVal = [NSString getImagePath:filePath];
    self.currentVal = [NSString getImagePath:filePath];
    self.imgFilePath = path;
    if([NSString isBlank:filePath]){
        [self showAdd:YES];
    }else {
//        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil];
        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:[UIImage imageNamed:@"img_default"] options:SDWebImageRetryFailed|SDWebImageRefreshCached];
        [self showAdd:NO];
    }
    self.changed = NO;
    [self changeStatus];
}

- (void)showAdd:(BOOL)showAdd
{
    self.isShow = showAdd;
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==2) {
        if (buttonIndex==0) {
            [self.delegate onDelImgClick];
        }
    } else {
        if(buttonIndex==0 || buttonIndex==1) {
            [self.delegate onConfirmImgClick:buttonIndex];
        }
    }
}

- (void)isEditable:(BOOL)editable
{
    self.imgDel.hidden = self.isShow ? YES : !editable;
    self.btnDel.hidden = self.isShow ? YES : !editable;
    self.userInteractionEnabled = editable;
}

@end
