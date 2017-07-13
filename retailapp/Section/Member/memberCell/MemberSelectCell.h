//
//  MemberRechargeCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberSelectCell : UITableViewCell

// 图片
@property (strong, nonatomic) IBOutlet UIImageView *img;
// 姓名
@property (strong, nonatomic) IBOutlet UILabel *lblName;
// 手机号
@property (strong, nonatomic) IBOutlet UILabel *lblMobile;

// 状态
@property (nonatomic, strong) IBOutlet UIButton *btnStatus;

@end
