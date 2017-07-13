//
//  LSModuleModel.h
//  retailapp
//
//  Created by guozhi on 2016/11/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LSModuleModel : NSObject
/** 菜单名称 */
@property (nonatomic, copy) NSString *name;
/** 菜单详情 */
@property (nonatomic, copy) NSString *detail;
/** 菜单图片路径 */
@property (nonatomic, copy) NSString *path;
/** 菜单code */
@property (nonatomic, copy) NSString *code;
+(instancetype)moduleModelWithName:(NSString *)name detail:(NSString *)detail path:(NSString *)path code:(NSString *)code;
@end
