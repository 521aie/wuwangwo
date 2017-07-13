//
//  GoodsInfoCell.h
//  retailapp
//
//  Created by hm on 15/9/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsInfoCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel* lblName;

@property (nonatomic,weak) IBOutlet UILabel* lblCode;

@property (nonatomic,weak) IBOutlet UILabel* lblRgtAmount;

@property (nonatomic,weak) IBOutlet UILabel* lblLftAmount;

@property (nonatomic,weak) IBOutlet UILabel* lblDate;

@end
