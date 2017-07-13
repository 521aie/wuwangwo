//
//  LogisticsInfoCell.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogisticsInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (weak, nonatomic) IBOutlet UIView *viewLineUp;
@property (weak, nonatomic) IBOutlet UIView *viewLineDown;
@end
