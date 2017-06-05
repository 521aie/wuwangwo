//
//  LSPaymentAccountView.h
//  retailapp
//
//  Created by guozhi on 2017/3/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSPaymentAccountView : UIView
/** 未到账总额 */
@property (nonatomic, strong) UILabel *lblUnReceivedTotalName;
/** 未到账总额 */
@property (nonatomic, strong) UILabel *lblUnReceivedTotalVal;
/** 某天收入 */
@property (nonatomic, strong) UILabel *lblDayIncomeName;
/** 某天收入 */
@property (nonatomic, strong) UILabel *lblDayIncomeVal;
/** 某天已到账 */
@property (nonatomic, strong) UILabel *lblDayReceivedName;
/** 某天已到账 */
@property (nonatomic, strong) UILabel *lblDayReceivedVal;
/** 服务费 */
@property (nonatomic, strong) UILabel *lblRate;
/** 本月累计收入 */
@property (nonatomic, strong) UILabel *lblMonthIncomeName;
/** 本月累计收入 */
@property (nonatomic, strong) UILabel *lblMonthIncomeVal;
/** 本月累计已到账 */
@property (nonatomic, strong) UILabel *lblMonthReceivedName;
/** 本月累计已到账 */
@property (nonatomic, strong) UILabel *lblMonthReceivedVal;
/** 未绑定View */
@property (nonatomic, strong) UIView *viewUnBind;
/** 未绑定文字 */
@property (nonatomic, strong) UILabel *lblUnBind;
/** 绑定文字 */
@property (nonatomic, strong) UILabel *lblBind;
/** 绑定按钮 */
@property (nonatomic, strong) UIButton *btnBind;
/** <#注释#> */
@property (nonatomic, strong) UILabel *lblTip;
+ (instancetype)paymentAccountView;
/** 是否绑定卡 YES 绑定 NO 不绑定*/
@property (nonatomic, assign) BOOL isBindCard;
@end
