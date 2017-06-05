//
//  LSGoodsTransactionFlowMemberView.h
//  retailapp
//
//  Created by guozhi on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrderReportVo.h"
@interface LSGoodsTransactionFlowMemberView : UIView
+ (instancetype)goodsTransactionFlowMemberView;
/**
 设置交易流水会员信息
 
 @param orderReportVo 会员信息
 */
@property (nonatomic, strong) LSOrderReportVo *orderReportVo;
@end
