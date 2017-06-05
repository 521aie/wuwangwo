//
//  LSCommonProblemListVo.h
//  retailapp
//
//  Created by guozhi on 2017/3/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCommonProblemListVo : NSObject
/** 分类Id */
@property (nonatomic, copy) NSString *id;
/** 分类名称 */
@property (nonatomic, copy) NSString *solution;
/** <#注释#> */
@property (nonatomic, copy) NSString *titleName;
+ (NSArray *)ls_objectArrayWithKeyValuesArray:(NSArray *)array;
+ (instancetype)ls_objectWithKeyValues:(NSDictionary *)keyValues;
@end
