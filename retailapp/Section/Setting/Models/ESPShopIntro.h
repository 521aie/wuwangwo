//
//  ESPShopIntro.h
//  retailapp
//
//  Created by qingmei on 15/12/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESPShopIntro : NSObject
/**实体ID*/
@property (nonatomic, strong) NSString *entityId;
/**会计期*/
@property (nonatomic, strong) NSString *reportCycle;
/**商户ID*/
@property (nonatomic, strong) NSString *shopId;
/**商户名 */
@property (nonatomic, strong) NSString *shopName;
/**联系人*/
@property (nonatomic, strong) NSString *linkman;
/**联系电话一*/
@property (nonatomic, strong) NSString *phone1;
/**文件路径*/
@property (nonatomic, strong) NSString *fileName;

- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
