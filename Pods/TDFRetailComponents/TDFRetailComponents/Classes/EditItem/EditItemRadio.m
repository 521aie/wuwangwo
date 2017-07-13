//
//  EditItemRatio.m
//  RestApp
//
//  Created by zxh on 14-4-2.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemRadio.h"
#import "SystemUtil.h"
#import "ColorHelper.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"

@implementation EditItemRadio
@synthesize view;

+ (EditItemRadio *)editItemRadio
{
   
    return [self itemRadio];
}
+ (EditItemRadio *)itemRadio
{
    EditItemRadio *item = [[EditItemRadio alloc] initWithFrame:
                           CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 48.0)];
    [item awakeFromNib];
//    item.btnRadioDynamic.hidden = YES;
//    item.btnRadioDynamic.enabled = NO;
//    [item.btnRadio addTarget:self action:@selector(btnRatioClick:) forControlEvents:UIControlEventTouchUpInside];
    return item;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemRadio" owner:self options:nil];
    [self addSubview:self.view];
    self.lblDetail.text = @"";

//    self.btnRadioDynamic.hidden =YES;
//    self.btnRadioDynamic.enabled = NO;
//    [self.btnRadio addTarget:self action:@selector(btnRatioClick:) forControlEvents:UIControlEventTouchUpInside];
}

//- (id)loadNibWithowner:(id)owner {

//    [[NSBundle mainBundle] loadNibNamed:@"EditItemRadio" owner:self options:nil];
//   
//    [self addSubview:self.view];
//    self.lblDetail.text=@"";
//    
//    self.btnRadio.hidden = YES;
//    self.btnRadio.enabled = NO;
//    self.btnRadioDynamic.hidden =YES;
//    self.btnRadioDynamic.enabled = NO;
//    [self.btnRadioDynamic addTarget:self action:@selector(btnRatioClick1:) forControlEvents:UIControlEventTouchUpInside];
    
//    return self;
//}

#pragma  initHit.
- (void)initHit:(NSString *)hit {
    
    self.lblDetail.text = hit;
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if([NSString isBlank:hit]) {
        [self.lblDetail setLs_height:0];
        [self.line setLs_top:46];
    }else {
        [self.lblDetail sizeToFit];
        [self.line setLs_top:(self.lblDetail.ls_top+self.lblDetail.ls_height+2)];
    }

    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit
         delegate:(id<IEditItemRadioEvent>)delegate {
   
    self.delegate=delegate;
    [self initLabel:label withHit:hit];
}

- (void)initCompanion:(NSString*)label withHit:(NSString *)hit
             delegate:(id<IEditItemRadioEvent>)delegate {
    
    self.delegate = delegate;
    self.lblName.text = label;
    
    self.lblDetail.font = [UIFont systemFontOfSize:11];
    self.lblDetail.frame = CGRectMake(5, 32, 300, 40);
    self.lblDetail.textContainerInset = UIEdgeInsetsZero;
    
    [self initHit:hit];
}

- (void)initIndent:(NSString *)label withHit:(NSString *)hit
          delegate:(id<IEditItemRadioEvent>)delegate {
    [self initIndent:label withHit:hit indent:YES delegate:delegate];
}

- (void)initIndent:(NSString*)label withHit:(NSString *)hit indent:(BOOL)indent
          delegate:(id<IEditItemRadioEvent>)delegate {
    self.delegate=delegate;
    self.imgIndent.hidden = !indent;
    self.lblName.text=label;

    if (indent) {
        [self.lblName setLs_left:30];
        [self.lblTip setLs_left:30];
        self.lblDetail.frame = CGRectMake(25, 32, 226, 40);
    } else {
        self.lblDetail.frame = CGRectMake(5, 32, 241, 40);
    }
    
    self.lblDetail.font = [UIFont systemFontOfSize:11];
    self.lblDetail.textContainerInset = UIEdgeInsetsZero;
    self.lblDetail.text=hit;
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if ([NSString isBlank:hit]) {
        [self.lblDetail setLs_height:0];
        [self.line setLs_top:46];
    } else {
        [self.lblDetail sizeToFit];
        [self.line setLs_top:(self.lblDetail.ls_top+self.lblDetail.ls_height+2)];
    }
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit {
    self.lblName.text = label;
    [self initHit:hit];
}

- (float)getHeight {
    return self.line.ls_top+self.line.ls_height+1;
}

- (void)initLabel:(NSString *)label withVal:(NSString *)data withHit:(NSString *)hit {
    [self initLabel:label withVal:data];
    [self initHit:hit];
}

#pragma initUI
- (void)initLabel:(NSString *)label withVal:(NSString *)data {
    self.oldVal = ([NSString isBlank:data]) ? @"" :data;
    [self changeLabel:label withVal:data];
}

- (void)initShortData:(short)shortVal {
    NSString* val = [NSString stringWithFormat:@"%d",shortVal];
    [self initData:val];
}

- (void)initData:(NSString *)data {
    self.oldVal = ([NSString isBlank:data]) ? @"" :data;
    [self changeData:data];
}

#pragma  ui is changing.
- (void)changeLabel:(NSString *)label withVal:(NSString *)data {
    self.lblName.text = ([NSString isBlank:label]) ? @"" :label;
    [self changeData:data];
}

- (void)changeData:(NSString *)data {
    self.currentVal = ([NSString isBlank:data]) ? @"" :data;
    BOOL result = [self.currentVal isEqualToString:@"1"];
    self.imgOff.hidden = result;
    self.imgOn.hidden = !result;
    [self changeStatus];
}

#pragma data
- (BOOL)getVal {
    return [self.currentVal isEqualToString:@"1"];
}

- (NSString *)getStrVal {
    return self.currentVal;
}

- (void)btnRatioClick1:(id)sender{
  
}

- (IBAction)btnRatioClick:(id)sender{
    [SystemUtil hideKeyboard];
    NSString* val = @"1";
    if ([self.currentVal isEqualToString:@"1"]) {
        val = @"0";
    }
    [self changeData:val];
    if (self.delegate) {
        [self.delegate onItemRadioClick:self];
    }
}

- (void)clickDeal {
}

#pragma change status
- (void)changeStatus {
//    BOOL flag=[super isChange];
    [super isChange];
}

- (void)clearChange {
    self.oldVal=self.currentVal;
    [self changeStatus];
}

- (void)isEditable:(BOOL)editable {
    self.btnRadio.hidden = !editable;
}

@end
