//
//  LSGoodsPurchaseDetailCell.h
//  retailapp
//
//  Created by guozhi on 2017/1/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSGoodsPurchaseVo;

@interface LSGoodsPurchaseDetailCell : UITableViewCell
+ (instancetype)goodsPurchaseDetailCellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) LSGoodsPurchaseVo *obj;
@end
