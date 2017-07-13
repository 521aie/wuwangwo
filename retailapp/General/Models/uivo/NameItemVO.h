//
//  NameItemVO.h
//  RestApp
//
//  Created by zxh on 14-4-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"
#import "INameItem.h"
#import "Jastor.h"

@interface NameItemVO : Jastor<INameItem,INameValueItem>

@property (nonatomic, strong) NSString * itemId;
@property (nonatomic, strong) NSString * itemName;
@property (nonatomic) NSInteger itemSortCode;
-(id)initWithVal:(NSString*)name andId:(NSString*)itemId;
-(id)initWithVal:(NSString*)name andId:(NSString*)itemId  andSortCode:(NSInteger) itemSortCode;
@end
