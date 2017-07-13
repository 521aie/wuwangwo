//
//  XBStepper.h
//  retailapp
//
//  Created by hm on 15/7/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReailAppDefine.h"
#import "PaperGooodsCellEnum.h"

/**
 *  回调block @1: 传递nowValue 和增量dValue, 此时isReplace == NO @2: 替换原值， 此时isReplace == YES
 *
 *  @param nowValue  当前显示的值
 *  @param dValue    增量值
 *  @param isReplace 是否替换现在的显示值
 */
typedef void (^XBStepperCallback)(double *nowValue, double dValue, BOOL isReplace);
@protocol XBStepperDelegate;
@class PaperGoodsCell,LSMemberMeterDetailCell;
@interface XBStepper : UIControl

@property (nonatomic ,copy) UIColor *myColor;
@property (nonatomic ,assign) double valueMax;
@property (nonatomic ,assign) double valueMin;
@property (nonatomic ,assign) double valueNow;
@property (nonatomic ,strong) UIView *vLineFront;
@property (nonatomic ,strong) UIView *vLineBack;
@property (nonatomic ,strong) UILabel *lblCount;

@property (nonatomic ,strong) UILabel *lblPrice;
@property (nonatomic ,strong) UIImageView *nextPic;
/**编辑按钮*/
@property (nonatomic ,strong) UIButton *btnEdit;
/**-按钮*/
@property (nonatomic ,strong) UIButton *btnDecrease;
/**+按钮*/
@property (nonatomic ,strong) UIButton *btnIncrease;
/** <#注释#> */
@property (nonatomic, assign) NSInteger paperType;
/** 是否是库存调整 库存调整可以输入6位 */
@property (nonatomic, assign) BOOL isStockAdjust;
@property(nonatomic ,copy) XBStepperCallback myBlock;
@property (nonatomic ,assign)  PaperGoodsCellType mode;
@property (nonatomic, weak) id<XBStepperDelegate> stepperDelegate;
@property (nonatomic) BOOL isFloat;


/**
 *  初始化
 *
 *  @param frame frame
 *  @param color :设置边框及按钮字体颜色
 */
- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;;

/**
 *  设置值
 *
 *  @param max 最大值，默认100
 *  @param min 最小值，默认0
 *  @param now 当前值，默认0
 */
- (void)setMaxValue:(double)max min:(double)min count:(double)count price:(double)price;

//出入库
- (void)setMaxValue:(double)max min:(double)min mode:(PaperGoodsCellType)model count:(double)count price:(double)price amount:(double)amount;

/**
 *  设置block
 *
 *  @param block
 */
- (void)startMode:(PaperGoodsCellType)mode isEdit:(BOOL)isEdit isFloat:(BOOL)isFloat isSymbol:(BOOL)isSymbol withBlock:(XBStepperCallback)block;
@end

@protocol XBStepperDelegate <NSObject>
/**
 *  需要保留新值，NO放弃新值
 */
- (BOOL)needChangeValue:(PaperGoodsCell *)cell;
- (BOOL)needChangeMeterValue:(LSMemberMeterDetailCell *)cell;

@end
