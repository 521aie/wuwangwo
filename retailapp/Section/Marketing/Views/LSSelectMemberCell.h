//
//  LSSelectMemberCell.h
//  retailapp
//
//  Created by guozhi on 2016/10/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSMemberCardVo.h"

@interface LSSelectMemberCell : UITableViewCell
/** 会员对象 */
@property (nonatomic, strong) LSMemberTypeVo *cardVo;
+ (instancetype)selectMemberCellWithTableView:(UITableView *)tableView;
@end
