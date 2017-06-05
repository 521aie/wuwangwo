//
//  LSSmsRechargeCell.h
//  retailapp
//
//  Created by guozhi on 16/9/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSmsPackageVo.h"
@interface LSSmsRechargeCell : UITableViewCell
@property (nonatomic, strong) LSSmsPackageVo *smsPackageVo;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIView *line;
+ (instancetype)smsRechargeCellWithTableView:(UITableView *)tableView;
@end
