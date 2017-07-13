//
//  NameValueItemVO.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"
#import "INameItem.h"
#import "Jastor.h"

@interface NameValueItemVO : Jastor<INameItem,INameValueItem>

@property (nonatomic,retain) NSString * itemId;
@property (nonatomic,retain) NSString * itemName;
@property (nonatomic,retain) NSString * itemVal;

-(id)initWithVal:(NSString*)name val:(NSString*)val andId:(NSString*)itemId;

@end
