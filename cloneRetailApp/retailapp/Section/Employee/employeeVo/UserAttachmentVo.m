//
//  UserAttachmentVo.m
//  retailapp
//
//  Created by qingmei on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "UserAttachmentVo.h"

@implementation UserAttachmentVo

- (instancetype)initWithDictionary:(NSDictionary *)json{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
}

+ (UserAttachmentVo*)convertToUser:(NSDictionary*)dic{
    
    if ([ObjectUtil isNotEmpty:dic]) {
        
        UserAttachmentVo *userAttachmentVo = [[UserAttachmentVo alloc]init];
        
        userAttachmentVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        userAttachmentVo.file = [ObjectUtil getStringValue:dic key:@"file"];
        userAttachmentVo.sortCode = [ObjectUtil getIntegerValue:dic key:@"sortCode"];
        userAttachmentVo.fileOperate = [ObjectUtil getStringValue:dic key:@"fileOperate"];
        userAttachmentVo.attachmentId = [ObjectUtil getStringValue:dic key:@"attachmentId"];
        userAttachmentVo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
       
        return userAttachmentVo;
    }
    return nil;
}

- (NSMutableDictionary *)getDic:(UserAttachmentVo *)userAttachmentVo{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ObjectUtil isNull:userAttachmentVo.fileName]?[NSNull null]:userAttachmentVo.fileName forKey:@"fileName"];
    [dic setValue:[ObjectUtil isNull:userAttachmentVo.file]?[NSNull null]:userAttachmentVo.file forKey:@"file"];
    [dic setValue:[ObjectUtil isNull:userAttachmentVo.fileOperate]?[NSNull null]:userAttachmentVo.fileOperate forKey:@"fileOperate"];
    [dic setValue:[NSNumber numberWithInteger:userAttachmentVo.sortCode] forKey:@"sortCode"];
    [dic setValue:[ObjectUtil isNull:userAttachmentVo.attachmentId]?[NSNull null]:userAttachmentVo.attachmentId forKey:@"attachmentId"];
   
    [dic setValue:[ObjectUtil isNull:userAttachmentVo.filePath]?[NSNull null]:userAttachmentVo.filePath forKey:@"filePath"];
    
    
    return dic;

}
@end
