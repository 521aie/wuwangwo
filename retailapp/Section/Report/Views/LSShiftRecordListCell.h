//
//  LSShiftRecordListCell.h
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSUserHandoverVo.h"
@interface LSShiftRecordListCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) LSUserHandoverVo *userHangoverVo;
+ (instancetype)shiftRecordListCellWithTableView:(UITableView *)tableView;
@end
