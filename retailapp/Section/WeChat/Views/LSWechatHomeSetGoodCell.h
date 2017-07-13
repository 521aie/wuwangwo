//
//  LSWechatHomeSetGoodCell.h
//  retailapp
//
//  Created by guozhi on 16/9/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MicroWechatGoodsVo;
@interface LSWechatHomeSetGoodCell : UITableViewCell

/**
 *  设置微店商品
 */
@property (nonatomic, strong) MicroWechatGoodsVo *goodsVo;
/**
 *  创建一个单元格
 *
 *  @param tableView 哪个tableView的单元格
 *
 *  @return 单元格本身 如果重用队列池有单元格 会优先从队列池中创建
 */
+ (instancetype)wechatGoodCellAtTableView:(UITableView *)tableView;
@end
