//
//  LSHelpVideoListCell.h
//  retailapp
//
//  Created by guozhi on 2017/2/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSVideoItemVo.h"
@interface LSHelpVideoListCell : UITableViewCell
+ (instancetype)helpVideoListCellWithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) LSVideoItemVo *obj;
@end
