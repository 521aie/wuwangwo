//
//  INameValueItem.h
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INameValueItem <NSObject>

@optional;
-(NSString*) obtainItemId;
-(NSString*) obtainItemName;
-(NSString*) obtainOrignName;
-(NSString*) obtainItemValue;
@end
