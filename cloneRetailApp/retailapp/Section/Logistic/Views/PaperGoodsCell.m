//
//  PaperGoodsCell.m
//  retailapp
//
//  Created by hm on 15/7/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PaperGoodsCell.h"
#import "ColorHelper.h"
#import "PaperDetailVo.h"
#import "StockAdjustDetailVo.h"
#import "NumberUtil.h"
#import "AlertBox.h"
@interface PaperGoodsCell()
@end

@implementation PaperGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    _stepper = [[XBStepper alloc] initWithFrame:CGRectMake(SCREEN_W - 10 - 145, 10, 145, 35) color:[ColorHelper getTipColor6]];
    _stepper.backgroundColor = [UIColor clearColor];
    _stepper.myBlock = nil;
    [self addSubview:_stepper];
    
}

- (void)initDelegate:(id<PaperCellGoodsDelagate>)delagate count:(double)oldCount price:(double)oldPrice
{
    self.delegate = delagate;
    self.oldCount = oldCount;
    self.oldPrice = oldPrice;
    _changeFlag = 0;
}

- (void)initDelegate:(id<PaperCellGoodsDelagate>)delagate count:(double)oldCount adjustCount:(double)oldAdjustCount
{
    //库存调整使用
    self.delegate = delagate;
    self.oldCount = oldCount;
    self.oldAdjustCount = oldAdjustCount;
    _changeFlag = 0;
}

//物流商品显示
- (void)loadItem:(PaperDetailVo *)item mode:(PaperGoodsCellType)mode isEdit:(BOOL)isEdit status:(int)status
{
    [self showItem:item mode:mode isEdit:isEdit status:status];
    if (isEdit)
    {
        __weak typeof(self) weakSelf = self;
        [_stepper startMode:mode isEdit:isEdit isFloat:(item.type == 4) isSymbol:NO
                  withBlock:^(double *nowValue ,double dValue ,BOOL isReplace) {
                      
                      if (mode == PaperGoodsCellTypeCount) {//数量
                          
                          if (isReplace) {
                              *nowValue = dValue;
                              weakSelf.goodsVo.goodsSum = dValue;
                          }
                          else
                          {
                              // 要考虑数量为整数和小数的情况，防止数量负数的出现
                              if (weakSelf.goodsVo.goodsSum + dValue <= 0)
                              {
                                  if ([weakSelf.delegate respondsToSelector:@selector(delObject:)]) {
                                      
                                      [weakSelf.delegate delObject:weakSelf.goodsVo];
                                  }
                              }
                              else
                              {
                                  //物流商品数量最大只能输入4位小数3位
                                  if (weakSelf.goodsVo.goodsSum + dValue < 10000) {
                                      weakSelf.goodsVo.goodsSum = *nowValue + dValue;
                                      *nowValue += dValue;
                                  }
                              }
                          }
                          //输入数量总金额改变
                          weakSelf.goodsVo.goodsTotalPrice = weakSelf.goodsVo.goodsSum * weakSelf.goodsVo.goodsPrice;
                      } else if(mode == PaperGoodsCellTypePrice) {//价格
                          // 价格，isReplace 一直为YES
                          if (isReplace) {
                              _nowPrice = dValue;
                              *nowValue = dValue;
                              weakSelf.goodsVo.goodsPrice = dValue;
                          }
                          //输入价格总金额改变
                          weakSelf.goodsVo.goodsTotalPrice = weakSelf.goodsVo.goodsSum * weakSelf.goodsVo.goodsPrice;

                      } else if(mode == PaperGoodsCellTypeAmount) {//金额
                          // 价格，isReplace 一直为YES
                          if (isReplace) {
                              _nowPrice = dValue;
                              *nowValue = dValue;
                              weakSelf.goodsVo.goodsTotalPrice = dValue;
                          }
                          
                          //输入总金额价格改变不四舍五入
                          weakSelf.goodsVo.goodsPrice = (int)((weakSelf.goodsVo.goodsTotalPrice/weakSelf.goodsVo.goodsSum) * 100)/100.0;
                      }
                      [[NSNotificationCenter defaultCenter] postNotificationName:XBStepperNotificationKey object:nil];
                      [weakSelf showItem:item mode:mode isEdit:isEdit status:status];
                      [weakSelf changeValue];
                  }];
        [_stepper setMaxValue:999999.999 min:0 mode:mode count:item.goodsSum price:item.goodsPrice amount:item.goodsTotalPrice];
        [self changeValue];
    }
}

- (void)showItem:(PaperDetailVo *)item mode:(PaperGoodsCellType)mode isEdit:(BOOL)isEdit status:(int)status{
    _stepper.paperType = self.type;
    //查看成本价权限
    BOOL isSearchPrice =  ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_SEARCH];
    
    _mode = mode;
    self.goodsVo = item;
    self.lblAdjustCount.hidden = YES;
    self.lblCount.hidden = isEdit;
    
    if (self.type == ORDER_PAPER_TYPE || self.type == CLIENT_ORDER_PAPER_TYPE) {//采购单客户采购单
        //实库存数
#pragma mark - 采购单 客户采购单
        if (self.type == ORDER_PAPER_TYPE) {//采购单
            if ([[Platform Instance] getShopMode] == 3) {
                self.lblCount.hidden = YES;
                self.lblAdjustCount.hidden = isEdit;
//                self.lblAdjustCount.hidden = YES;
            } else {
                self.lblAdjustCount.hidden = isEdit;
                self.lblCount.hidden = NO;
            }
        } else if (self.type == CLIENT_ORDER_PAPER_TYPE) {//客户采购单
            self.lblCount.hidden = NO;
            self.lblAdjustCount.hidden = YES;
        }
        
        self.lblName.text = self.goodsVo.goodsName;
        self.lblCode.text = [NSString stringWithFormat:@"%@",self.goodsVo.goodsBarcode];
        if (mode == PaperGoodsCellTypeCount) {//数量
            if (isSearchPrice) {
                self.lblPrice.text = [NSString stringWithFormat:@"采购价：￥%.2f", self.goodsVo.goodsPrice];
            } else {
                self.lblPrice.text = [NSString stringWithFormat:@"零售价：￥%.2f", self.goodsVo.retailPrice];
            }
            double nowStore = [ObjectUtil isNull:item.nowStore] ? 0 : [item.nowStore doubleValue];
            self.lblCount.text = (item.type == 4) ? [NSString stringWithFormat:@"实库存数：%.3f",nowStore]:
            [NSString stringWithFormat:@"实库存数：%.f",nowStore];
            
            self.lblAdjustCount.text = (item.type == 4) ? [NSString stringWithFormat:@"x%.3f",item.goodsSum]:
            [NSString stringWithFormat:@"x%.0f",item.goodsSum];
            [self layoutIfNeeded];
            self.lblAdjustCount.ls_centerY = self.lblName.ls_centerY;
            
        } else if (mode == PaperGoodsCellTypePrice) {//价格
            
            self.lblPrice.text = (self.goodsVo.type==4)?[NSString stringWithFormat:@"采购数量：%.3f",self.goodsVo.goodsSum]:[NSString stringWithFormat:@"采购数量：%.0f",self.goodsVo.goodsSum];
            double nowStore = [ObjectUtil isNull:item.nowStore] ? 0 : [item.nowStore doubleValue];
            self.lblCount.text = (item.type == 4) ? [NSString stringWithFormat:@"实库存数：%.3f",nowStore]:
            [NSString stringWithFormat:@"实库存数：%.f",nowStore];
            
        } else if (mode == PaperGoodsCellTypeAmount) {//金额
            self.lblPrice.text = (self.goodsVo.type==4)?[NSString stringWithFormat:@"采购数量：%.3f",self.goodsVo.goodsSum]:[NSString stringWithFormat:@"采购数量：%.0f",self.goodsVo.goodsSum];
            //只有成本价修改的权限时才可以输入金额 这里不需要判断
            self.lblCount.text = [NSString stringWithFormat:@"采购价：￥%.2f", self.goodsVo.goodsPrice];
            
            
        }
    } else if (self.type == PURCHASE_PAPER_TYPE) {
#pragma mark - 收货入库单
        self.lblName.text = self.goodsVo.goodsName;
        self.lblCode.text = [NSString stringWithFormat:@"%@",self.goodsVo.goodsBarcode];
        
        //收货入库单添加收货商品时，当展示内容为“数量”时，显示如图
        //单据“未提交”状态下，显示商品当前的实际库存数 单据提交后不可编辑状态，不显示实库存数
        //收货入库单 未提交和配送中的 显示实库存数
        if (status == 4 || status == 1) {
            self.lblCount.hidden = NO;
        } else {
            self.lblCount.hidden = YES;
        }
        
        if (mode == PaperGoodsCellTypeCount) {//数量
            // 收货入库单  未提交单据“未提交”状态下，显示商品当前的实际库存数 单据提交后不可编辑状态，不显示实库存数
            if (isSearchPrice) {
                self.lblPrice.text = [NSString stringWithFormat:@"进货价：￥%.2f", self.goodsVo.goodsPrice];
            } else {
                self.lblPrice.text = [NSString stringWithFormat:@"零售价：￥%.2f", self.goodsVo.retailPrice];
            }
            
            double nowStore = [ObjectUtil isNull:item.nowStore] ? 0 : [item.nowStore doubleValue];
            self.lblCount.text = (item.type == 4) ? [NSString stringWithFormat:@"实库存数：%.3f",nowStore]:
            [NSString stringWithFormat:@"实库存数：%.f",nowStore];
            if ([[Platform Instance] getShopMode] == 3) {
                self.lblCount.hidden = YES;
//                self.lblAdjustCount.hidden = YES;
            } else {
                self.lblAdjustCount.hidden = isEdit;
            }
            self.lblAdjustCount.hidden = isEdit;
            
            self.lblAdjustCount.text = (item.type == 4) ? [NSString stringWithFormat:@"x%.3f",item.goodsSum]:
            [NSString stringWithFormat:@"x%.0f",item.goodsSum];
            [self layoutIfNeeded];
            self.lblAdjustCount.ls_centerY = self.lblName.ls_centerY;
            
        } else if (mode == PaperGoodsCellTypePrice) {//价格
            self.lblPrice.text = (self.goodsVo.type==4)?[NSString stringWithFormat:@"入库数量：%.3f",self.goodsVo.goodsSum]:[NSString stringWithFormat:@"入库数量：%.0f",self.goodsVo.goodsSum];
            
            if (status == 1) {//配送中
                [self layoutIfNeeded];
                self.lblAdjustCount.ls_centerY = self.lblName.ls_centerY;
                self.lblAdjustCount.hidden = NO;
                BOOL isSearchPrice = ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_SEARCH];
                if (isSearchPrice) {
                    self.lblAdjustCount.text = [NSString stringWithFormat:@"进货价：￥%.2f", item.goodsPrice];
                } else {
                    self.lblAdjustCount.text = [NSString stringWithFormat:@"零售价：￥%.2f", item.retailPrice];
                }
            }
            double nowStore = [ObjectUtil isNull:item.nowStore] ? 0 : [item.nowStore doubleValue];
            self.lblCount.text = (item.type == 4) ? [NSString stringWithFormat:@"实库存数：%.3f",nowStore]:
            [NSString stringWithFormat:@"实库存数：%.f",nowStore];
            if ([[Platform Instance] getShopMode] == 3) {
                self.lblCount.hidden = YES;
            } else {
                self.lblAdjustCount.hidden = isEdit;
            }
            
            
            
        } else if (mode == PaperGoodsCellTypeAmount) {//金额
            
            self.lblPrice.text = (self.goodsVo.type==4)?[NSString stringWithFormat:@"入库数量：%.3f",self.goodsVo.goodsSum]:[NSString stringWithFormat:@"入库数量：%.0f",self.goodsVo.goodsSum];
            
            if (status == 1) {//配送中
                [self layoutIfNeeded];
                self.lblAdjustCount.ls_centerY = self.lblName.ls_centerY;
                self.lblAdjustCount.hidden = NO;
                BOOL isSearchPrice = ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_SEARCH];
                if (isSearchPrice) {
                    self.lblAdjustCount.text = [NSString stringWithFormat:@"进货价：￥%.2f", item.goodsPrice];
                } else {
                    self.lblAdjustCount.text = [NSString stringWithFormat:@"零售价：￥%.2f", item.retailPrice];
                }
            }
            
            if (isSearchPrice) {
                self.lblCount.text = [NSString stringWithFormat:@"进货价：￥%.2f", self.goodsVo.goodsPrice];
            } else {
                self.lblCount.text = [NSString stringWithFormat:@"零售价：￥%.2f", self.goodsVo.retailPrice];
            }
            if ([[Platform Instance] getShopMode] == 3) {
                self.lblCount.hidden = YES;
            } else {
                self.lblAdjustCount.hidden = isEdit;
            }
            
        }
        
    } else if (self.type == RETURN_PAPER_TYPE || self.type == CLIENT_RETURN_PAPER_TYPE) {
#pragma mark - 退货单 客户退货单
        self.lblName.text = self.goodsVo.goodsName;
        self.lblCode.text = [NSString stringWithFormat:@"%@",self.goodsVo.goodsBarcode];
        self.lblCount.hidden = YES;
        self.lblAdjustCount.hidden = YES;
        if (mode == PaperGoodsCellTypeCount) {//数量
            if (isEdit) {
                self.lblPrice.text = isSearchPrice ?[NSString stringWithFormat:@"退货价：￥%.2f", self.goodsVo.goodsPrice]:[NSString stringWithFormat:@"零售价：￥%.2f", self.goodsVo.retailPrice];
            }else{
                self.lblPrice.text = [NSString stringWithFormat:@"退货原因：%@",self.goodsVo.resonName];
            }
            
            self.lblAdjustCount.text = (item.type == 4) ? [NSString stringWithFormat:@"x%.3f",item.goodsSum]:
            [NSString stringWithFormat:@"x%.0f",item.goodsSum];
            [self layoutIfNeeded];
            self.lblAdjustCount.ls_centerY = self.lblName.ls_centerY;
            self.lblAdjustCount.hidden = isEdit;
            
            
        } else if (mode == PaperGoodsCellTypePrice) {//价格
            if (isEdit) {
                self.lblPrice.text = (self.goodsVo.type==4)?[NSString stringWithFormat:@"退货数量：%.3f",self.goodsVo.goodsSum]:[NSString stringWithFormat:@"退货数量：%.0f",self.goodsVo.goodsSum];
            } else {
                self.lblPrice.text = [NSString stringWithFormat:@"退货原因：%@",self.goodsVo.resonName];
            }
            self.lblCount.text = [NSString stringWithFormat:@"%.2f",item.goodsPrice];
            self.lblCount.hidden = YES;
            
            
            
        } else if (mode == PaperGoodsCellTypeAmount) {//金额
            if (isEdit) {
                self.lblPrice.text = (self.goodsVo.type==4)?[NSString stringWithFormat:@"退货数量：%.3f",self.goodsVo.goodsSum]:[NSString stringWithFormat:@"退货数量：%.0f",self.goodsVo.goodsSum];
            } else {
                self.lblPrice.text = [NSString stringWithFormat:@"退货原因：%@",self.goodsVo.resonName];
            }
            self.lblCount.hidden = NO;
            self.lblCount.text = isSearchPrice ?[NSString stringWithFormat:@"退货价：￥%.2f", self.goodsVo.goodsPrice]:[NSString stringWithFormat:@"零售价：￥%.2f", self.goodsVo.retailPrice];
            
        }
        
        
    } else {
#pragma mark - 其他单据
        if (mode == PaperGoodsCellTypeCount) {//数量
            self.lblCount.text = (item.type == 4) ? [NSString stringWithFormat:@"x%.3f",item.goodsSum]:
            [NSString stringWithFormat:@"x%.0f",item.goodsSum];
            [self layoutIfNeeded];
            self.lblCount.ls_centerY = self.lblName.ls_centerY;
            
            
        } else if (mode == PaperGoodsCellTypePrice) {//价格
            self.lblCount.text = [NSString stringWithFormat:@"%.2f",item.goodsPrice];
            
            
        }
        
        
    }
    
    _stepper.hidden = !isEdit;
    

}




//库存调整商品显示
- (void)loadStockItem:(StockAdjustDetailVo *)item mode:(PaperGoodsCellType)mode isEdit:(BOOL)isEdit
{
    _mode = mode;
    self.adjustDetailVo = item;
    //    self.lblCount.hidden = isEdit;
    self.lblAdjustCount.hidden = isEdit;
    _stepper.hidden = !isEdit;
    if (isEdit) {
        if (mode == PaperGoodsCellTypeCount) {//调整数量
            if (item.type == 4) {
                self.lblCount.text = [NSString stringWithFormat:@"调整后：%.3f", item.totalStore.doubleValue];
            } else {
                self.lblCount.text = [NSString stringWithFormat:@"调整后：%.f", item.totalStore.doubleValue];
            }
        } else {//调整后数量
            if (item.type == 4) {
                self.lblCount.text = [NSString stringWithFormat:@"调整数量：%.3f", item.adjustStore.doubleValue];
            } else {
                self.lblCount.text = [NSString stringWithFormat:@"调整数量：%.f", item.adjustStore.doubleValue];
            }
            
            
        }
        
    }
    if (isEdit) {
        
        
        if (mode == PaperGoodsCellTypeCount) {
            
            
            //调整数量, 是散装商品 数量可以是小数
            if (item.type == 4) {
                _stepper.isFloat = YES;
                [_stepper setMaxValue:999999.999 min:-999999.999 count:[item.adjustStore doubleValue] price:self.oldPrice];
            }
            else
            {
                _stepper.isFloat = NO;
                [_stepper setMaxValue:999999 min:-999999 count:[item.adjustStore doubleValue] price:self.oldPrice];
            }
            
        }
        else
        {
            //调整后库存数
            [_stepper setMaxValue:999999.999 min:-999999.999 count:[item.totalStore doubleValue] price:self.oldPrice];
        }
        
        __weak PaperGoodsCell *weakSelf = self;
        double valueMax = weakSelf.stepper.valueMax;
        double valueMin = weakSelf.stepper.valueMin;
        [_stepper startMode:PaperGoodsCellTypeCount isEdit:isEdit isFloat:(item.type == 4) isSymbol:YES
                  withBlock:^(double *nowValue ,double dValue ,BOOL isReplace) {
                      
                      if (isReplace) {
                          *nowValue = dValue;
                      }
                      else
                      {
                          *nowValue += dValue;
                      }
                      
                      
                      if (mode == PaperGoodsCellTypeAdjustAfterCount) {
                          
                          //调整后库存数
                          weakSelf.nowCount = *nowValue;
                          weakSelf.adjustDetailVo.totalStore = [NSNumber numberWithDouble:*nowValue];
                          weakSelf.adjustDetailVo.adjustStore = [NSNumber numberWithDouble:(*nowValue-[weakSelf.adjustDetailVo.nowStore doubleValue])];
                          
                      } else {
                          //调整库存数量
                          
                          // 下面的比较是防止最终的库存数大于或小于后台允许的最大或最小库存数
                          double totalStockNum = ([weakSelf.adjustDetailVo.nowStore doubleValue] + *nowValue);
                          if (totalStockNum > valueMax) {
                              
                              *nowValue = valueMax - [weakSelf.adjustDetailVo.nowStore doubleValue];
                              [AlertBox show:@"调整后库存数整数位不能超过6位、小数位不能超过3位，请重新输入!"];
                          }
                          else if (totalStockNum < valueMin)
                          {
                              *nowValue = valueMin - [weakSelf.adjustDetailVo.nowStore doubleValue];
                              [AlertBox show:@"调整后库存数整数位不能超过6位、小数位不能超过3位，请重新输入!"];
                          }
                          
                          NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                          numberFormatter.numberStyle =
                          
                          weakSelf.nowCount = *nowValue;
                          weakSelf.adjustDetailVo.adjustStore = [NSNumber numberWithDouble:*nowValue];
                          weakSelf.adjustDetailVo.totalStore = [NSNumber numberWithDouble:([weakSelf.adjustDetailVo.nowStore doubleValue] + *nowValue)];
                      }
                      
                      
                      if (mode == PaperGoodsCellTypeCount) {//调整数量
                          if (item.type == 4) {
                              self.lblCount.text = [NSString stringWithFormat:@"调整后：%.3f", item.totalStore.doubleValue];
                          } else {
                              self.lblCount.text = [NSString stringWithFormat:@"调整后：%.f", item.totalStore.doubleValue];
                          }
                      } else {//调整后数量
                          if (item.type == 4) {
                              self.lblCount.text = [NSString stringWithFormat:@"调整数量：%.3f", item.adjustStore.doubleValue];
                          } else {
                              self.lblCount.text = [NSString stringWithFormat:@"调整数量：%.f", item.adjustStore.doubleValue];
                          }
                          
                          
                      }
                      
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"XBStepperNotification" object:nil];
                      [weakSelf changeStockValue];
                      
                      
                  }];
        
        
        
        [self changeStockValue];
    }
    else
    {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"调整数量："];
        NSString* str = nil;
        if (item.type == 4) {
            str = [NSString stringWithFormat:@"%.3f",[item.adjustStore doubleValue]];
        } else {
            str = [NSString stringWithFormat:@"%d",[item.adjustStore intValue]];
        }
        NSMutableAttributedString *amoutAttr = [[NSMutableAttributedString alloc] initWithString:str];
        [amoutAttr addAttribute:NSForegroundColorAttributeName value:(([item.adjustStore doubleValue]>0)?[ColorHelper getRedColor]:[ColorHelper getGreenColor]) range:NSMakeRange(0,str.length)];
        [attrString appendAttributedString:amoutAttr];
        if (item.type == 4) {
            self.lblCount.text = [NSString stringWithFormat:@"调整后：%.3f",[item.totalStore doubleValue]];
        } else {
            self.lblCount.text = [NSString stringWithFormat:@"调整后：%d",[item.totalStore intValue]];
        }
        self.lblAdjustCount.attributedText = attrString;
        attrString = nil;
        amoutAttr = nil;
        str = nil;
    }
}

// 检验是否有更改，(有的话显示未保存提示)
- (void)changeValue
{
//    _changeFlag = [NumberUtil isNotEqualNum:self.oldCount num2:self.goodsVo.goodsSum]||[NumberUtil isNotEqualNum:self.oldPrice num2:self.goodsVo.goodsPrice]||(self.goodsVo.oldResonVal!=self.goodsVo.resonVal)||(self.goodsVo.oldDate!=self.goodsVo.productionDate)||[self.goodsVo.operateType isEqualToString:@"add"];
    _changeFlag = self.goodsVo.isChange;
    // 把cell的当前状态(未保存或不需要保存)，记录到cell对应的PaperDetailVo 中
    self.goodsVo.changeFlag = _changeFlag;
    if (_changeFlag && ![self.goodsVo.operateType isEqualToString:@"add"]) {
        self.goodsVo.operateType = (_changeFlag == 1) ? @"edit" : @"";
    }
    [self showTip:_changeFlag];
    if (_delegate&&[_delegate respondsToSelector:@selector(changeNavigateUI)]) {
        [_delegate changeNavigateUI];
    }
}

- (void)changeStockValue
{
    _changeFlag = [NumberUtil isNotEqualNum:[self.adjustDetailVo.oldAdjustStore doubleValue] num2:[self.adjustDetailVo.adjustStore doubleValue]]||[NumberUtil isNotEqualNum:[self.adjustDetailVo.oldTotalStore doubleValue] num2:[self.adjustDetailVo.totalStore doubleValue]]||[self.adjustDetailVo.operateType isEqualToString:@"add"];
    self.adjustDetailVo.changeFlag = _changeFlag;
    if (![self.adjustDetailVo.operateType isEqualToString:@"add"]) {
        self.adjustDetailVo.operateType = (_changeFlag==1||self.adjustDetailVo.reasonFlag==1)?@"edit":@"edit";
    }
    [self showTip:_changeFlag||self.adjustDetailVo.reasonFlag];
    if (_delegate&&[_delegate respondsToSelector:@selector(changeNavigateUI)]) {
        [_delegate changeNavigateUI];
    }
}

-(void)showTip:(BOOL)show
{
    _lblTip.hidden = !show;
    _lblTip.layer.backgroundColor=[UIColor redColor].CGColor;
    _lblTip.textColor=[UIColor whiteColor];
    _lblTip.text=@"未保存";
    _lblTip.layer.cornerRadius = 2;
}

@end
