//
//  LSMemberGoodCell.h
//  retailapp
//
//  Created by taihangju on 16/10/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMemberGoodCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *imgV;/*<>*/
@property (nonatomic ,strong) UILabel *name;/*<商品名称>*/
@property (nonatomic ,strong) UILabel *code;/*<商品条码>*/
@property (nonatomic, strong) UILabel *style;/**<款式信息：服鞋模式才显示>*/
@property (nonatomic ,strong) UILabel *shopNum;/*<实体数量>*/
@property (nonatomic, strong) UILabel *wechatNum;/**<微店数量>*/
@property (nonatomic ,strong) UILabel *integral;/*<兑换所需积分>*/
@property (nonatomic, strong) UIImageView *arrow;/**<向右指向箭头>*/
@property (nonatomic, strong) UIImageView *typeImage;/**<商品类型指示图标>*/
@property (nonatomic, strong) UIButton *selectButton;/**<选择按钮>*/
@property (nonatomic, strong) UIView *bottomLine;/**<分割线>*/

+ (instancetype)mb_goodCellWith:(UITableView *)tableView optional:(BOOL)optional;
- (void)setGiftGoodVo:(id)vo;
@end
