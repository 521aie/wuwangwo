//
//  SelectSplitOrderCell.h
//  retailapp
//
//  Created by Jianyong Duan on 16/1/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectSplitOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblShopName;
@property (weak, nonatomic) IBOutlet UILabel *lblNum;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UIImageView *imgUncheck;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;

@end
