//
//  IEditItemMemoEvent.h
//  RestApp
//
//  Created by zxh on 14-4-18.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EditItemMemo;
@protocol IEditItemMemoEvent <NSObject>

@optional
-(void) onItemMemoListClick:(EditItemMemo*)obj;


@end

