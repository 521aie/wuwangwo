//
//  EditItemMemo.m
//  RestApp
//
//  Created by zxh on 14-4-18.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemMemo.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "KeyBoardUtil.h"
#import "ColorHelper.h"
#import "NSString+Estimate.h"
#import "IEditItemMemoEvent.h"

@implementation EditItemMemo

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemMemo" owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
    self.isEdit = YES;
    self.currentVal = @"";
    self.oldVal = @"";
}

+ (instancetype)editItemMemo {
    EditItemMemo *editItemMemo = [[EditItemMemo alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48)];
    return editItemMemo;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

#pragma  initVal.
- (void)initVal:(NSString *)val
{
     self.lblVal.text = val;
     self.lblVal.textColor = self.isEdit?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
    self.lblVal.font = [UIFont systemFontOfSize:15];
    if([NSString isBlank:val]){
        [self.lblVal setLs_height:0];
        [self.line setLs_top:46];
    }else{
        [self.lblVal sizeToFit];
        [self.line setLs_top:(self.lblVal.ls_top+self.lblVal.ls_height+2)];
    }
    [self.btn setLs_height:[self getHeight]];
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (void)initLabel:(NSString*)label isrequest:(BOOL)req  delegate:(id<IEditItemMemoEvent>) delegate
{
    self.delegate=delegate;
    self.lblName.text=label;
    self.isReq=req;
    self.lblHit.text=req?@"必填":@"可不填";
    self.lblHit.textColor=req?[UIColor redColor]:[UIColor grayColor];
    [self.lblVal setTextColor:[ColorHelper getBlueColor]];
    [self initVal:nil];
}

- (float) getHeight
{
    return self.line.ls_top+self.line.ls_height+1;
}

- (void)initLocation:(NSString *)image action:(SEL)selector delegate:(id)delegate {
    if ([NSString isNotBlank:image]) {
        [self.btnLocation setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    self.btnLocation.hidden = NO;
    self.lblHit.ls_right = 280;
    [self.btnLocation addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)onFocusClick:(id)sender
{
    [self.delegate onItemMemoListClick:self];
}

#pragma initUI
- (void) initLabel:(NSString *)label withVal:(NSString*)data
{
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    [self changeLabel:label withVal:data];
}

- (void) initData:(NSString*)data
{
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    [self changeData:data];
}

#pragma  ui is changing.
- (void) changeLabel:(NSString*)label withVal:(NSString*)data
{
    self.lblName.text=([NSString isBlank:label]) ? @"" :label;
    [self changeData:data];
}

- (void) changeData:(NSString*)data
{
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    [self.lblVal setLs_width:300];
    self.lblVal.text=@"";
    self.lblVal.text = self.currentVal;
    self.lblHit.text=[NSString isBlank:data]?(self.isReq?@"必填":@"可不填"):@"";
    
    [self initVal:data];
    [self changeStatus];
}

-(NSString*) getStrVal{
    return [NSString isBlank:self.currentVal]?@"":self.currentVal;
}

-(void) changeStatus
{
//    BOOL flag=[super isChange];
    [super isChange];
}

-(void) clearChange{
    self.oldVal=self.currentVal;
    [self changeStatus];
}

- (void)editEnable:(BOOL)enable
{
    self.isEdit = enable;
    self.lblVal.textColor = enable?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
    self.lblVal.editable = enable;
//    [self.btn setEnabled:NO];
    [self.btn setEnabled:enable];
    [self.btnLocation setEnabled:enable];
}

@end
