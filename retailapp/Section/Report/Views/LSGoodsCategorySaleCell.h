//
//  LSGoodsCategorySaleCell.h
//  retailapp
//
//  Created by guozhi on 2016/11/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSGoodsSalesReportVo;
@interface LSGoodsCategorySaleCell : UITableViewCell
/** 商品分类销售对象 */
@property (nonatomic, strong) LSGoodsSalesReportVo *model;
+ (instancetype)goodsCategorySaleCellWithTableView:(UITableView *)tableView;
- (void)fillSaleGoodsSummaryVo:(id)model;
@end
