//
//  OrderPayListData.h
//  RestApp
//
//  Created by 果汁 on 15/9/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderPayListData : NSObject

@property (nonatomic, strong) NSString *innerCode;
@property (nonatomic, strong) NSNumber *payTime;
@property (nonatomic, strong) NSString *seatName;
@property (nonatomic, strong) NSNumber *wxPay;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *wechatNickName;
@property (nonatomic, strong) NSString *shareBillStatusMsg;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, copy) NSString *transcationId;//订单号
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
