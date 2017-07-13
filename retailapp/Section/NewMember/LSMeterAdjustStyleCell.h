//
//  LSMeterAdjustStyleCell.h
//  retailapp
//
//  Created by wuwangwo on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSMemberMeterGoodsVo;

@interface LSMeterAdjustStyleCell : UITableViewCell
+ (instancetype)meterAdjustStyleCellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) LSMemberMeterGoodsVo *obj;
@end
