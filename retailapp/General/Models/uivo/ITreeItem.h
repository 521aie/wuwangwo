//
//  ITreeItem.h
//  retailapp
//
//  Created by hm on 15/8/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITreeItem <NSObject>
@required
- (NSString *)obtainItemId;
- (NSString *)obtainItemName;
- (NSString *)obtainItemValue;
- (NSString *)obtainParentId;
- (NSString *)obtainShopEntityId;
- (void)mId:(NSString *)itemId;
- (void)mName:(NSString *)itemName;
- (void)mVal:(NSString *)itemVal;
- (void)mParentId:(NSString *)parentId;
@optional
- (NSInteger)obtainItemType;
- (void)mType:(NSInteger)type;
- (void)mCheckVal:(BOOL)checkVal;
- (BOOL)obtainCheckVal;
- (NSInteger)obtainJoinMode;
- (NSString *) obtainItemModel;
- (void)mJoinMode:(NSInteger)mode;
- (NSString *)obtainParentCode;
- (void)mParentCode:(NSString *)parentCode;
@end
