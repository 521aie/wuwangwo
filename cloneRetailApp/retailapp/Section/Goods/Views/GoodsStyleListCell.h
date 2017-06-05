//
//  GoodsStyleListCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyUILabel, ListStyleVo;
@interface GoodsStyleListCell : UITableViewCell

// 图片
@property (strong, nonatomic) IBOutlet UIImageView *img;
// 商品名称
@property (strong, nonatomic) IBOutlet MyUILabel *lblName;
// 价格
@property (strong, nonatomic) IBOutlet UILabel *lblStyleNo;

@property (strong, nonatomic) IBOutlet UIImageView *imgNext;
//上下架
@property (weak, nonatomic) IBOutlet UIImageView *imgUpDown;

- (void)fillStyleVoInfo:(ListStyleVo *)item;
@end
