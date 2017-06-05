//
//  LSScreenAdvertisingCell.h
//  retailapp
//
//  Created by guozhi on 2016/11/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSScreenAdvertisingCell : UITableViewCell
/** logo */
@property (nonatomic, strong) UIImageView *imgView;
/** 标题 */
@property (nonatomic, strong) UILabel *lblName;
/** 详情描述 */
@property (nonatomic, strong) UILabel *lblDetail;

/** 数据模型 path->value name->value detail->value */
@property (nonatomic, strong) NSDictionary *dict;
+ (instancetype)screenAdvertisingCellWithTableView:(UITableView *)tableView;
@end
