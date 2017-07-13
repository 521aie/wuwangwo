//
//  TextStepperField.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITextStepperField.h"

@class GoodsGiftVo;
@protocol TextStepperFieldDelegate <NSObject>

- (void)showGoodsNum:(int)num item:(GoodsGiftVo*)vo;

@end


@interface TextStepperField : UIView

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIButton *plusButton;
@property (nonatomic, strong) IBOutlet UIButton *minusButton;
@property (nonatomic, strong) IBOutlet UILabel *lbVal;

@property (nonatomic, strong) GoodsGiftVo *vo;

@property (nonatomic) int point;
@property (nonatomic,assign) id<TextStepperFieldDelegate> delegate;

- (IBAction)didPressMinusButton:(id)sender;
- (IBAction)didPressPlusButton:(id)sender;


@end
