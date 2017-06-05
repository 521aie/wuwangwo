//
//  StyleGoodsBatchOfGoodsCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleGoodsBatchOfGoodsCell : UITableViewCell

// 商品名称
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;

// 店内码
@property (strong, nonatomic) IBOutlet UILabel *lblInnerCode;

// 选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgCheck;

// 未选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgUnCheck;

@end
