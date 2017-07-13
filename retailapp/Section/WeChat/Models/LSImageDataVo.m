//
//  LSImageDataVo.m
//  retailapp
//
//  Created by guozhi on 16/8/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSImageDataVo.h"

@implementation LSImageDataVo
+ (instancetype)imageDataVoWithData:(NSData *)data file:(NSString *)file {
    LSImageDataVo *imageDataVo = [[LSImageDataVo alloc] init];
    imageDataVo.data = data;
    imageDataVo.file = file;
    return imageDataVo;
}
@end
