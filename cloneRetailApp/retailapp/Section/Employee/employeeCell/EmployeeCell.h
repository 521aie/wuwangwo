//
//  EmployeeCell.h
//  retailapp
//
//  Created by qingmei on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgHead;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail1;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail2;
@property (strong, nonatomic) IBOutlet UILabel *lblRole;
@property (strong, nonatomic) IBOutlet UIImageView *imgRoleBG;

+ (id)getInstance;
- (void)loadCell:(id)obj;

@end
