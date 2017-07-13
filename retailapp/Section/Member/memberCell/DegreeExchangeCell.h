//
//  DegreeExchangeCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextStepperField, GoodsGiftVo;

@protocol DegreeExchangeCellDelegate <NSObject>

- (void)initGoodsNum:(int)num item:(GoodsGiftVo*)vo;

@end

@interface DegreeExchangeCell : UITableViewCell

// 商品名称
@property (nonatomic, strong) IBOutlet UILabel *lblGoodsName;

// 编码
@property (nonatomic, strong) IBOutlet UILabel *lblCode;

// 属性
@property (nonatomic, strong) IBOutlet UILabel *lblAttribute;

// 所需积分
@property (nonatomic, strong) IBOutlet UILabel *lblNeedPoint;

// 选中图片
@property (strong, nonatomic) IBOutlet UIImageView *checkImg;

// 未选中图片
@property (strong, nonatomic) IBOutlet UIImageView *uncheckImg;

// 选择按钮
@property (nonatomic, strong) IBOutlet UIButton *displayButton;

// 商品个数选择
@property (nonatomic, strong) IBOutlet TextStepperField *textStepperField;

@property (nonatomic, strong) GoodsGiftVo *vo;

@property (nonatomic,assign) id<DegreeExchangeCellDelegate> delegate;

- (IBAction)didDisplayButton:(id)sender;

-(void) setPointLocation:(int) type;

@end
