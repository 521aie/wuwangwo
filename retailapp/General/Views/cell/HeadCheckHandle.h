//
//  HeadCheckHandle.h
//  RestApp
//
//  Created by zxh on 14-10-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"

@protocol HeadCheckHandle <NSObject>

- (void)checkHead:(BOOL)result head:(id<INameValueItem>)head;

@end
