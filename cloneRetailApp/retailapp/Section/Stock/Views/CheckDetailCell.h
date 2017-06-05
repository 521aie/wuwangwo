//
//  CheckDetailCell.h
//  retailapp
//
//  Created by hm on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckDetailCell : UITableViewCell

/**名称*/
@property (nonatomic,weak) IBOutlet UILabel* lblName;
/**条形码*/
@property (nonatomic,weak) IBOutlet UILabel* lblCode;
/**账面库存*/
@property (nonatomic,weak) IBOutlet UILabel* lblBookStore;
/**实库存*/
@property (nonatomic,weak) IBOutlet UILabel* lblStore;
/**盈亏数*/
@property (nonatomic,weak) IBOutlet UILabel* lblProfitCount;
/**销售价*/
@property (nonatomic,weak) IBOutlet UILabel* lblSalePrice;
/**库存金额*/
@property (nonatomic,weak) IBOutlet UILabel* lblStoreAmount;
/**盈亏金额*/
@property (nonatomic,weak) IBOutlet UILabel* lblProfitAmount;


@end
