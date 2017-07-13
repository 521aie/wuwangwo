//
//  ChartItem.h
//  testReg
//
//  Created by zxh on 14-8-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartItem : UIView

@property (nonatomic, strong) UILabel* lbl;
@property (nonatomic, strong) UIView* view;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger week;

@end
