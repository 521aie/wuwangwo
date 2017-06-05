//
//  LSStaffHandoverPayTypeVo.m
//  retailapp
//
//  Created by guozhi on 2016/11/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStaffHandoverPayTypeVo.h"
#import "MJExtension.h"

@implementation LSStaffHandoverPayTypeVo

+ (NSArray *)getStaffHandoverPayTypeVoList:(NSArray *)keyValuesArray {
    
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
};

- (void)mj_keyValuesDidFinishConvertingToObject {
    self.staffId = [NSString isBlank:self.staffId]?@"":self.staffId;
    self.staffName = [NSString isBlank:self.staffName]?@"":self.staffName;
    self.staffRole = [NSString isBlank:self.staffRole]?@"":self.staffRole;
}

@end
