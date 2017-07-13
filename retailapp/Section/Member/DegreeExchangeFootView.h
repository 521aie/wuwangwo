//
//  DegreeExchangeFootView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DegreeExchangeFootViewDelegate <NSObject>

-(void) ExchangeButton;

@end

@interface DegreeExchangeFootView : UIView

// 商品件数
@property (nonatomic, strong) IBOutlet UILabel *lblGoodsNum;

// 积分
@property (nonatomic, strong) IBOutlet UILabel *lblpoint;

// 兑换
@property (nonatomic, strong) IBOutlet UIButton *btnExc;

@property (nonatomic, assign) id<DegreeExchangeFootViewDelegate> delegate;

@end
