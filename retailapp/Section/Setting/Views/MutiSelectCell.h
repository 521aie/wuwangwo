//
//  MutiSelectCell.h
//  retailapp
//
//  Created by hm on 16/3/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MutiSelectCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblVal;
@property (nonatomic, weak) IBOutlet UIImageView *imgCheck;
@property (nonatomic, weak) IBOutlet UIImageView *imgUnCheck;
@end
