//
//  WeChatReturnMoneyDetail.h
//  retailapp
//
//  Created by diwangxie on 16/4/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SellReturnMoneyDetail)();
@class RetailSellReturnVo;
@interface WeChatReturnMoneyDetail : BaseViewController

@property (nonatomic,copy) SellReturnMoneyDetail sellReturnMoneyDetailBlock;
@property (nonatomic, strong) RetailSellReturnVo *sellReturnVo;

- (void)loadSellReturnMoney:(BOOL)isPush callBack:(SellReturnMoneyDetail)callBack;
@end
