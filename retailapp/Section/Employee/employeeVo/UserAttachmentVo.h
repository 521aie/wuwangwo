//
//  UserAttachmentVo.h
//  retailapp
//
//  Created by qingmei on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAttachmentVo : NSObject
/**文件名*/
@property (nonatomic, strong) NSString *fileName;
/**文件*/
@property (nonatomic, strong) NSString *file;
/**排序码*/
@property (nonatomic, assign) NSInteger sortCode;
/**文件操作类型*/
@property (nonatomic, strong) NSString *fileOperate;
/**文件地址*/
@property (nonatomic, strong) NSString *filePath;
/**附件表id*/
@property (nonatomic, strong) NSString *attachmentId;


- (instancetype)initWithDictionary:(NSDictionary *)json;

+ (UserAttachmentVo*)convertToUser:(NSDictionary*)dic;

- (NSMutableDictionary *)getDic:(UserAttachmentVo *)userAttachmentVo;
@end
