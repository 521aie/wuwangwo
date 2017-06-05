//
//  LSMemberInfoVo.h
//  retailapp
//
//  Created by byAlex on 16/9/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

// //火小二资料
@interface LSMemberRegisterVo : NSObject

@property (nonatomic ,strong) NSString *sId;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *mobile;/* <手机号*/
@property (nonatomic ,strong) NSString *name;/* <<#desc#>*/
@property (nonatomic ,strong) NSNumber *sex;/* <1:男 2：女*/
@property (nonatomic ,strong) NSString *spell;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *birthday;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *birthdayStr;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *pwd;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *saleAddressId;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *address;/* <<#desc#>*/
@property (nonatomic ,strong) NSNumber *isVerified;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *path;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *server;/* <<#desc#>*/
@property (nonatomic ,strong) NSNumber *lastVer;/* <<#desc#>*/
@property (nonatomic ,strong) NSNumber *isValid;/* <<#desc#>*/
@property (nonatomic ,strong) NSNumber *opTime;/* <<#desc#>*/

+ (LSMemberRegisterVo *)getMemberRegisterVo:(NSDictionary *)dic;
@end

// 会员补充信息
@interface LSMemberInfoVo : NSObject

@property (nonatomic ,strong) NSString *sId;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *s_Id;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *entityId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *consumeNum;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *lastConsumeTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *consumeAmount;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *memo;/*<备注>*/
@property (nonatomic ,strong) NSString *photo;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *email;/*<邮箱>*/
@property (nonatomic ,strong) NSString *zipcode;/*<邮编>*/
@property (nonatomic ,strong) NSString *address;/* <地址*/
@property (nonatomic ,strong) NSString *mobile;/* <手机号*/
@property (nonatomic ,strong) NSString *phone;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *pos;/*职务>*/
@property (nonatomic ,strong) NSString *job;/*<职业>*/
@property (nonatomic ,strong) NSString *weixin;/*<微信号>*/
@property (nonatomic ,strong) NSString *carNo;/*<车牌号>*/
@property (nonatomic ,strong) NSString *company;/*<公司>*/
@property (nonatomic ,strong) NSNumber *sex;/* <1:男 2：女*/
@property (nonatomic ,strong) NSNumber *birthday;/* <生日*/
@property (nonatomic ,strong) NSString *birthdayStr;/* <<#desc#>*/
@property (nonatomic ,strong) NSString *name;/* <会员名*/
@property (nonatomic ,strong) NSString *certificate;/*<身份证>*/
@property (nonatomic ,strong) NSString *num_id;/*<<#说明#>>*/

@property (nonatomic ,strong) NSString *spell;/* <<#desc#>*/
@property (nonatomic ,strong) NSArray *cards;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *keyword;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *cacheExpireTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *orign_Id;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *lastVer;/* <<#desc#>*/
@property (nonatomic ,strong) NSNumber *isValid;/* <<#desc#>*/
@property (nonatomic ,strong) NSNumber *opTime;/* <<#desc#>*/
@property (nonatomic ,strong) NSNumber *createTime;/*<<#说明#>>*/

+ (LSMemberInfoVo *)getMemberVo:(NSDictionary *)dic;
- (NSString *)memberInfoJsonString;
@end

//会员火小二资料
@interface LSMemberRegisterPojo : NSObject

@property (nonatomic ,strong) NSString *address;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *attachmentId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *contryCode;
@property (nonatomic ,strong) NSNumber *contryId;
@property (nonatomic ,strong) NSString *birthday;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *extendFields;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *sId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isValid;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *lastVer;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *mobile;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *name;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *nickName;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *opTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *path;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *picFullPath;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *pwd;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *saleAddressId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *server;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *sex;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *spell;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *url;/*<<#说明#>>*/
@end

// 会员微信资料
@interface LSMemberRegisterThirdPartyPojo : NSObject

@property (nonatomic ,strong) NSString *createTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *customerRegisterId;/*<<#说明#>>*/
@property (nonatomic ,strong) LSMemberRegisterPojo *customerRegisterPojo;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *extendFields;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *sId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isValid;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *lastVer;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *nickName;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *oldCustomerRegisterId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *opTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *sex;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *thirdPartyId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *type;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *url;/*<<#说明#>>*/
@end

// queryCustomerInfo 返回的信息对应的Model
@interface LSMemberPackVo : NSObject

@property (nonatomic ,strong) NSString *customerRegisterId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *birthday;/*<<#说明#>>*/
@property (nonatomic ,strong) NSArray *cardNames;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *createTime;/*<<#说明#>>*/
@property (nonatomic ,strong) LSMemberInfoVo *customer;/*<<#说明#>>*/
@property (nonatomic ,strong) LSMemberRegisterThirdPartyPojo *customerRegisterThirdPartyPojo;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *imgPath;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *mobile;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *name;/*<<#说明#>>*/

- (NSString *)getMemberPhoneNum;
+ (LSMemberPackVo *)getMemberPackVo:(NSDictionary *)dic;
+ (NSArray *)getMemberPackVoList:(NSArray *)array;
@end
