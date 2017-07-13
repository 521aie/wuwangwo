//
//  LSGoodsTransactionFlowHeaderView.h
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrderReportVo.h"
@interface LSGoodsTransactionFlowHeaderView : UIView
+ (instancetype)goodsTransactionFlowHeaderView;
/** 设置交易流水 */
@property (nonatomic, strong) LSOrderReportVo *orderReportVo;
@end
