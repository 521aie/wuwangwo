//
//  AllShopVo.h
//  retailapp
//
//  Created by hm on 15/10/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameCode.h"
#import "IMultiNameValueItem.h"
@interface AllShopVo : NSObject<INameCode,IMultiNameValueItem>
/**门店ID*/
@property (nonatomic,copy) NSString* shopId;
@property (nonatomic,copy) NSString* shopEntityId;
/**机构id*/
@property (nonatomic,copy) NSString* orgId;
/**门店名称*/
@property (nonatomic,copy) NSString* shopName;
/**门店编码*/
@property (nonatomic,copy) NSString* code;
/**1 门店 2仓库*/
@property (nonatomic,assign) short shopType;
@property (nonatomic,copy) NSString* operateType;
@property (nonatomic,assign) BOOL checkVal;

+ (AllShopVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;
+ (NSMutableDictionary *)converToDic:(AllShopVo *)shopVo;
+ (NSMutableArray *)converObjArrToDicArr:(NSMutableArray *)sourceList;
@end
