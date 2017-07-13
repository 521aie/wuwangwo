//
//  BusinessSummaryBox.h
//  retailapp
//
//  Created by hm on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessSummaryBox : UIView

@property (nonatomic,weak) IBOutlet UIView* view;
@property (nonatomic,weak) IBOutlet UIView* backGround;
/**今日收益*/
@property (nonatomic,weak) IBOutlet UILabel* lblName;
/**总营业金额*/
@property (nonatomic,weak) IBOutlet UILabel* lblTotalAmount;
/**日历图标*/
@property (nonatomic,weak) IBOutlet UIImageView* imgType;
/**日期*/
@property (nonatomic,weak) IBOutlet UILabel* lblDate;
@property (weak, nonatomic) IBOutlet UIView *container;

//按日查询
- (void)initDataWithList1:(NSMutableArray *)list1 title:(NSString *)title list2:(NSMutableArray *)list2 date:(NSString *)dateStr shopFlag:(int)shopFlag;

//按月查询
- (void)initDataWithList:(NSMutableArray *)list title:(NSString *)title shopFlag:(int)shopFlag;
@end
