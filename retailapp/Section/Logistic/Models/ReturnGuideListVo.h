//
//  ReturnGuideListVo.h
//  retailapp
//
//  Created by guozhi on 15/11/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnGuideListVo : NSObject
/**款式名称*/
@property (nonatomic, copy) NSString *styleName;
/**款号*/
@property (nonatomic, copy) NSString *styleCode;
/**可退总量*/
@property (nonatomic, strong) NSNumber *returnAbleCount;
/**当前可退总量*/
@property (nonatomic, strong) NSNumber *nowReturnAbleCount;

- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
