//
//  INameValue.h
//  retailapp
//
//  Created by hm on 15/9/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INameValue <NSObject>

@required
-(NSString *)obtainItemId;
-(NSString *)obtainItemName;
-(NSString *)obtainItemValue;

@optional
-(NSString *)obtainItemType;
- (void)mItemName:(NSString *)name;
@end
