//
//  MemberInfoTypeViewCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberInfoTypeViewCell : UITableViewCell

// 卡类型
@property (nonatomic, strong) IBOutlet UILabel *lblMemberType;

// 会员数量
@property (nonatomic, strong) IBOutlet UILabel *lblNum;

@end
