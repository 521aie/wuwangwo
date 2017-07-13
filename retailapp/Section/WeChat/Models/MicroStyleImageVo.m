//
//  MicroStyleImageVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroStyleImageVo.h"

@implementation MicroStyleImageVo

- (NSString *)obtainPath
{
    return self.fileName;
}

- (NSString*) obtainFilePath
{
    return self.filePath;
}

+(MicroStyleImageVo*)convertToMicroStyleImageVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        MicroStyleImageVo* microStyleImageVo = [[MicroStyleImageVo alloc] init];
        microStyleImageVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        microStyleImageVo.file = [ObjectUtil getStringValue:dic key:@"file"];
        microStyleImageVo.color = [ObjectUtil getStringValue:dic key:@"color"];
        microStyleImageVo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        
        return microStyleImageVo;
    }
    return nil;
}

+(NSDictionary*)getDictionaryData:(MicroStyleImageVo *)microStyleImageVo
{
    if ([ObjectUtil isNotNull:microStyleImageVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"fileName" val:microStyleImageVo.fileName];
        [ObjectUtil setStringValue:data key:@"file" val:microStyleImageVo.file];
        [ObjectUtil setStringValue:data key:@"color" val:microStyleImageVo.color];
        [ObjectUtil setStringValue:data key:@"filePath" val:microStyleImageVo.filePath];
        
        return data;
    }
    return nil;
}

@end
