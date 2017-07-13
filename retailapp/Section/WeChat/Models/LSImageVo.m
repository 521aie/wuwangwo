//
//  LSImageVo.m
//  retailapp
//
//  Created by guozhi on 16/8/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSImageVo.h"
@interface LSImageVo()
/**
 *  文件名称
 */
@property (nonatomic, copy) NSString *fileName;
/**
 *  操作类型  UPLOAD(1,"上传"), DELETE(2,"删除");
 */
@property (nonatomic, assign) int  opType;
/**
 *  业务 codepublic enum Type {
 GOODS           ("goods",""),
 STYLE           ("style",""),
 MEMBER          ("member",""),
 SHOP            ("shop",""),
 NOTICE          ("notice",""),
 UNIT            ("unit",""),
 ACTIVITY        ("activity",""),
 USER            ("user",""),
 SETTLEMALL      ("settlemall",""),
 PROPERTY        ("property",""),
 COMPANION_QRCODE("companion_qrcode","");
 */
@property (nonatomic, copy) NSString *type;

@end
@implementation LSImageVo
+ (instancetype)imageVoWithFileName:(NSString *)fileName opType:(int)opType type:(NSString *)type {
    LSImageVo *imageVo = [[LSImageVo alloc] init];
    imageVo.fileName = fileName;
    imageVo.opType = opType;
    imageVo.type = type;
    return imageVo;
}

- (NSString *)obtainFileName {
    return self.fileName;
}
@end
