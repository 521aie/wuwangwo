//
//  WeChatRebateOrdersCell.h
//  retailapp
//
//  Created by diwangxie on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoVo.h"

@interface OrdersRebateListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderCode;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblWithdrawState;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderState;
@property (weak, nonatomic) IBOutlet UILabel *lblCreateTime;

@property (nonatomic,strong) OrderInfoVo* orderInfoVo;

-(void)initDate:(NSDictionary *) dic;

@end
