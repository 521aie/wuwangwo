//
//  LSPaymentOrderDetailRechargeTopView.h
//  retailapp
//
//  Created by wuwangwo on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSPersonDetailVO;

@interface LSPaymentOrderDetailRechargeTopView : UIView

+ (instancetype)paymentOrderDetailRechargeTopView;
- (void)setPersonDetailVO:(LSPersonDetailVO *)personDetailVO cardNo:(NSString *)cardNo;
@end