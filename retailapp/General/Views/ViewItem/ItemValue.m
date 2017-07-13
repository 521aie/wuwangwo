//
//  ItemValue.m
//  retailapp
//
//  Created by Jianyong Duan on 15/9/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemValue.h"

@implementation ItemValue

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ItemValue" owner:self options:nil];
    
    [self addSubview:self.view];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.valueLable.textColor = [ColorHelper getTipColor6];
}

- (void)initLabel:(NSString *)name withValue:(NSString *)value {
    self.titleLabel.text = name;
    self.valueLable.text = value;
}

- (float) getHeight{
    return 48;
}

@end
