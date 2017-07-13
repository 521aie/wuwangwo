//
//  MemberTransactionListCell.h
//  retailapp
//
//  Created by 果汁 on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MemberTransactionListVo,MemberRechargeListVo,MemberIntegralListVo,OrderReportVo;
@interface MemberListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCost;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblGood;// 兑换商品

@property (weak, nonatomic) IBOutlet UILabel *lblTime;

/**初始化会员交易信息列表cell*/
- (void)initDataWithMemberTransactionListVo:(MemberTransactionListVo *)memberTransactionListVo;
/**初始化会员充值记录列表cell*/
- (void)initDataWithMemberRechargeListVo:(MemberRechargeListVo *)memberRechargeListVo;

- (void)initDataWithMemberIntegralListVo:(MemberIntegralListVo *)memberIntegralListVo;
/**商品供货明细表*/
- (void)initDataWithGoodsSupplyList:(NSDictionary *)obj;

@end
