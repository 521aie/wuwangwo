//
//  LSCommonProblemTypeListCell.h
//  retailapp
//
//  Created by guozhi on 2017/3/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCommonProblemTypeListVo.h"
@interface LSCommonProblemTypeListCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) LSCommonProblemTypeListVo *obj;
+ (instancetype)commonProblemTypeListCellWithTableView:(UITableView *)tableView;
@end
