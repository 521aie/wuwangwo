//
//  LSSystemSmsCell.h
//  retailapp
//
//  Created by guozhi on 2016/11/3.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSystemNotificationVo.h"

@protocol LSSystemSmsCellDelegate <NSObject>

- (void)needReloadVisibleCell:(UITableViewCell *)cell;
@end

@interface LSSystemSmsCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) LSSystemNotificationVo *systemNotificationVo;
@property (nonatomic ,weak) id<LSSystemSmsCellDelegate> delegate;/*<<#说明#>>*/
+ (instancetype)systemSmsCellWithTableView:(UITableView *)tableView;
@end
