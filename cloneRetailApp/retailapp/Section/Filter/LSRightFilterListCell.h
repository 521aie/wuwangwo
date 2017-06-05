//
//  LSRightFilterListCell.h
//  retailapp
//
//  Created by guozhi on 2017/1/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryVo.h"
@interface LSRightFilterListCell : UITableViewCell
/** 分类数据 */
@property (nonatomic, strong) id<INameItem> obj;
+ (instancetype)rightFilterListCellWithTableView:(UITableView *)tableView;
@end
