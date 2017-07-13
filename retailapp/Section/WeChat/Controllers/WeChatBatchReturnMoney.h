//
//  WeChatBatchReturnMoney.h
//  retailapp
//
//  Created by diwangxie on 16/4/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SellReturnMoneyDetail)();
@interface WeChatBatchReturnMoney : BaseViewController

@property (nonatomic, strong) NSString *searchType;
@property (nonatomic, strong) NSString *serachCode;
@property (nonatomic, copy) SellReturnMoneyDetail sellReturnMoneyDetailBlock;

- (void)loadSellReturnMoney:(BOOL)isPush callBack:(SellReturnMoneyDetail)callBack;
@end
