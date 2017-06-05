//
//  GoodsListCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  GoodsVo;
@interface GoodsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgNext;

// 图片
@property (strong, nonatomic) IBOutlet UIImageView *img;
// 商品名称
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIView *line;

// 价格
@property (strong, nonatomic) IBOutlet UILabel *lblCode;

// 价格
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;

@property (nonatomic, strong) GoodsVo *goodsVo;
+ (instancetype)goodsListCellWithTableView:(UITableView *)tableView;
@end
