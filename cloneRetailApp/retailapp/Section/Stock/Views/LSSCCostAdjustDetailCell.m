//
//  LSSCCostAdjustDetailCell.m
//  retailapp
//
//  Created by guozhi on 2017/4/7.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSCCostAdjustDetailCell.h"
#import "LSCostAdjustDetailVo.h"
#import "SymbolNumberInputBox.h"
@interface LSSCCostAdjustDetailCell ()<SymbolNumberInputClient>
/** 未保存标志 */
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *lblName;
/** 条形码 */
@property (weak, nonatomic) IBOutlet UILabel *lblBarCode;
/** 当前成本价 */
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentCost;
/** 调整后成本价 */
@property (weak, nonatomic) IBOutlet UILabel *lblAfterCost;
/** 调整后成本价标签 */
@property (weak, nonatomic) IBOutlet UILabel *lblAfterCostName;
@property (weak, nonatomic) IBOutlet UIButton *btn;
/** <#注释#> */
@property (nonatomic, copy) CellCallBlock callBlock;
/** <#注释#> */
@property (nonatomic, strong) LSCostAdjustDetailVo *obj;
@property (weak, nonatomic) IBOutlet UIImageView *imgNext;

@end

@implementation LSSCCostAdjustDetailCell

+ (instancetype)costAdjustDetailCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSSCCostAdjustDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
        cell.lblTip.layer.cornerRadius = 2;
    }
    return cell;
}

- (void)setObj:(LSCostAdjustDetailVo *)obj isEdit:(BOOL)isEdit callBlock:(CellCallBlock)callBlock {
    self.callBlock = callBlock;
    self.lblTip.hidden = !obj.isShow;
    _obj = obj;
    //商品名称
    self.lblName.text = obj.goodsName;
    //条形码
    self.lblBarCode.text = obj.barCode;
    //当前成本价
    self.lblCurrentCost.text = [NSString stringWithFormat:@"当前成本价：¥%.2f", obj.beforeCostPrice];
    //调整后成本价
    self.lblAfterCost.text = [NSString stringWithFormat:@"%.2f", obj.laterCostPrice];
    
    self.btn.enabled = isEdit;
    self.lblAfterCost.textColor = isEdit ? [ColorHelper getBlueColor] : [ColorHelper getTipColor6];
    
    self.imgNext.hidden = !isEdit;
    [self.imgNext mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(isEdit ? 22 : 0));
    }];
    if (!isEdit) {
        self.lblAfterCostName.textColor = [ColorHelper getTipColor6];
    }
}
#pragma mark - 点击调整后成本价
- (IBAction)btnClick:(UIButton *)sender {
    [SymbolNumberInputBox show:@"调整后成本价" client:self isFloat:YES isSymbol:NO event:0];
    [SymbolNumberInputBox initData:self.lblAfterCost.text];
    [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    
}
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    self.obj.laterCostPrice = val.doubleValue;
    //调整后成本价
    self.lblAfterCost.text = [NSString stringWithFormat:@"%.2f", val.doubleValue];
    self.lblTip.hidden = !self.obj.isShow;
    if (self.callBlock) {
        self.callBlock();
    }
}

@end
