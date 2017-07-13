//
//  LSUserBankVo.h
//  retailapp
//
//  Created by guozhi on 16/3/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSUserBankVo : NSObject
/**主键Id*/
@property (nonatomic, strong) NSNumber *userBankId;
/**实体Id*/
@property (nonatomic, copy) NSString *entityId;
/**用户Id*/
@property (nonatomic, copy) NSString *userId;
/**用户区分  1：员工  2：会员*/
@property (nonatomic, strong) NSNumber *userType;
/**银行名称  最大长度20*/
@property (nonatomic, copy) NSString *bankName;
/**开户名  最大长度20*/
@property (nonatomic, copy) NSString *accountName;
/**银行卡号  最大长度20*/
@property (nonatomic, copy) NSString *accountNumber;
/**省份Id*/
@property (nonatomic, copy) NSString *provinceId;
/**城市Id*/
@property (nonatomic, copy) NSString *cityId;
/**开户支行*/
@property (nonatomic, copy) NSString *branchName;
/**创建时间*/
@property (nonatomic, strong) NSNumber *createTime;
/**操作时间 */
@property (nonatomic, strong) NSNumber *opTime;
/**版本号  Integer*/
@property (nonatomic, strong) NSNumber *lastVer;
/**操作人Id*/
@property (nonatomic, copy) NSString *opUserId;
/**opUserId*/
@property (nonatomic, copy) NSString *lastFourNum;
/**区分选择哪个*/
@property (nonatomic, copy) NSString *bankVal;
+ (instancetype)userBankVoWithDict:(NSDictionary *)dict;
@end
