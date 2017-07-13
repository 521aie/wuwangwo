//
//  LSDealRecordVo.h
//  retailapp
//
//  Created by guozhi on 2017/3/29.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSDealRecordVo : NSObject
/** 操作名称 */
@property (nonatomic, copy) NSString *name;
/** 操作时间 */
@property (nonatomic, copy) NSString *opTime;
/** 操作人 */
@property (nonatomic, copy) NSString *opUser;
/** 操作类型 */
@property (nonatomic, copy) NSString *opType;
+ (NSArray *)dealRecordVoWithArray:(NSArray *)array;
@end
