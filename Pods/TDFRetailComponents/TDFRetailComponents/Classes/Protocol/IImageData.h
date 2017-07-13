//
//  IImageData.h
//  RestApp
//
//  Created by 邵建青 on 15-1-31.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IImageData <NSObject>

@required
- (NSString *)obtainPath;

- (NSString *)obtainFilePath;

@end
