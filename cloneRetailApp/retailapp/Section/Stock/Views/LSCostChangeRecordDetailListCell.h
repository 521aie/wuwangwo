//
//  LSCostChangeRecordDetailListCell.h
//  retailapp
//
//  Created by guozhi on 17/4/3.
//  Copyright (c) 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSCostChangeRecordVo;
@interface LSCostChangeRecordDetailListCell : UITableViewCell
/**  */
@property (nonatomic, strong) LSCostChangeRecordVo *obj;

+ (instancetype)costChangeRecordDetaolListCellWithTableView:(UITableView *)tableView;
@end
