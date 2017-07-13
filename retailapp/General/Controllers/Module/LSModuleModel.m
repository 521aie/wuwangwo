//
//  LSModuleModel.m
//  retailapp
//
//  Created by guozhi on 2016/11/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSModuleModel.h"
@implementation LSModuleModel
+(instancetype)moduleModelWithName:(NSString *)name detail:(NSString *)detail path:(NSString *)path code:(NSString *)code {
    LSModuleModel *moduleModel = [[LSModuleModel alloc] init];
    moduleModel.name = name;
    moduleModel.detail = detail;
    moduleModel.path = path;
    moduleModel.code = code;
    return moduleModel;
}
@end
