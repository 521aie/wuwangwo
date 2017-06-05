//
//  VirtualStockCell.h
//  retailapp
//
//  Created by guozhi on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsVo;
@interface AlertSettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labCode;
/** <#注释#> */
@property (nonatomic, strong) GoodsVo *obj;
@end
