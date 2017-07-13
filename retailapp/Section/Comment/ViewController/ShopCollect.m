//
//  ShopCollect.m
//  retailapp
//
//  Created by 小龙虾 on 2017/4/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopCollect.h"

@interface ShopCollect ()
@property(nonatomic, assign)int type;
@property(nonatomic, strong)UIButton *btnClick;
@property(nonatomic, strong)UIImageView *collect;
@property(nonatomic, strong)UILabel *title;
@end
@implementation ShopCollect

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = 0;
        [self createViews];
        
    }
    return self;
}

-(void)createViews
{
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(99, 4, 120, 22)];
    [self.title setText:@"展开上月及历史汇总"];
    [self.title setFont:[UIFont systemFontOfSize:12.0]];
    [self.title setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.title];
    
    self.collect = [[UIImageView alloc] initWithFrame:CGRectMake(220, 8, 12, 15)];
    [self.collect setImage:[UIImage imageNamed:@"ico_expend_down.png"]];
    [self addSubview:self.collect];
    
    self.btnClick = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.btnClick addTarget:self action:@selector(upDataWithType) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnClick];
}


-(void)upDataWithType
{
    self.type = !self.type;
    if (self.type) {
        [self.title setText:@"收起上月及历史汇总"];
        self.collect.transform = CGAffineTransformMakeScale(1, -1);
    }else{
        [self.title setText:@"展开上月及历史汇总"];
        self.collect.transform = CGAffineTransformMakeScale(-1, 1);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTotal" object:[NSNumber numberWithInt:self.type]];
}

@end
