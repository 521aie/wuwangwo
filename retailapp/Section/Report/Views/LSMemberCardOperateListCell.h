//
//  LSMemberCardOperateListCell.h
//  retailapp
//
//  Created by wuwangwo on 17/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCardOperateListVo.h"

@interface LSMemberCardOperateListCell : UITableViewCell
@property (nonatomic, strong) LSCardOperateListVo *operateVo;
+ (instancetype)shopCollectionListCellWithTableView:(UITableView *)tableView;
- (void)setoperateVo:(LSCardOperateListVo *)operateVo showNextimg:(BOOL)show;
@end
