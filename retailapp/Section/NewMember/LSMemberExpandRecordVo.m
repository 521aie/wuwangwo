//
//  LSMeberExpandRecordVo.m
//  retailapp
//
//  Created by taihangju on 2016/10/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberExpandRecordVo.h"
#import "MJExtension.h"
#import "DateUtils.h"
@implementation LSMemberExpandRecordVo

+ (NSArray *)getMemberExpandRecordList:(NSArray *)dicArr {
    
    return [self mj_objectArrayWithKeyValuesArray:dicArr];
}

- (NSString *)timeString {
    if (!_timeString) {
        NSString *time = [DateUtils formateLongChineseTime:self.createTime.longLongValue];
        _timeString = [time substringWithRange:NSMakeRange(0, 8)];
    }
    return _timeString;
}
- (NSString *)expandTimeString {
    return [DateUtils formateLongChineseTime:self.createTime.longLongValue];
}
@end
