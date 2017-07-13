//
//  EditItemChange.h
//  RestApp
//
//  Created by zxh on 14-4-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EditItemChange <NSObject>

@required
-(void) clearChange;
@end
