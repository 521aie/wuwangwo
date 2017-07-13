//
//  Notice.h
//  retailapp
//
//  Created by hm on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject

@property (nonatomic,copy) NSString* noticeId;

@property (nonatomic,copy) NSString* currShopId;

@property (nonatomic,copy) NSString* targetShopId;

@property (nonatomic,copy) NSString* targetShopName;

@property (nonatomic,copy) NSString* noticeTitle;

@property (nonatomic,copy) NSString* noticeContent;

@property (nonatomic) long long publishTime;

@property (nonatomic) NSInteger lastVer;

@property (nonatomic) short status;

+(Notice*)converToNotice:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;
+ (NSDictionary*)converToDic:(Notice*)notice;

@end
