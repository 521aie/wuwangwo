//
//  EditItemAddCorrelation.m
//  retailapp
//
//  Created by diwangxie on 16/4/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemAddCorrelation.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"

@implementation EditItemAddCorrelation

@synthesize view;

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemAddCorrelation" owner:self options:nil];
    [self addSubview:self.view];
    [self initHit:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"EditItemAddCorrelation" owner:self options:nil];
        [self addSubview:self.view];
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

-(void)initView:(NSString *) title delegate:(id<EditItemAddCorrelationDelegate>)delegate{
    self.delegate=delegate;
    self.lblTitle.text=title;
}

- (IBAction)btnAddClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addClick:)]) {
        [self.delegate addClick:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
