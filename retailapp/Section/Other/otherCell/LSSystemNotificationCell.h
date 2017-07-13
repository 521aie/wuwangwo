//
//  LSSystemNotificationCell.h
//  retailapp
//
//  Created by guozhi on 16/10/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSNoticeVo.h"

@interface LSSystemNotificationCell : UITableViewCell

/**通知logo*/
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
/**通知名称*/
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationName;
/**通知时间*/
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationTime;
/**下一个图标标志是否可以点击进入下一个页面*/
@property (weak, nonatomic) IBOutlet UIImageView *imgNext;
/**通知内容*/
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationContext;
@property (nonatomic, strong) LSNoticeVo *noticeVo;
+ (instancetype)systemNotificationCellWithTableView:(UITableView *)tableView;
@end
