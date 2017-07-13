//
//  LSMarkCell.h
//  retailapp
//
//  Created by guozhi on 2016/10/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMarkCell : UITableViewCell
/** 名称 */
@property (nonatomic, copy) NSString *name;
+ (instancetype)markCellWithTableView:(UITableView *)tableView;
@end
