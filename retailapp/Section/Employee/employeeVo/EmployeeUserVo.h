//
//  EmployeeUserVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserHandoverVo.h"
#import "HandoverPayTypeVo.h"
#import "UserAttachmentVo.h"

@interface EmployeeUserVo : NSObject

/**用户ID*/
@property (nonatomic, strong) NSString *userId;
/**登录名*/
@property (nonatomic, strong) NSString *userName;
/**姓名*/
@property (nonatomic, strong) NSString *name;
/**工号*/
@property (nonatomic, strong) NSString *staffId;
/**进公司时间*/
@property (nonatomic, assign) long long inDate;


/**手机号*/
@property (nonatomic, strong) NSString *mobile;
/**性别*/
@property (nonatomic, assign) NSInteger sex;
/**生日*/
@property (nonatomic, assign) NSInteger birthday;
/**证件号码*/
@property (nonatomic, strong) NSString *identityNo;
/**证件类型*/                             
@property (nonatomic, assign) NSInteger identityTypeId;


/**地址*/
@property (nonatomic, strong) NSString *address;
/**商户ID*/
@property (nonatomic, strong) NSString *shopId;
/*商户编码*/
@property (nonatomic, strong) NSString *shopCode;
/**商户类型*/ //1、门店 2、机构
@property (nonatomic, assign) NSInteger shopType;
/**商户名*/
@property (nonatomic, strong) NSString *shopName;
/**角色ID*/
@property (nonatomic, strong) NSString *roleId;
/**登录密码*/
@property (nonatomic, strong) NSString *pwd;
/**检索条件*/
@property (nonatomic, strong) NSString *keyWord;


/**版本号*/
@property (nonatomic, assign) NSInteger lastVer;
/**交接班Vo*/
@property (nonatomic, strong) UserHandoverVo *userHandoverVo;
/**角色名*/
@property (nonatomic, strong) NSString *roleName;
/**交接班支付类型List*/
@property (nonatomic, strong) NSArray *handoverPayTypeList;

/**文件名*/
@property (nonatomic, strong) NSString *fileName;
/**文件内容*/
@property (nonatomic, strong) NSData *file;
/**文件操作*/
@property (nonatomic, assign) NSInteger fileOperate;

/**attachmentList*/
@property (nonatomic, strong) NSMutableArray *userAttachmentList;
@property (nonatomic, strong) NSString *shopEntityId;/**<添加员工时上传:员工关联的实体id>*/

- (instancetype)initWithDictionary:(NSDictionary *)dic;

+ (EmployeeUserVo*)convertToUser:(NSDictionary*)dic;

- (NSMutableDictionary *)getDic:(EmployeeUserVo *)employeeUserVo;

@end
