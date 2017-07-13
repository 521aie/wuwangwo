//
//  LSStockAdjustListCell.h
//  retailapp
//
//  Created by guozhi on 2017/3/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockAdjustVo.h"
@interface LSStockAdjustListCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) StockAdjustVo *obj;
+ (instancetype)stockAdjustListCellWithTableView:(UITableView *)tableView;
- (void)setObj:(StockAdjustVo *)obj statusList:(NSArray *)statusList;
@end
