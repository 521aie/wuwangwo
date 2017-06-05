//
//  LSSCCostAdjustDetailCell.h
//  retailapp
//
//  Created by guozhi on 2017/4/7.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
typedef void(^CellCallBlock)();
#import <UIKit/UIKit.h>
@class LSCostAdjustDetailVo;
@interface LSSCCostAdjustDetailCell : UITableViewCell
+ (instancetype)costAdjustDetailCellWithTableView:(UITableView *)tableView;
- (void)setObj:(LSCostAdjustDetailVo *)obj isEdit:(BOOL)isEdit callBlock:(CellCallBlock)callBlock;
@end
