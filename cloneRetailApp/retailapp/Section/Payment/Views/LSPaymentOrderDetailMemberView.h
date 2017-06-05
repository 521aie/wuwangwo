//
//  LSPaymentOrderDetailMemberView.h
//  retailapp
//
//  Created by guozhi on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrderReportVo.h"
#import "LSPersonDetailVO.h"
@interface LSPaymentOrderDetailMemberView : UIView
+ (instancetype)paymentOrderDetailMemberView;
/** 会员信息 */
@property (nonatomic, strong) LSPersonDetailVO *personDetailVO;
@end
