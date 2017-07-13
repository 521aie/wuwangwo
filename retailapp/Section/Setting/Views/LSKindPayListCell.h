//
//  LSKindPayListCell.h
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentVo.h"

@interface LSKindPayListCell : UITableViewCell
/** 支付对象 */
@property (nonatomic, strong) PaymentVo *paymentVo;
+ (instancetype)kindPayListCellWithTableView:(UITableView *)tableView;
@end
