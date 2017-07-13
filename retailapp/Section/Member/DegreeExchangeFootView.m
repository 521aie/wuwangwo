//
//  DegreeExchangeFootView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DegreeExchangeFootView.h"
#import "UIHelper.h"

@implementation DegreeExchangeFootView

//- (void)awakeFromNib {
//    
//    [[NSBundle mainBundle] loadNibNamed:@"DegreeExchangeFootView" owner:self options:nil];
////    [self addSubview:self.view];
//    
//}

-(IBAction)btnExcClick:(id)sender
{
    [self.delegate ExchangeButton]; 
}

//+ (DegreeExchangeFootView*)loadFromNib
//{
//    [[NSBundle mainBundle] loadNibNamed:@"DegreeExchangeFootView" owner:self options:nil];
//
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
