//
//  LSFilterCell.h
//  retailapp
//
//  Created by guozhi on 2016/10/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSFilterModel.h"
@protocol LSFilterCellDelegate;
@interface LSFilterCell : UITableViewCell
/** 数据模型 */
@property (nonatomic, strong) LSFilterModel *model;
+ (instancetype)filterCellWithTableView:(UITableView *)tableView delegate:(id<LSFilterCellDelegate>)delegate;
@end
@protocol LSFilterCellDelegate <NSObject>
@optional
- (void)filterCellDidClickModel:(LSFilterModel *)filterModel;
@end

