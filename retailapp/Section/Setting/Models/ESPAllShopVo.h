//
//  ESPAllShopVo.h
//  retailapp
//
//  Created by qingmei on 15/12/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESPAllShopVo : NSObject
/**商户ID */
@property (nonatomic, strong) NSString *shopId;
/**商户名*/
@property (nonatomic, strong) NSString *shopName;
/**上级商户ID */
@property (nonatomic, strong) NSString *parentId;
/**商户编码*/
@property (nonatomic, strong) NSString *code;
/**文件名*/
@property (nonatomic, strong) NSString *fileName;
/**商户类型*/
@property (nonatomic, strong) NSNumber *shopType;

- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
