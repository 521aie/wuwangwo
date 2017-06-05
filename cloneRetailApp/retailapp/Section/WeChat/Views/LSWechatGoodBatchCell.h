//
//  LSWechatGoodBatchCell.h
//  retailapp
//
//  Created by guozhi on 16/8/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MicroWechatGoodsVo, Wechat_StyleVo;
@interface LSWechatGoodBatchCell : UITableViewCell
/**
 *  设置商品
 */
@property (nonatomic, strong) MicroWechatGoodsVo *goodsVo;
/**
 *  设置款式
 */
@property (nonatomic, strong) Wechat_StyleVo *styleVo;
+ (instancetype)wechatGoodBatchCellAtTableView:(UITableView *)tableView;
@end
