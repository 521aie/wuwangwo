//
//  PaperGoodsCell.h
//  retailapp
//
//  Created by hm on 15/7/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBStepper.h"
@class PaperDetailVo,StockAdjustDetailVo;


@protocol PaperCellGoodsDelagate <NSObject>

- (void)changeNavigateUI;
@optional
- (void)delObject:(PaperDetailVo*)item;
- (void)delStockObject:(StockAdjustDetailVo *)item;
- (void)showNoticeMessage:(NSString *)string;
@end



@interface PaperGoodsCell : UITableViewCell

@property (nonatomic ,weak) IBOutlet UILabel *lblTip;
@property (nonatomic ,weak) IBOutlet UILabel *lblName;
@property (nonatomic ,weak) IBOutlet UILabel *lblCode;
@property (nonatomic ,weak) IBOutlet UILabel *lblPrice;
@property (nonatomic ,weak) IBOutlet UILabel *lblCount;
@property (nonatomic ,weak) IBOutlet UILabel *lblAdjustCount;

@property (nonatomic ,strong) XBStepper *stepper;
@property (nonatomic ,strong) PaperDetailVo *goodsVo;
@property (nonatomic ,strong) StockAdjustDetailVo *adjustDetailVo;
@property (nonatomic ,assign) id<PaperCellGoodsDelagate> delegate;
@property (nonatomic ,assign) PaperGoodsCellType mode;
@property (nonatomic ,assign) NSInteger changeFlag;

@property (nonatomic,assign) double oldCount;
@property (nonatomic,assign) double nowCount;
@property (nonatomic,assign) double oldAdjustCount;
@property (nonatomic,assign) double oldPrice;
@property (nonatomic,assign) double nowPrice;
/** <#注释#> */
@property (nonatomic, assign) NSInteger type;

- (void)initDelegate:(id<PaperCellGoodsDelagate>)delagate count:(double)oldCount price:(double)oldPrice;
- (void)initDelegate:(id<PaperCellGoodsDelagate>)delagate count:(double)oldCount adjustCount:(double)oldAdjustCount;
- (void)loadItem:(PaperDetailVo *)item mode:(PaperGoodsCellType)mode isEdit:(BOOL)isEdit status:(int)status;
- (void)loadStockItem:(StockAdjustDetailVo *)item mode:(PaperGoodsCellType)mode isEdit:(BOOL)isEdit;
//- (void)showMark:(BOOL)show;
@end
