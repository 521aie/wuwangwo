//
//  MicroOrderDealVo.h
//  retailapp
//
//  Created by yumingdong on 15/10/18.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "IMultiNameValueItem.h"

@interface MicroOrderDealVo : Jastor<IMultiNameValueItem>

/**
 * <code>订单处理dealId</code>.
 */
@property (nonatomic) int dealId;

/**
 * <code>门店/仓库shopId</code>.
 */
@property (nonatomic, strong) NSString *shopId;

/**
 * <code>店铺区分shopType</code>.
 */
@property (nonatomic) short shopType;

/**
 * <code>门店/仓库名称</code>.
 */
@property (nonatomic, strong) NSString *name;

/**
 * <code>门店/仓库编号</code>.
 */
@property (nonatomic, strong) NSString *code;

@end
