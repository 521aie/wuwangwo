//
//  LSHelpListCell.h
//  retailapp
//
//  Created by guozhi on 2017/3/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSHelpContextVo;
@interface LSHelpListCell : UITableViewCell
+ (instancetype)helpListCellWithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *obj;
@end
