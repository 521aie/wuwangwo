//
//  LSPaymentOrderDetailCell.h
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstanceVo.h"

@interface LSPaymentOrderDetailCell : UITableViewCell

+ (instancetype)paymentOrderDetailCellWithTable:(UITableView *)tableView;
@property (nonatomic, strong) InstanceVo *goodsInfo;
@end
