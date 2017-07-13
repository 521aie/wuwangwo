//
//  EditItemAddCorrelation.m
//  retailapp
//
//  Created by diwangxie on 16/4/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemCorrelation.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"

@implementation EditItemCorrelation

@synthesize view;

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemCorrelation" owner:self options:nil];
    [self addSubview:self.view];
    [self borderLine:self.CorrelationView];
    [self initHit:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"EditItemCorrelation" owner:self options:nil];
        [self addSubview:self.view];
        [self borderLine:self.CorrelationView];
    }
    return self;
}
#pragma  initHit.
- (void)initHit:(NSString *)_hit
{
    [self.view setLs_height:[self getHeight]];
    [self setLs_height:[self getHeight]];
}

- (float) getHeight
{
    return self.line.ls_top+self.line.ls_height+1;
}

-(void) borderLine:(UIView*)boderView
{
    CALayer *layer=[boderView layer];
    layer.cornerRadius=10;
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    UIColor* color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [layer setBorderColor:[color CGColor]];
}

-(void)initCorrelationSum:(NSInteger)sum{
    self.lblCorrelationSum.text=[NSString stringWithFormat:@"已关联%ld款商品",sum];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
