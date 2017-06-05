//
//  AdjustStyleCell.h
//  retailapp
//
//  Created by hm on 16/2/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustStyleCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblNo;
@property (nonatomic, weak) IBOutlet UILabel *lblAdjustCount;
@property (nonatomic, weak) IBOutlet UILabel *lblStoreCount;
@property (nonatomic, weak) IBOutlet UILabel *lblActualCount;
@end
