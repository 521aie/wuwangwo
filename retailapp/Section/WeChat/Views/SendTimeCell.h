//
//  SendTimeCell.h
//  retailapp
//
//  Created by Jianyong Duan on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@end
