//
//  ReturnGoodsGuideVo.h
//  retailapp
//
//  Created by guozhi on 15/11/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnGoodsGuideVo : NSObject
/**退货指导名称*/
@property (nonatomic, copy) NSString *name;
/**指导编号*/
@property (nonatomic, copy) NSString *code;
/**指导id*/
@property (nonatomic, copy) NSString *guideId;
/**开始时间*/
@property (nonatomic, strong) NSNumber *startDate;
/**结束时间*/
@property (nonatomic, strong) NSNumber *endDate;
@property (nonatomic, strong) NSMutableArray *returnGuideListVos;

- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
