//
//  LSMenuLeftCell.h
//  retailapp
//
//  Created by guozhi on 2017/2/27.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSModuleModel.h"

@interface LSMenuLeftCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) LSModuleModel *obj;
+ (instancetype)menuLeftCellWithTableView:(UITableView *)tableView;
@end
