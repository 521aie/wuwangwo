//
//  RecordChangeDetailCell.h
//  retailapp
//
//  Created by qingmei on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordChangeDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblCount;
//变更后库存
@property (weak, nonatomic) IBOutlet UILabel *lblChangeCount;


+ (id)getInstance;
- (void)loadCell:(id)obj;
@end
