//
//  ShowTypeVo.h
//  retailapp
//
//  Created by qingmei on 15/10/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowTypeVo : NSObject
/**显示区分*/
@property (nonatomic, assign) NSInteger showType;
/**显示区分名称*/
@property (nonatomic, strong) NSString *showTypeName;
/**排序码*/
@property (nonatomic, assign) NSInteger sortCode;
/**是否显示*/
@property (nonatomic, assign) NSInteger isShow;

+ (ShowTypeVo*)convertToUser:(NSDictionary*)dic;
- (NSMutableDictionary *)getDic:(ShowTypeVo *)showTypeVo;
@end
