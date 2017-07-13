//
//  EditItemCertId.m
//  RestApp
//
//  Created by zxh on 14-10-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemCertId.h"
#import "ItemCertId.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"

@implementation EditItemCertId

- (void)awakeFromNib
{
    [super awakeFromNib];                 
    [[NSBundle mainBundle] loadNibNamed:@"EditItemCertId" owner:self options:nil];
    self.view.frame = CGRectMake(0, 0, SCREEN_W, 480);
    self.frame = CGRectMake(0, 0, SCREEN_W, 480);
    [self addSubview:self.view];
    self.frontCertId.tag=TAG_FRONTCERTID;
    self.backCertId.tag=TAG_BACKCERTID;
}

+ (instancetype)editItemCartId {
    EditItemCertId *view = [[EditItemCertId alloc] init];
    [view awakeFromNib];
    return view;
}

- (void)initLabel:(NSString*)label delegate:(id<IEditItemImageEvent>)delegate
{
    self.lblName.text=label;
    [self.frontCertId initLabel:@"证件正面图片" delegate:delegate];
    [self.backCertId initLabel:@"证件背面图片" delegate:delegate];
}

- (float)getHeight
{
    if ([NSString isBlank:self.lblName.text]) {
        return 436;
    }
    return 456;
}

//身份证正面
- (void)initFrontImg:(NSString *)filePath
{
    self.frontChange=NO;
    self.frontPath=nil;
    if([NSString isBlank:filePath]){
        [self.frontCertId initView:nil];
    }else{
        [self.frontCertId initView:filePath];
    }
    [self changeStatus];
}

- (void)changeFrontImg:(NSString*)filePath img:(UIImage*)img
{
    self.frontChange=YES;
    self.frontPath=filePath;
    if (img!=nil) {
        [self.frontCertId changeImg:filePath img:img];
    }
    [self changeStatus];
}

//身份证背面
- (void)initBackImg:(NSString *)filePath
{
    self.backChange=NO;
    self.backPath=nil;
    if([NSString isBlank:filePath]){
        [self.backCertId initView:nil];
    }else{
        [self.backCertId initView:filePath];
    }
    [self changeStatus];
    
}

- (void)changeBackImg:(NSString*)filePath img:(UIImage*)img
{
    self.backChange=YES;
    self.backPath=filePath;
    if (img!=nil) {
        [self.backCertId changeImg:filePath img:img];
    }
    [self changeStatus];
}

#pragma change status
- (void)changeStatus
{
    BOOL flag=[self isChange];
    self.lblTip.layer.backgroundColor=[UIColor redColor].CGColor;
    self.lblTip.textColor=[UIColor whiteColor];
    self.lblTip.text=@"未保存";
    self.lblTip.layer.cornerRadius = 2;
    [self.lblTip setLs_width:32];
    [self.lblTip setLs_height:12];
    [self.lblTip setHidden:!flag];
    self.baseChangeStatus=flag;
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationType object:self] ;
}

- (BOOL)isChange
{
    if(self.frontChange || self.backChange){
        return YES;
    }
    return NO;
}

@end
