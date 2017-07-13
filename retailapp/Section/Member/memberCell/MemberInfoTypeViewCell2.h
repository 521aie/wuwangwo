//
//  MemberInfoTypeViewCell2.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomerCardVo;

@interface MemberInfoTypeViewCell2 : UITableViewCell

// 姓名
@property (nonatomic, strong) IBOutlet UILabel *lblCustomerName;

// 手机号码
@property (nonatomic, strong) IBOutlet UILabel *lblMobile;

// 卡类型
@property (nonatomic, strong) IBOutlet UILabel *lblMemberType;

// 状态
@property (nonatomic, strong) IBOutlet UIButton *btnStatus;

// 状态
@property (nonatomic, strong) IBOutlet UIImageView *imgMember;

- (void)fillMemberInfo:(CustomerCardVo *)obj;
@end
