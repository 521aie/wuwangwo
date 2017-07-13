//
//  LSMemberExpenseInfoCell.h
//  retailapp
//
//  Created by byAlex on 16/9/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMemberExpenseInfoCell : UITableViewCell

@property (nonatomic ,strong) UILabel *moneySumLabel;/* <消费金额*/
@property (nonatomic ,strong) UILabel *billIdLable;/* <单号*/
//@property (nonatomic ,strong) UILabel *payTypeLabel;/* <支付方式*/
@property (nonatomic ,strong) UILabel *timeLable;/* <时间*/
@property (nonatomic ,strong) UIImageView *paySourceImageView;/*<支付来源>*/
//@property (nonatomic ,strong) UILabel *orderSource;/* <订单来源 如：微信订单*/
@property (nonatomic ,strong) UIImageView *mbShowDetailImageView;/* <*/
@property (nonatomic ,strong) UIView *bottomLine;/* <*/

- (void)fillMemberExpandVo:(id)vo;
@end
