//
//  LSFXCostAdjustDetailCell.h
//  retailapp
//
//  Created by guozhi on 2017/4/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSCostAdjustDetailVo;
@interface LSFXCostAdjustDetailCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) LSCostAdjustDetailVo *obj;
+ (instancetype)costAdjustDetailCellWithTableView:(UITableView *)tableView;
@end
