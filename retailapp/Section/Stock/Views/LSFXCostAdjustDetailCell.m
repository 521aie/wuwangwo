//
//  LSFXCostAdjustDetailCell.m
//  retailapp
//
//  Created by guozhi on 2017/4/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSFXCostAdjustDetailCell.h"
#import "LSCostAdjustDetailVo.h"

@interface LSFXCostAdjustDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleCode;

@end

@implementation LSFXCostAdjustDetailCell

+ (instancetype)costAdjustDetailCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSFXCostAdjustDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    }
    return cell;
}

- (void)setObj:(LSCostAdjustDetailVo *)obj {
    _obj = obj;
    //商品名称
    self.lblName.text = obj.styleName;
    //条形码
    self.lblStyleCode.text = [NSString stringWithFormat:@"款号：%@", obj.styleCode];
    //当前成本价
}

@end
