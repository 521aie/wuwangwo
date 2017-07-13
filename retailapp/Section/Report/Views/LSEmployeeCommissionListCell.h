//
//  LSEmployeeCommissionListCell.h
//  retailapp
//
//  Created by guozhi on 2016/11/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSEmployeeCommissionVo.h"

@interface LSEmployeeCommissionListCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) LSEmployeeCommissionVo *employeeCommissionVo;
+ (instancetype)employeeCommissionListCellWithTableView:(UITableView *)tableView;
@end
