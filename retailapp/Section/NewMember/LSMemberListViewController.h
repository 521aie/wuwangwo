//
//  LSMemberListViewController.h
//  retailapp
//
//  Created by taihangju on 16/9/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

// 会员选择页面/ 会员信息汇总 共用该控制器
@interface LSMemberListViewController : BaseViewController

- (instancetype)init:(NSInteger)type packVos:(NSArray *)array;
// 会员汇总-> 查询指定日期(具体某天的新增会员数)
- (instancetype)initWithCheckDate:(NSString *)checkDate;
@end
