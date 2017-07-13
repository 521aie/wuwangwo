//
//  LSImageVo.h
//  retailapp
//
//  Created by guozhi on 16/8/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSImageVo : NSObject

+ (instancetype)imageVoWithFileName:(NSString *)fileName opType:(int)opType type:(NSString *)type;

- (NSString *)obtainFileName;
@end
