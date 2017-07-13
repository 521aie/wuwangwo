//
//  MicroGoodsImageVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroGoodsImageVo.h"
#import "ObjectUtil.h"

@implementation MicroGoodsImageVo

- (NSString *)obtainPath
{
    return self.fileName;
}

- (NSString *)obtainFilePath
{
    return self.filePath;
}

+ (MicroGoodsImageVo *)convertToMicroGoodsImageVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        MicroGoodsImageVo* microGoodsImageVo = [[MicroGoodsImageVo alloc] init];
        microGoodsImageVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        microGoodsImageVo.file = [ObjectUtil getStringValue:dic key:@"file"];
        microGoodsImageVo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        microGoodsImageVo.color = [ObjectUtil getStringValue:dic key:@"color"];
        microGoodsImageVo.colorId = [ObjectUtil getStringValue:dic key:@"colorId"];
        microGoodsImageVo.homePageId = [ObjectUtil getStringValue:dic key:@"homePageId"];
        
        return microGoodsImageVo;
    }
    
    return nil;
}

+ (NSDictionary *)getDictionaryData:(MicroGoodsImageVo *)microGoodsImageVo
{
    if ([ObjectUtil isNotNull:microGoodsImageVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"fileName" val:microGoodsImageVo.fileName];
        [ObjectUtil setStringValue:data key:@"file" val:microGoodsImageVo.file];
        [ObjectUtil setStringValue:data key:@"filePath" val:microGoodsImageVo.filePath];
        [ObjectUtil setStringValue:data key:@"color" val:microGoodsImageVo.color];
        [ObjectUtil setStringValue:data key:@"colorId" val:microGoodsImageVo.colorId];
        [ObjectUtil setStringValue:data key:@"homePageId" val:microGoodsImageVo.homePageId];
        [ObjectUtil setShortValue:data key:@"opType" val:microGoodsImageVo.opType];
        return data;
    }
    return nil;
}

@end
