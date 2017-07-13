//
//  ChartItem.m
//  testReg
//
//  Created by zxh on 14-8-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ChartItem.h"

@implementation ChartItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20,self.bounds.size.width,20)];
        self.view = [[UIView alloc] initWithFrame:CGRectMake(3, 13, 3, self.bounds.size.height-33)];
        [self addSubview:self.lbl];
        [self addSubview:self.view];
    }
    return self;
}

@end
