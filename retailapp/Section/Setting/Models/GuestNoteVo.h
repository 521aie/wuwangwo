//
//  GuestNoteVo.h
//  retailapp
//
//  Created by guozhi on 16/2/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuestNoteVo : NSObject
/**备注内容*/
@property (nonatomic, copy) NSString *name;
/**备注内容Id*/
@property (nonatomic, copy) NSString *dicItemId;
/**备注内容顺序码*/
@property (nonatomic, strong) NSNumber *sortCode;
/**值*/
@property (nonatomic, strong) NSNumber *val;
/**版本号*/
@property (nonatomic, strong) NSNumber *lastVer;
- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
