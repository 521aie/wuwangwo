//
//  SelectGoodsCell.h
//  retailapp
//
//  Created by zhangzhiliang on 16/3/3.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonGoodsSelectCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *img;     /**<图片>*/
@property (strong, nonatomic) IBOutlet UILabel *lblName;   /**<商品名称>*/
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;    /**<价格>*/
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

- (void)fillGoodVo:(id)vo;
- (void)fillGoodsOperationVo:(id)vo;
+ (instancetype)commonGoodsSelectCellWith:(UITableView *)tableView;
@end
