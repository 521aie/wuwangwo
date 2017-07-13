//
//  GoodsStyleBatchSelectCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsStyleBatchSelectCell2 : UITableViewCell

// 款式名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;
// 款号
@property (strong, nonatomic) IBOutlet UILabel *lblStyleNo;

@property (weak, nonatomic) IBOutlet UIImageView *img_updown;

@end
