//
//  EditItemImage.m
//  RestApp
//
//  Created by zxh on 14-7-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "EditItemImage.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import <Masonry/Masonry.h>

@implementation EditItemImage

+ (instancetype)editItemImage {    
    EditItemImage *itemImage = [[EditItemImage alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 250)];
    [itemImage awakeFromNib];
    return itemImage;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemImage" owner:self options:nil];
    self.view.ls_width = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.ls_width = CGRectGetWidth([UIScreen mainScreen].bounds);
    [self addSubview:self.view];
    [self borderLine:self.borderView];
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
    self.lblDetail.text = hit;
    __weak typeof(self) wself = self;
    if ([NSString isBlank:hit]) {//如果没有详情
        self.lblDetail.hidden = YES;
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(wself.mas_top).offset(250);
            make.left.equalTo(wself.mas_left).offset(10);
            make.right.equalTo(wself.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
    } else {//如果有详情
        self.lblDetail.hidden = NO;
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wself.lblDetail.mas_bottom).offset(10);
            make.left.equalTo(wself.mas_left).offset(10);
            make.right.equalTo(wself.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
    }
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (float) getHeight
{
    [self layoutIfNeeded];
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

- (void)changeImg:(NSString *)filePath img:(UIImage*)image
{
    self.imgFilePath = filePath;
    self.currentVal = filePath;
    self.changed = YES;
    if (image != nil) {
        [self showAdd:NO];
        self.img.contentMode = UIViewContentModeScaleToFill;
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
    self.oldVal=[NSString getImagePath:filePath];
    self.currentVal=[NSString getImagePath:filePath];
    self.imgFilePath=path;
    if([NSString isBlank:filePath]){
        [self showAdd:YES];
    } else {
//        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil
//                                   options:SDWebImageRetryFailed|SDWebImageRefreshCached];
        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil) {
                [self showAdd:YES];
            } else {
                [self showAdd:NO];
            }
            
        }];
//        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil];
        
    }
    self.changed = NO;
    [self changeStatus];
}

- (void) showAdd:(BOOL)showAdd
{
    [self.img setHidden:showAdd];
    [self.imgDel setHidden:showAdd];
    [self.btnDel setHidden:showAdd];
    [self.imgAdd setHidden:!showAdd]; 
    [self.lblAdd setHidden:!showAdd];
    [self.lblInfo setHidden:!showAdd];
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

- (void)editEnabled:(BOOL)enable
{
    self.btnDel.enabled = enable;
    self.btnAdd.enabled = enable;
}

@end
