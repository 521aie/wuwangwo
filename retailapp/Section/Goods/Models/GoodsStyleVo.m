//
//  GoodsStyleVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsStyleVo.h"
#import "INameValueItem.h"

@implementation GoodsStyleVo

-(NSString*) obtainItemId
{
    return self.goodsStyleId;
}

-(NSString*) obtainItemName
{
    return self.goodsStyleName;
    
}

-(NSString*) obtainOrignName
{
    return self.goodsStyleName;
    
}

-(NSString *) obtainItemValue
{
    return self.innerCode;
}

@end
