//
//  LSSuppilerListCell.h
//  retailapp
//
//  Created by guozhi on 2017/2/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupplyVo.h"

@interface LSSuppilerListCell : UITableViewCell
+ (instancetype)suppilerListCellWithTableView:(UITableView *)tableView;
/**  */
@property (nonatomic, strong) SupplyVo *obj;
@end
