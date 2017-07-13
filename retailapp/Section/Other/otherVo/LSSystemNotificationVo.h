//
//  LSSystemNotificationVo.h
//  retailapp
//
//  Created by guozhi on 2016/11/3.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSystemNotificationVo : NSObject
/** <#注释#> */
@property (nonatomic, copy) NSString *id;
/** <#注释#> */
@property (nonatomic, assign) int lastVer;
/** <#注释#> */
@property (nonatomic, assign) int notifyKind;
/** <#注释#> */
@property (nonatomic, copy) NSString *name;
/** <#注释#> */
@property (nonatomic, copy) NSString *memo;
/** <#注释#> */
@property (nonatomic, copy) NSString *attachmentId;
/** <#注释#> */
@property (nonatomic, copy) NSString *server;
/** <#注释#> */
@property (nonatomic, copy) NSString *path;
/** <#注释#> */
@property (nonatomic, copy) NSString *opUserId;
/** <#注释#> */
@property (nonatomic, assign) int isValid;
/** <#注释#> */
@property (nonatomic, assign) long long createTime;
/** <#注释#> */
@property (nonatomic, assign) long long opTime;
/** <#注释#> */
@property (nonatomic, assign) int industry;
/** <#注释#> */
/** <#注释#> */
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat height;
@end
