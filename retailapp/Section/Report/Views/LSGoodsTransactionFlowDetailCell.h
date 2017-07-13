//
//  LSGoodsTransactionFlowDetailCell.h
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrderDetailReportVo.h"

@interface LSGoodsTransactionFlowDetailCell : UITableViewCell

+ (instancetype)goodsTransactionFlowDetailCellWithTable:(UITableView *)tableView;
/**
 设置商品商品交易流水详情
 
 @param goodsInfo 上线信息
 @param isOrder   YES 销售单  NO 退货单
 */
- (void)setGoodsInfo:(LSOrderDetailReportVo *)goodsInfo isOrder:(BOOL)isOrder;

@end
