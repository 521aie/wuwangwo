//
//  EditItemRatio2.m
//  RestApp
//
//  Created by zxh on 14-7-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemRadio2.h"
#import "SystemUtil.h"
#import "ColorHelper.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"

@implementation EditItemRadio2
@synthesize view;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemRadio2" owner:self options:nil];
    [self addSubview:self.view];
    self.view.ls_width = SCREEN_W;
    self.ls_width = SCREEN_W;
    self.lblDetail.text = @"";
}

+ (EditItemRadio2 *)editItemRadio{
    EditItemRadio2 *item = [[EditItemRadio2 alloc] initWithFrame:
                           CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 48.0)];
    [item awakeFromNib];
    return item;    
}

#pragma  initHit.
- (void)initHit:(NSString *)hit
{
    self.lblDetail.text = hit;
    __weak typeof(self) wself = self;
    if ([NSString isBlank:hit]) {//如果没有详情
        self.lblDetail.hidden = YES;
        [self.line remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(wself.top).offset(48);
            make.left.equalTo(wself.left).offset(10);
            make.right.equalTo(wself.right).offset(-10);
            make.height.equalTo(1);
        }];
    } else {//如果有详情
        self.lblDetail.hidden = NO;
        [self.line remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wself.lblDetail.bottom).offset(10);
            make.left.equalTo(wself.left).offset(10);
            make.right.equalTo(wself.right).offset(-10);
            make.height.equalTo(1);
        }];
    }
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (void)initLabel:(NSString*)label withHit:(NSString *)_hit delegate:(id<IEditItemRadioEvent>)delegate
{
    self.delegate = delegate;
    [self initLabel:label withHit:_hit];
}

- (void)initLabel:(NSString*)label withHit:(NSString *)_hit
{
    self.lblName.text = label;
    [self initHit:_hit];
}

- (float)getHeight{
    [self layoutIfNeeded];
    return self.line.ls_top+self.line.ls_height+1;
}

#pragma initUI
- (void)initLabel:(NSString *)label withVal:(NSString*)data
{
    self.oldVal = ([NSString isBlank:data]) ? @"" :data;
    [self changeLabel:label withVal:data];
}

- (void)initShortData:(short)shortVal
{
    NSString* val = [NSString stringWithFormat:@"%d",shortVal];
    [self initData:val];
}

- (void)initData:(NSString*)data
{
    self.oldVal = ([NSString isBlank:data]) ? @"" :data;
    [self changeData:data];
}

#pragma  ui is changing.
- (void)changeLabel:(NSString*)label withVal:(NSString*)data
{
    self.lblName.text = ([NSString isBlank:label]) ? @"" :label;
    [self changeData:data];
}

- (void)changeData:(NSString*)data
{
    self.currentVal = ([NSString isBlank:data]) ? @"" :data;
    BOOL result = [self.currentVal isEqualToString:@"1"];
    [self.lblName setTextColor:result?[ColorHelper getBlueColor]:[ColorHelper getRedColor]];
    self.imgOff.hidden = result;
    self.imgOn.hidden = !result;
    [self changeStatus];
    
}


#pragma data
- (BOOL)getVal
{
    return [self.currentVal isEqualToString:@"1"];
}

- (NSString*)getStrVal
{
    return self.currentVal;
}

- (IBAction)btnRatioClick:(id)sender
{
    [SystemUtil hideKeyboard];
    NSString* val = @"1";
    if ([self.currentVal isEqualToString:@"1"]) {
        val = @"2";
    }
    [self changeData:val];
    if (self.delegate) {
        [self.delegate onItemRadioClick:self];
    }
}


- (void)clickDeal
{
}

#pragma change status
-(void) changeStatus
{
//    BOOL flag=[super isChange];
    [super isChange];
    //    [self.lblName setTextColor:(flag?[UIColor redColor]:[UIColor blackColor])];
}


-(void) clearChange{
    self.oldVal=self.currentVal;
    [self changeStatus];
}


@end
