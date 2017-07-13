//
//  LSMemberMeterListCell.h
//  retailapp
//
//  Created by wuwangwo on 2017/3/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSMemberMeterVo;

@interface LSMemberMeterListCell : UITableViewCell

@property (nonatomic, strong) LSMemberMeterVo *obj;
+ (instancetype)memberMeteringListCellWithTableView:(UITableView *)tableView;
- (CGFloat)heightForContent:(NSString *)content;
@end
