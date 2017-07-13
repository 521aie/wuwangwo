//
//  WechatGoodsManagementStyleBatchSelectCell.h
//  retailapp
//
//  Created by zhangzt on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WechatGoodsManagementStyleBatchSelectCell : UITableViewCell
// 款式名称
@property (strong, nonatomic) IBOutlet UILabel *lblName;
// 款号
@property (strong, nonatomic) IBOutlet UILabel *lblStyleNo;
// 选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgCheck;
// 未选中图标
@property (nonatomic, weak) IBOutlet UIImageView* imgUnCheck;
// 上下架
@property (weak, nonatomic) IBOutlet UIImageView *imgUporDown;
@end
