//
//  DicVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"

@interface DicVo : Jastor <INameValueItem>
/**版本号*/
@property (nonatomic, strong) NSString *name;   //名称
/**版本号*/
@property (nonatomic, assign) NSInteger val;    //值

+ (NSMutableArray *)converToArr:(NSArray*)sourceList;

@end
