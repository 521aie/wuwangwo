//
//  ImageVo.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ImageVo.h"

@implementation ImageVo

- (NSString *)obtainPath
{
    return self.fileName;
}

- (NSString*) obtainFilePath
{
    return self.filePath;
}

+ (ImageVo*)converToVo:(NSDictionary*)dic {
    if ([ObjectUtil isNotEmpty:dic]) {
        ImageVo* imageVo = [[ImageVo alloc] init];
        imageVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
//        if ([ObjectUtil isNotNull:dic[@"file"]]) {
//            imageVo.file = dic[@"file"];
//        }
        imageVo.file = [ObjectUtil getStringValue:dic key:@"file"];
        imageVo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        imageVo.objectId = [ObjectUtil getStringValue:dic key:@"imageId"];
        imageVo.frontBack = [ObjectUtil getShortValue:dic key:@"frontBack"];
        imageVo.isChanged = NO;
        return imageVo;
    }
    
    return nil;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList {
    if ([ObjectUtil isEmpty:sourceList]) {
        return nil;
    }
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            ImageVo* imageVo = [ImageVo converToVo:dic];
            [dataList addObject:imageVo];
        }
    }
    return dataList;
}

@end
