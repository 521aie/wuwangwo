//
//  EditItemView.m
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemView.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"

@implementation EditItemView
@synthesize view;

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemView" owner:self options:nil];
    [self addSubview:self.view];
}

+ (instancetype)editItemView {
    EditItemView *item = [[EditItemView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 48)];
    return item;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.view];
       
    }
    return self;
}

#pragma  initHit.
- (void)initHit:(NSString *)_hit{
    if ([NSString isNotBlank:_hit]) {
        self.lblDetail.text = _hit;
//        NSMutableParagraphStyle* linebreak = [[NSMutableParagraphStyle alloc]init];
//        linebreak.lineBreakMode = NSLineBreakByWordWrapping;
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_hit attributes:@{NSParagraphStyleAttributeName:linebreak}];
//        self.lblDetail.attributedText = attrStr;
    } else {
        self.lblDetail.text = _hit;
    }
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if([NSString isBlank:_hit]){
        [self.lblDetail setLs_height:0];
        [self.line setLs_top:46];
    }else{
        [self.lblDetail sizeToFit];
        [self.line setLs_top:(self.lblDetail.ls_top+self.lblDetail.ls_height+2)];
    }
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (void)initLabel:(NSString*)label withHit:(NSString *)_hit
{
    self.lblName.text=label;
    [self.lblVal setTextColor:[ColorHelper getTipColor3]];
    [self initHit:_hit];
}

- (float) getHeight
{
    return self.line.ls_top+self.line.ls_height+1;
}

#pragma initUI

- (void) initLabel:(NSString *)label withDataLabel:(NSString*)dataLabel withVal:(NSString*)data
{
    self.lblName.text = label;
    self.oldVal=([NSString isBlank:data]) ? @"" :data;;
    [self initData:dataLabel withVal:data];
}

- (void) initData:(NSString*)dataLabel withVal:(NSString*)data
{
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    self.lblVal.text=dataLabel;
}

#pragma 得到返回值.
-(NSString*)getStrVal{
    return self.currentVal;
}
@end
