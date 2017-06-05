//
//  LSGoodsTransactionFlowFooterView.h
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrderReportVo.h"
@interface LSGoodsTransactionFlowFooterView : UIView
+ (instancetype)goodsTransactionFlowFooterView;

/**
 设置订单信息 商品交易流水详情
 
 @param orderReportVo 订单信息
 @param settlements
 settlements": [{
 "payCode": "现金123123",
 "payMoney": 44.99
	}, {
 "payCode": "[微信]",
 "payMoney": 0.01
	}]
 @param userorderopt
 "userorderopt": [{
 "payCode": null,
 "payMoney": null,
 "outType": "收银",
 "userName": "话梅(工号:1)"
	}],
 */
- (void)setOrderReportVo:(LSOrderReportVo *)orderReportVo settlements:(NSArray *)settlements userorderopt:(NSArray *)userorderopt;

@end
