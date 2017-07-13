//
//  CustomRechargeSalesCell.h
//  RestApp
//
//  Created by zhangzhiliang on 15/7/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberRechargeSalesCell : UITableViewCell<UIActionSheetDelegate>

// 充值促销活动名称
@property (nonatomic, strong) IBOutlet UILabel *lblRechargeSalesName;

// 活动状态
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;

// 充值金额
@property (nonatomic, strong) IBOutlet UILabel *lblRechargeThreshold;

// 赠送金额
@property (nonatomic, strong) IBOutlet UILabel *lblMoney;

@end
