//
//  MemberChargeRecordCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberChargeRecordCell : UITableViewCell

// 姓名
@property (nonatomic, strong) IBOutlet UILabel *lblCustomerName;

// 手机号码
@property (nonatomic, strong) IBOutlet UILabel *lblMobile;

// 充值方式
@property (nonatomic, strong) IBOutlet UIButton *btnType;

// 充值金额
@property (nonatomic, strong) IBOutlet UILabel *lblMoney;

// 时间
@property (nonatomic, strong) IBOutlet UILabel *lblTime;

@end
