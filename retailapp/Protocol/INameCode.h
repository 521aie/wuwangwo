//
//  INameCode.h
//  retailapp
//
//  Created by hm on 15/10/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INameCode <NSObject>
@required
-(NSString*) obtainItemId;
-(NSString*) obtainItemName;

-(NSString*) obtainItemCode;
@optional
-(short) obtainItemType;
-(void)mOperateType:(NSString *)type;
-(NSString*)obtainOperateType;
-(NSString*)obtainOrgId;
- (NSString *)obtainItemEntityId;
@end
