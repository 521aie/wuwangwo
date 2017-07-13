//
//  LSMemberIntegralExchangeCell.h
//  retailapp
//
//  Created by taihangju on 16/10/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LSMemberIntegralExchangeCellDelegate;
@class LSMemberGoodsGiftVo;
// 积分兑换cell ，积分兑换页面配置积分所兑换的商品
@interface LSMemberIntegralExchangeCell : UITableViewCell

@property (nonatomic ,strong) UILabel *goodName;/*<兑换的商品名>*/
@property (nonatomic ,strong) UILabel *goodAttribute;/*<商品款式颜色等属性>*/
@property (nonatomic ,strong) UILabel *needIntegral;/*<所需积分>*/
@property (nonatomic ,strong) UILabel *remainNum;/**<剩余数量>*/
@property (nonatomic ,strong) UIButton *subtractButton;/*<减操作button>*/
@property (nonatomic ,weak) id<LSMemberIntegralExchangeCellDelegate>delegate;/*<>*/

- (void)fillData:(LSMemberGoodsGiftVo *)obj;
@end

@protocol LSMemberIntegralExchangeCellDelegate <NSObject>

- (void)countChange:(LSMemberGoodsGiftVo *)vo cell:(LSMemberIntegralExchangeCell *)cell;
@end
