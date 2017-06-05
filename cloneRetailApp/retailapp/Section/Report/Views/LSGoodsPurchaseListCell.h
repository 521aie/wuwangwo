//
//  LSGoodsPurchaseListCell.h
//  retailapp
//
//  Created by guozhi on 2017/1/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSGoodsPurchaseVo;

@interface LSGoodsPurchaseListCell : UITableViewCell
@property (nonatomic, strong) LSGoodsPurchaseVo *obj;
+ (instancetype)goodsPurchaseListCellWithTableView:(UITableView *)tableView;
@end
