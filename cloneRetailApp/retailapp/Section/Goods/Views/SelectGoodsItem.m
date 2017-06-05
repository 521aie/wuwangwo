//
//  SelectGoodsItem.m
//  retailapp
//
//  Created by guozhi on 16/2/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectGoodsItem.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "XBStepper.h"
#import "NumberUtil.h"
#import "GoodsOperationVo.h"
#import "LSGoodsHandleVo.h"

@implementation SelectGoodsItem


+ (instancetype)createItem {
    SelectGoodsItem *view = [[NSBundle mainBundle] loadNibNamed:@"SelectGoodsItem" owner:self options:nil].lastObject;
    view.frame = CGRectMake(0, 0, SCREEN_W, 88);
    return view;
}


- (void)initDelegate:(id<SelectGoodsItemDelegate>)delegate value:(int)value {
    self.delegate = delegate;
    [self showStepper:value];
}

- (void)setGoodsVo:(GoodsOperationVo *)goodsVo {
    _goodsVo = goodsVo;
    [self initWithTitle:_goodsVo.goodsName val:_goodsVo.barCode];
}

- (void)initWithTitle:(NSString *)title val:(NSString *)val {
    self.lblName.text = title;
    self.lblVal.text = val;
    self.lblName.textColor = [ColorHelper getTipColor3];
    self.lblVal.textColor = [ColorHelper getTipColor6];
}

- (void)visibal:(BOOL)show {
    [self setLs_height:show?88:0];
    self.hidden = !show;
    if (!show) {
        [self initWithTitle:nil val:nil];
    }
}

- (void)showStepper:(int)value {
    _stepper = [[XBStepper alloc] initWithFrame:CGRectMake(159, 45, 155, 35) color:[ColorHelper getTipColor6]];
    _stepper.ls_right = SCREEN_W - 10;
    _stepper.backgroundColor = [UIColor clearColor];
    _stepper.myBlock = nil;
    _stepper.lblCount.text = [NSString stringWithFormat:@"%d",value];
    _stepper.valueNow = value;
    [self addSubview:_stepper];
    __weak SelectGoodsItem *weakSelf = self;
    [_stepper startMode:PaperGoodsCellTypeCount isEdit:YES isFloat:NO isSymbol:NO
              withBlock:^(double *nowValue ,double dValue ,BOOL isReplace) {
                  
          if (isReplace)
          {
              *nowValue = dValue;
          }
          else
          {
              *nowValue += dValue;
          }
          [[NSNotificationCenter defaultCenter] postNotificationName:XBStepperNotificationKey object:nil];
          if ([weakSelf.delegate respondsToSelector:@selector(showDelEvent:value:)])
          {
              [weakSelf.delegate showDelEvent:weakSelf value:*nowValue];
          }
    }];
}


@end
