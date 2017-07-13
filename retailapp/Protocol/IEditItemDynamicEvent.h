//
//  IEditItemDynamicEvent.h
//  retailapp
//
//  Created by qingmei on 15/9/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EditItemDynamic;

@protocol IEditItemDynamicEvent <NSObject>

@optional
-(void) onItemClick:(EditItemDynamic*)obj;

@end


