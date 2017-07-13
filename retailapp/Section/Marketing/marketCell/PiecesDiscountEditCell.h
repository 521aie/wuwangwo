//
//  PiecesDiscountEditCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

@class DiscountGoodsVo;
@interface PiecesDiscountEditCell : UITableViewCell

// 名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;

// 折扣
@property (strong, nonatomic) IBOutlet UILabel *lblRate;

// 删除按钮
@property (strong, nonatomic) IBOutlet UIButton *btnDel;

@property (strong , nonatomic) DiscountGoodsVo* discountGoodsVo;

@property (strong , nonatomic) id<ISampleListEvent> delegate;

@end
