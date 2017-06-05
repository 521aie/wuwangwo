//
//  PaperCheckCell.h
//  retailapp
//
//  Created by hm on 15/7/31.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaperCheckCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel* lblPaperNo;

@property (nonatomic,weak) IBOutlet UILabel* lblDetail;

@property (nonatomic,weak) IBOutlet UILabel* lblDate;

@property (nonatomic,weak) IBOutlet UILabel * lblStatus;

@property (nonatomic,weak) IBOutlet UIImageView* checkPic;

@property (nonatomic,weak) IBOutlet UIImageView* uncheckPic;

@end
