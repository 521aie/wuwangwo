//
//  LSMemberMeterCardListCell.h
//  retailapp
//
//  Created by wuwangwo on 2017/4/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSMemberMeterCardListVo;

@interface LSMemberMeterCardListCell : UITableViewCell
@property (nonatomic, strong) LSMemberMeterCardListVo *obj;
+ (instancetype)memberMeterCardListCellWithTableView:(UITableView *)tableView;
@end
