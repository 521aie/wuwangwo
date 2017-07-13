//
//  LSCostAdjustListCell.h
//  retailapp
//
//  Created by guozhi on 2017/3/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCostAdjustVo.h"
@interface LSCostAdjustListCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) LSCostAdjustVo *obj;
/** <#注释#> */
+ (instancetype)costAdjustListCellWithTableView:(UITableView *)tableView;
@end
