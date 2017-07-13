//
//  LSStockQueryListCell.h
//  retailapp
//
//  Created by guozhi on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StockInfoVo;

@interface LSStockQueryListCell : UITableViewCell
+ (instancetype)stockQueryListCellWithTableView:(UITableView *)tableView;
/**  */
@property (nonatomic, strong) StockInfoVo *obj;
@end
