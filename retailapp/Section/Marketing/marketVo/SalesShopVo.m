//
//  SalesShopVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalesShopVo.h"

@implementation SalesShopVo

-(NSString*) obtainItemName
{
    return self.shopName;
    
}

-(NSString *) obtainItemValue
{
    return self.code;
}

-(NSString *) obtainItemId
{
    return self.shopId;
}

@end
