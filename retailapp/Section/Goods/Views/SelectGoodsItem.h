//
//  SelectGoodsItem.h
//  retailapp
//
//  Created by guozhi on 16/2/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBStepper.h"
@class SelectGoodsItem,GoodsOperationVo,LSOldGoodsVo;
@protocol SelectGoodsItemDelegate <NSObject>
- (void)showDelEvent:(SelectGoodsItem *)item value:(double)value;
@end


@interface SelectGoodsItem : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblVal;
@property (nonatomic, strong) XBStepper *stepper;
@property (nonatomic, assign) id<SelectGoodsItemDelegate>delegate;
@property (nonatomic, strong) GoodsOperationVo *goodsVo;
+ (instancetype)createItem;
- (void)initDelegate:(id<SelectGoodsItemDelegate>)delegate value:(int)value;
- (void)visibal:(BOOL)show;
- (void)initWithTitle:(NSString *)title val:(NSString *)val;
@end
