//
//  TracesVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TracesVo : NSObject

//跟踪信息
@property (nonatomic, copy) NSString *desc;

//派件或收件员
@property (nonatomic, copy) NSString *dispOrRecMan;

//派件或收件员编号
@property (nonatomic, copy) NSString *dispOrRecManCode;

//派件或收件员电话
@property (nonatomic, copy) NSString *dispOrRecManPhone;

//上一站或下一站
@property (nonatomic, copy) NSString *preOrNextSite;

//上一站或下一站编号
@property (nonatomic, copy) NSString *preOrNextSiteCode;

//上一站或下一站电话
@property (nonatomic, copy) NSString *preOrNextSitePhone;

//备注
@property (nonatomic, copy) NSString *remark;

//扫描时间
@property (nonatomic, copy) NSString *scanDate;

//扫描站点
@property (nonatomic, copy) NSString *scanSite;

//扫描站点编号
@property (nonatomic, copy) NSString *scanSiteCode;

//扫描站点电话
@property (nonatomic, copy) NSString *scanSitePhone;

//扫描类型
@property (nonatomic, copy) NSString *scanType;

//签收人
@property (nonatomic, copy) NSString *signMan;

+ (TracesVo *)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
