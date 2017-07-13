//
//  MenuRightCell.h
//  retailapp
//
//  Created by taihangju on 16/6/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuRightCell : UITableViewCell
/** 消息中心标志 */
@property (nonatomic, strong) UIImageView *imgNotice;
+ (instancetype)menuRightCellWithTableView:(UITableView *)tableView;
//  cell填充数据
- (void)fillData:(NSDictionary *)dic;
@end
