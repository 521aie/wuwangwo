//
//  OrderListCell.h
//  retailapp
//
//  Created by yumingdong on 15/10/18.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoVo.h"

@interface OrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgState;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderId;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
- (void)initDate:(OrderInfoVo *)orderInfo;

@end
