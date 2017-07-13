//
//  LSShopColllectionDetailListCell.h
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSStaffHandoverPayTypeVo.h"
@interface LSShopColllectionDetailListCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) LSStaffHandoverPayTypeVo *staffHandoverPayTypeVo;
+ (instancetype)shopColllectionDetailListCellWithTableView:(UITableView *)tableView;
@end
