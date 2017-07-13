//
//  RecordDetailCell.h
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetailCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel* lblName;
@property (nonatomic,weak) IBOutlet UILabel* lblCode;
@property (nonatomic,weak) IBOutlet UILabel* lblCount;
@property (nonatomic,weak) IBOutlet UILabel* lblPrice;

@end
