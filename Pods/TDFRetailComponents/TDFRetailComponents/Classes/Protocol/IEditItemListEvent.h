//
//  IEditItemListEvent.h
//  RestApp
//
//  Created by zxh on 14-4-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EditItemList;
@protocol IEditItemListEvent <NSObject>

@optional
- (void)onItemListClick:(id)obj;
@end
