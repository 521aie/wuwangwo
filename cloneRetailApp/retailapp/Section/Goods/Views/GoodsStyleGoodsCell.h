//
//  GoodsStyleGoodsCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsStyleGoodsCell : UITableViewCell

// 商品名称
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;

// 店内码
@property (strong, nonatomic) IBOutlet UILabel *lblInnerCode;

@end
