//
//  SmsTemplateVo.h
//  retailapp
//
//  Created by guozhi on 2016/11/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmsTemplateVo : NSObject
/** <#注释#> */
@property (nonatomic, assign) short sort;
/** <#注释#> */
@property (nonatomic, copy) NSString *code;
/** 模板标题 */
@property (nonatomic, copy) NSString *title;
/** 模板内容 */
@property (nonatomic, copy) NSString *content;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *fields;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *fieldsMapList;
@end
