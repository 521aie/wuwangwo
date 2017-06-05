//
//  SRGoodsView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetailSellReturnVo.h"
#import "InstanceVo.h"

@interface SRGoodsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *lblBarCode;
@property (weak, nonatomic) IBOutlet UILabel *lblColor;
@property (weak, nonatomic) IBOutlet UILabel *lblFinalRatioFee;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountNum;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

/**
 折扣率
 */
@property (weak, nonatomic) IBOutlet UILabel *lblRatio;

/**
 折扣类型
 */
@property (weak, nonatomic) IBOutlet UILabel *lblType;

@property (nonatomic, strong) RetailInstanceVo *retailInstanceVo;

@property (nonatomic, strong) InstanceVo *instanceVo;

+ (SRGoodsView *)loadFromNib;
- (void)initData:(RetailInstanceVo *)retailInstanceVo;
- (void)initOrderData:(InstanceVo *)instanceVo orderType:(int)orderType;
- (void)initPointOrderData:(InstanceVo *)instanceVo;

@end
