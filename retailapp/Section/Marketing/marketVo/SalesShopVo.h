//
//  SalesShopVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameValueItem.h"

@interface SalesShopVo : Jastor<INameValueItem>

/**商户ID*/
@property (nonatomic,copy) NSString* shopId;

/**店铺名称*/
@property (nonatomic,copy) NSString* shopName;

/**商户代码*/
@property (nonatomic,copy) NSString* code;

@end
