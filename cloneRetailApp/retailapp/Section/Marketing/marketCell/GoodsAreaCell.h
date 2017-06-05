//
//  GoodsAreaCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

@class MyUILabel, SaleGoodVo;
@interface GoodsAreaCell : UITableViewCell
// 图片
@property (strong, nonatomic) IBOutlet UIImageView *img;
// 名称
@property (strong, nonatomic) IBOutlet MyUILabel *lblName;
// code
@property (strong, nonatomic) IBOutlet UILabel *lblCode;

@property (strong , nonatomic) SaleGoodVo* saleGoodVo;

// del按钮
@property (strong, nonatomic) IBOutlet UIButton *btnDel;

@property (strong, nonatomic) IBOutlet UIImageView *imgDel;

@property (strong , nonatomic) id<ISampleListEvent> delegate;

@end
