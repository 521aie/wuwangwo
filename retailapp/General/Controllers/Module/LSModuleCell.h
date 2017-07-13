//
//  LSModuleCell.h
//  retailapp
//
//  Created by guozhi on 2016/11/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSModuleModel.h"
@interface LSModuleCell : UITableViewCell
/** 菜单数据 */
@property (nonatomic, strong) LSModuleModel *model;
+ (instancetype)moduleCellWithTableView:(UITableView *)tableView;
@end
