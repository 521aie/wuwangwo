//
//  LSCostChangeRecordDetailListCell.m
//  retailapp
//
//  Created by guozhi on 17/4/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCostChangeRecordDetailListCell.h"
#import "LSCostChangeRecordVo.h"
#import "ColorHelper.h"

@interface LSCostChangeRecordDetailListCell ()
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblCount;
//变更后库存
@property (weak, nonatomic) IBOutlet UILabel *lblChangeCount;
@end
@implementation LSCostChangeRecordDetailListCell
+ (instancetype)costChangeRecordDetaolListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSCostChangeRecordDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    }
    return cell;
    
}

- (void)setObj:(LSCostChangeRecordVo *)obj {
    _obj = obj;
    
    _lblTitle.textColor = [ColorHelper getTipColor3];
    _lblTime.textColor = [ColorHelper getTipColor6];
    _lblCount.textColor = [ColorHelper getTipColor6];
    _lblChangeCount.textColor = [ColorHelper getTipColor6];
    
    _lblTitle.text = obj.changeType;
    
    _lblTime.text = obj.opTime;
    
    if ([ObjectUtil isNotNull:obj.difCostPrice]) {
        if (obj.difCostPrice.doubleValue == 0) {
            _lblCount.text = [NSString stringWithFormat:@"¥%.2f", fabs(obj.difCostPrice.doubleValue)];
            _lblCount.textColor = [ColorHelper getTipColor6];
        } else if (obj.difCostPrice.doubleValue < 0) {
            _lblCount.text = [NSString stringWithFormat:@"-¥%.2f", fabs(obj.difCostPrice.doubleValue)];
            _lblCount.textColor = [ColorHelper getGreenColor];
        } else {_lblCount.text = [NSString stringWithFormat:@"+¥%.2f", fabs(obj.difCostPrice.doubleValue)];
            _lblCount.textColor = [ColorHelper getRedColor];
            
        }
    }
    
    if ([ObjectUtil isNotNull:obj.laterCostPrice]) {
       _lblChangeCount.text = [NSString stringWithFormat:@"变更后：¥%.2f", fabs(obj.laterCostPrice.doubleValue)];
    }
}
@end
