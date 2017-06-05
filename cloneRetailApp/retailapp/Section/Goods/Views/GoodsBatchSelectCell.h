//
//  GoodsBatchSelectCell.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsVo;
@protocol GoodsBatchSelectCellDelegate <NSObject>

- (void)checkGoods:(GoodsVo*)vo;

@end

@interface GoodsBatchSelectCell : UITableViewCell

// 商品名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;
// 商品条码
@property (strong, nonatomic) IBOutlet UILabel *lblBarcode;
// 类型
@property (strong, nonatomic) IBOutlet UILabel *lblType;
// 选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgCheck;
// 未选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgUnCheck;

@property (nonatomic, strong) GoodsVo *vo;
@property (weak, nonatomic) IBOutlet UIImageView *imgUpDown;

@property (nonatomic,assign) id<GoodsBatchSelectCellDelegate> delegate;

@end
