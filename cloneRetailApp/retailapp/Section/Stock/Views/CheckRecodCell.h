//
//  CheckRecodCell.h
//  retailapp
//
//  Created by hm on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckRecodCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel* lblDate;

@property (nonatomic,weak) IBOutlet UILabel* lblProfit;

@property (nonatomic,weak) IBOutlet UILabel* lblStoreCount;

@property (nonatomic,weak) IBOutlet UILabel* lblStoreAmount;

@property (nonatomic,weak) IBOutlet UILabel* lblOperator;

@property (nonatomic,weak) IBOutlet UILabel* lblShop;

@end
