//
//  LSMemberCardBalanceCell.h
//  retailapp
//
//  Created by taihangju on 16/10/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMemberCardBalanceCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *imgV;/*<ImageView>*/
@property (nonatomic ,strong) UILabel *moneyLabel;/*<显示多少钱：eg5元，在图片上>*/
@property (nonatomic ,strong) UILabel *typeLabel;/*<显示：卡余额字样>*/
@property (nonatomic ,strong) UILabel *balance;/*<卡余额信息>*/
@property (nonatomic ,strong) UILabel *integral;/*<所需积分>*/
@property (nonatomic, strong) UIImageView *arrow;/**<向右指向箭头>*/
@property (nonatomic, strong) UIButton *selectButton;/**<选择按钮>*/
@property (nonatomic, strong) UIView *bottomLine;/**<分割线>*/

- (void)setData:(id)selectObj;
+ (instancetype)mb_balanceCellWith:(UITableView *)tableView optional:(BOOL)optional;
@end
