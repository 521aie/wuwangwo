//
//  LSOrderPayTypeCell.h
//  retailapp
//
//  Created by guozhi on 16/9/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPayVo.h"
@interface LSOrderPayTypeCell : UITableViewCell
@property (nonatomic, strong) LSPayVo *payVo;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UIImageView *imgCheck;
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UIView *line;
+ (instancetype)orderPayTypeCellWithTableView:(UITableView *)tableView;
@end
