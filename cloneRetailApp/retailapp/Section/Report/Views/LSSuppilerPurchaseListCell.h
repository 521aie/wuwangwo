//
//  LSSuppilerPurchaseListCell.h
//  retailapp
//
//  Created by wuwangwo on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSSuppilerPurchaseVo;

@interface LSSuppilerPurchaseListCell : UITableViewCell
@property (nonatomic, strong) LSSuppilerPurchaseVo *obj;
+ (instancetype)suppilerPurchaseDetailCellWithTableView:(UITableView *)tableView;
@end
