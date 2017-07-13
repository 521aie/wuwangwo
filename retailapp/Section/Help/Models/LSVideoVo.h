//
//  LSVideoVo.h
//  retailapp
//
//  Created by guozhi on 2017/3/3.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSVideoVo : NSObject
/** <#注释#> */
@property (nonatomic, assign) int typeId;
/**  */
@property (nonatomic, copy) NSString *typeCode;
/**  */
@property (nonatomic, copy) NSString *vedioType;
/**  */
@property (nonatomic, strong) NSArray *vedioItems;
/**
 模型转换 传入一个字典list 返回一个对象list

 @param array 字典list
 @return 对象list
 */
+ (NSArray *)ls_objectArrayWithKeyValuesArray:(NSArray *)KeyValuesArray;
@end
