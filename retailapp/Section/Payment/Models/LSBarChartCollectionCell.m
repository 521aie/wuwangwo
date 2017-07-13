//
//  LSBarChartCollectionCell.m
//  retailapp
//
//  Created by guozhi on 16/8/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSBarChartCollectionCell.h"
#import "LSBarChartVo.h"
#import "UIView+Sizes.h"
@interface LSBarChartCollectionCell()

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UIView *redView;

@end
@implementation LSBarChartCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.redView  = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/4,0 , frame.size.width/2, 0)];
        [self addSubview:self.redView];
        
        self.whiteView  = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/4,0 , frame.size.width/2, 0)];
        [self addSubview:self.whiteView];
        
        self.markView  = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/4,self.bounds.size.height-15,frame.size.width/2, frame.size.width/2)];
        self.markView.layer.cornerRadius = 5;
        self.markView.layer.masksToBounds = 5 ;
        [self addSubview:self.markView];
        
    }
    return self;
}

- (void)setBarChartVo:(LSBarChartVo *)barChartVo {
    _barChartVo = barChartVo;
    self.markView.backgroundColor = _barChartVo.isSelected?[UIColor redColor]:[UIColor colorWithWhite:1 alpha:0.3];
    [self.whiteView setLs_height:(self.bounds.size.height *0.9 - 10)*(_barChartVo.value-_barChartVo.value2)/_barChartVo.maxValue];
    [self.whiteView setLs_bottom:self.bounds.size.height *0.9 - 5];
    self.whiteView.backgroundColor =  _barChartVo.isSelected?[UIColor whiteColor]:[UIColor colorWithWhite:1 alpha:0.3];
    [self.redView setLs_height:  (self.bounds.size.height *0.9 - 10)*_barChartVo.value2/_barChartVo.maxValue];
    [self.redView setLs_bottom:self.bounds.size.height *0.9 - 5 - self.whiteView.ls_height];
    self.redView.backgroundColor =  [UIColor redColor];
    self.redView.alpha = _barChartVo.isSelected ? 1.0f:0.3f;
}

@end
