//
//  IMultiNameValueItem.h
//  RestApp
//
//  Created by zxh on 14-5-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMultiNameValueItem <NSObject>

@required
-(NSString*) obtainItemId;
-(NSString*) obtainItemName;
-(NSString*) obtainItemValue;

@optional
-(BOOL) obtainCheckVal;
-(void) mCheckVal:(BOOL)check;
-(short) obtainItemType;
-(NSString*)obtainItemYear;

@end
