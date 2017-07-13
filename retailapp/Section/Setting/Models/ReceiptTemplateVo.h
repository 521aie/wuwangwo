//
//  ReceiptTemplateVo.h
//  retailapp
//
//  Created by hm on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameItem.h"

@interface ReceiptTemplateVo : NSObject<INameItem>

@property (nonatomic,copy) NSString* templateName;

@property (nonatomic,copy) NSString* templateCode;


+ (ReceiptTemplateVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
