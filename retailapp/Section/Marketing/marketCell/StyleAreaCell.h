//
//  StyleAreaCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

@class MyUILabel, SaleStyleVo;
@interface StyleAreaCell : UITableViewCell

// 图片
@property (strong, nonatomic) IBOutlet UIImageView *img;
// 名称
@property (strong, nonatomic) IBOutlet MyUILabel *lblName;
// 价格
@property (strong, nonatomic) IBOutlet UILabel *lblStyleNo;
// del按钮
@property (strong, nonatomic) IBOutlet UIButton *btnDel;

@property (strong, nonatomic) IBOutlet UIImageView *imgDel;

@property (strong , nonatomic) SaleStyleVo* saleStyleVo;

@property (strong , nonatomic) id<ISampleListEvent> delegate;

@end
