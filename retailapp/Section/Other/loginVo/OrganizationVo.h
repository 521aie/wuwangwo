//
//  OrganizationVo.h
//  retailapp
//
//  Created by hm on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValue.h"

@interface OrganizationVo : NSObject<INameValue>
/**实体Id*/
@property (nonatomic,copy) NSString* entityId;
/**组织机构Id*/
@property (nonatomic,copy) NSString* organizationId;
/**组织机构名称*/
@property (nonatomic,copy) NSString* name;
/**机构编码*/
@property (nonatomic,copy) NSString* code;
/**机构类型 0公司  1部门  2门店*/
@property (nonatomic,assign) NSInteger type;
/**上级机构Id*/
@property (nonatomic,copy) NSString* parentId;
/**上级机构名称*/
@property (nonatomic,copy) NSString* parentName;
/**1:直营  0:加盟*/
@property (nonatomic,assign) NSInteger joinMode;
/**附件ID*/
@property (nonatomic,copy) NSString* attachmentId;
/**省*/
@property (nonatomic,copy) NSString* provinceId;
/**市*/
@property (nonatomic,copy) NSString* cityId;
/**县或区*/
@property (nonatomic,copy) NSString* countyId;
/**详细地址*/
@property (nonatomic,copy) NSString* address;
/**联系人*/
@property (nonatomic,copy) NSString* linkman;
/**手机号*/
@property (nonatomic,copy) NSString* mobile;
/**电话*/
@property (nonatomic,copy) NSString* tel;
/**文件内容*/
@property (nonatomic,copy) NSString* file;
/**图片名称*/
@property (nonatomic,copy) NSString* fileName;
/**文件操作*/
@property (nonatomic,strong) NSNumber* fileOperate;
/**排序码*/
@property (nonatomic,assign) NSInteger sortCode;
/**连锁Id*/
@property (nonatomic,copy) NSString* brandId;
/**拼写*/
@property (nonatomic,copy) NSString* spell;

@property (nonatomic,copy) NSString* appId;
/**层级code*/
@property (nonatomic,copy) NSString* hierarchyCode;
/**下属数量*/
@property (nonatomic,assign) NSInteger sonCount;
/**版本号*/
@property (nonatomic,assign) NSInteger lastVer;

//允许向下级供货开关 0 关闭  1开启
@property (nonatomic,copy) NSString* allowSupply;
/**向指定公司采购开关 1 启用 2 关闭*/
@property (nonatomic,copy) NSString* appointCompany;
/**指定供应商列表*/
@property (nonatomic, strong) NSMutableArray *purchaseSupplyVoList;

+ (OrganizationVo*)convertToOrganization:(NSDictionary*)dic;

+ (NSDictionary*)getDictionaryData:(OrganizationVo*)orgVo;

+ (NSMutableArray*)getArrayData:(NSArray*)arr;

@end
