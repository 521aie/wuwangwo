//
//  VirtualStockCell.h
//  retailapp
//
//  Created by guozhi on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StockInfoVo;
@interface VirtualStockCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *icon;/**<商品图片>*/
@property (nonatomic ,strong) UILabel *name;/**<商品名>*/
@property (nonatomic ,strong) UILabel *code;/**<商品code或条形码编号>*/
@property (nonatomic ,strong) UILabel *stockNum;/**商品库存数>*/
@property (nonatomic ,strong) UILabel *vendibleNum;/**<可销售数量>*/
@property (nonatomic ,strong) UIButton *selectButton;/**<选择button>*/
@property (nonatomic ,strong) UIImageView *arrow;/**<向右的箭头图标>*/
@property (nonatomic, strong) UIImageView *goodTypeIcon;/**<商品类型标示图标：如：加工>*/
@property (nonatomic ,strong) UIView *bottonLine;/**<底部分割线>*/

+ (instancetype)virtualStockCellWithTableView:(UITableView *)tableView optional:(BOOL)option;
- (void)initWithStockInfoVo:(StockInfoVo *)stockInfoVo shopMode:(NSInteger)shopMode;
@end
