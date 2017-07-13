//
//   LSGoodCell.h
//  retailapp
//
//  Created by guozhi on 16/8/24.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Wechat_StyleVo, MicroWechatGoodsVo, GoodsVo;
@interface LSGoodCell : UITableViewCell
/**
 *  设置微店款式
 */
@property (nonatomic, strong) Wechat_StyleVo *wechatStyleVo;
/**
 *  设置微店商品商超
 */
@property (nonatomic, strong) MicroWechatGoodsVo *wechatGoodsVo;
/**
 *  设置实体商品商超
 */
@property (nonatomic, strong) GoodsVo *goodsVo;
/**
 *  创建一个单元格
 *
 *  @param tableView 哪个tableView的单元格
 *
 *  @return 单元格本身 如果重用队列池有单元格 会优先从队列池中创建
 */
+ (instancetype)goodCellAtTableView:(UITableView *)tableView;
@end
