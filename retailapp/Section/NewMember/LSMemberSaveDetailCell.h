//
//  LSMemberSaveDetailCell.h
//  retailapp
//
//  Created by taihangju on 16/10/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
// 储值明细cell
@interface LSMemberSaveDetailCell : UITableViewCell

@property (nonatomic ,strong) UILabel *rechargeInfo;/*<充值信息>*/
//@property (nonatomic ,strong) UILabel *rechargeType;/*<充值渠道>*/
@property (nonatomic, strong) UILabel *payScore;/*<赠送积分>*/
@property (nonatomic ,strong) UILabel *payType;/*<支付方式>*/
@property (nonatomic ,strong) UILabel *time;/*<时间>*/
@property (nonatomic ,strong) UILabel *balance;/*<卡余额Label>*/
@property (nonatomic ,strong) UIButton *redRush;/*<红冲 按钮>*/
@property (nonatomic ,copy) void(^callBack)();/*<回调block>*/

- (void)fillIntegralDetailData:(id)obj;
- (void)fillSaveDetailData:(id)obj;
@end
