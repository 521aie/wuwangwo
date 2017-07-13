//
//  RoleCell.h
//  retailapp
//
//  Created by qingmei on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbDetail;

+ (id)getInstance;
- (void)loadCell:(id)obj;
@end
