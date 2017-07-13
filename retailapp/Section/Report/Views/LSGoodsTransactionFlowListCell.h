//
//  LSGoodsTransactionFlowListCell.h
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrderReportVo.h"
@interface LSGoodsTransactionFlowListCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) LSOrderReportVo *orderReportVo;
+ (instancetype)goodsTransactionFlowListCellWithTableView:(UITableView *)tableView;
@end
