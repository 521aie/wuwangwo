//
//  GoodsAreaOfStyleCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

@class MyUILabel, SaleGoodVo;
@interface GoodsAreaOfStyleCell : UITableViewCell

// 图片
@property (strong, nonatomic) IBOutlet UIImageView *img;
// 名称
@property (strong, nonatomic) IBOutlet MyUILabel *lblName;
// code
@property (strong, nonatomic) IBOutlet UILabel *lblCode;
// sku
@property (strong, nonatomic) IBOutlet UILabel *skuInfo;

// del按钮
@property (strong, nonatomic) IBOutlet UIButton *btnDel;

@property (strong, nonatomic) IBOutlet UIImageView *imgDel;

@property (strong , nonatomic) SaleGoodVo* saleGoodVo;

@property (strong , nonatomic) id<ISampleListEvent> delegate;

@end
