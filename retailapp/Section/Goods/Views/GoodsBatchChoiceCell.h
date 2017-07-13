//
//  GoodsBatchChoiceCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsVo.h"
#import "SaleGoodVo.h"
#import "StyleGoodsVo.h"
#import "MicroWechatGoodsVo.h"
@interface GoodsBatchChoiceCell : UITableViewCell

// 商品名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;
// 商品条码
@property (strong, nonatomic) IBOutlet UILabel *lblCode;
// 类型
@property (strong, nonatomic) IBOutlet UILabel *lblType;
// 选中不选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgCheck;

@property (nonatomic, strong) GoodsVo *goodsVo;


@property (nonatomic, strong) SaleGoodVo *saleGoodVo;

@property (nonatomic, strong)  StyleGoodsVo *styleGoodsVo;
@property (weak, nonatomic) IBOutlet UIImageView *imgUpDown;

/**
 *  设置微店商品
 */
@property (nonatomic, strong) MicroWechatGoodsVo *wechatGoodsVo;
+ (instancetype)goodsBatchChoiceCellWithTableView:(UITableView *)tableView;
@end
