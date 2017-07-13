//
//  OrderDetailView.h
//  retailapp
//
//  Created by guozhi on 15/10/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MemberIntegralDetailVo;
@interface OrderIntegralView : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *lblCode;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UILabel *outFee;
@property (weak, nonatomic) IBOutlet UILabel *labIntegral;

@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodId;
@property (weak, nonatomic) IBOutlet UILabel *goodAttribute;// 颜色尺码（服鞋）
@property (weak, nonatomic) IBOutlet UILabel *goodNum; // 商品数
@property (weak, nonatomic) IBOutlet UILabel *exchangePoint; // 兑换所需积分
+ (instancetype)orderIntegralView;
- (void)initDataWithMemberIntegralDetailVo:(MemberIntegralDetailVo *)memberIntegralDetailVo;
@end
