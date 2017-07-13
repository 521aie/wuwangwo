//
//  PaymentVo.m
//  retailapp
//
//  Created by 果汁 on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PaymentVo.h"

@implementation PaymentVo
- (NSString *)obtainItemName {
    return self.payMentName;
}
- (NSString *)obtainItemValue {
    return self.payTyleName;
}
- (NSString *)obtainItemId {
    return self.payId;
}
- (NSString *)obtainOrignName {
    return nil;
}

@end
