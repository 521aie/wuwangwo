//
//  SkcStyleVo.h
//  retailapp
//
//  Created by hm on 15/10/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkcStyleVo : NSObject
@property (nonatomic, copy) NSString *styleId;
@property (nonatomic, copy) NSString *styleCode;
@property (nonatomic, copy) NSString *styleName;
@property (nonatomic, copy) NSString *filePath;
//进货、退货价
@property (nonatomic, strong) NSNumber *stylePrice;
@property (nonatomic, strong) NSNumber *hangTagPrice;
/** 上下架 1上架 2下架 */
@property (nonatomic, strong) NSNumber *styleStatus;
@property (nonatomic, strong) NSArray *sizeNameList;
@property (nonatomic, strong) NSArray *skcList;

+ (SkcStyleVo *)converToVo:(NSDictionary *)dic;
@end
