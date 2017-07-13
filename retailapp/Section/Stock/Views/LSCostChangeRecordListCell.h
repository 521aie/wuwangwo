//
//  LSCostChangeRecordListCell.h
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSCostChangeRecordVo;
@interface LSCostChangeRecordListCell : UITableViewCell
+ (instancetype)costChangeRecordListCelllWithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) LSCostChangeRecordVo *obj;
@end
