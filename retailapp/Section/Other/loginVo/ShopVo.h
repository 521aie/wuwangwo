//
//  ShopVo.h
//  retailapp
//
//  Created by hm on 15/8/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValue.h"

@interface ShopVo : NSObject<INameValue>
/**商户ID*/
@property (nonatomic,copy) NSString *shopId;
/**实体ID*/
@property (nonatomic,copy) NSString *entityId;
/**门店实体Id*/
@property (nonatomic,copy) NSString *shopEntityId;
/**实体编码*/
@property (nonatomic,copy) NSString *entityCode;
/**上级商户ID*/
@property (nonatomic,copy) NSString *parentId;
/**店铺名称*/
@property (nonatomic,copy) NSString *shopName;
/**店铺类型*/
@property (nonatomic,copy) NSString *shopType;
/**店铺简称*/
@property (nonatomic,copy) NSString *shortName;
/**<店家介绍>*/
@property (nonatomic ,copy) NSString *introduce;
/**上级机构id*/
@property (nonatomic,copy) NSString *orgId;
/**上级机构名称*/
@property (nonatomic,copy) NSString *orgName;
/**所属行业*/
@property (nonatomic,strong) NSNumber *profession;
/**省*/
@property (nonatomic,copy) NSString *provinceId;
/**市*/
@property (nonatomic,copy) NSString *cityId;
/**县/区*/
@property (nonatomic,copy) NSString *countyId;
/**详细地址*/
@property (nonatomic,copy) NSString *address;
/**面积*/
@property (nonatomic,strong) NSNumber *area;
/**联系人*/
@property (nonatomic,copy) NSString *linkman;
/**手机号码*/
@property (nonatomic,copy) NSString *phone1;
/**电话号码*/
@property (nonatomic,copy) NSString *phone2;
/**微信*/
@property (nonatomic,copy) NSString *weixin;
/**营业开始时间*/
@property (nonatomic,copy) NSString *startTime;
/**营业结束时间*/
@property (nonatomic,copy) NSString* endTime;
/**营业时间*/
@property (nonatomic,copy) NSString *businessTime;
/**文件内容*/
@property (nonatomic,copy) NSString *file;
/**文件名称*/
@property (nonatomic,copy) NSString *fileName;
/**文件操作*/
@property (nonatomic,strong) NSNumber *fileOperate;
/**附件ID*/
@property (nonatomic,copy) NSString *attachmentId;

@property (nonatomic,copy) NSString *appId;
/**连锁Id*/
@property (nonatomic,copy) NSString *brandId;
/**商户代码*/
@property (nonatomic,copy) NSString *code;
/**是否复制标志*/
@property (nonatomic,copy) NSString *flag;
/**被复制商户id*/
@property (nonatomic,copy) NSString *dataFromShopId;
/**向指定公司采购开关 1 启用 2 关闭*/
@property (nonatomic,copy) NSString *appointCompany;
/**行业: 0餐饮  1零售*/
@property (nonatomic,assign) NSInteger industry;
/**版本号*/
@property (nonatomic,assign) NSInteger lastVer;

@property (nonatomic, strong) NSMutableArray *purchaseSupplyVoList;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *mainImageVoList;

@property (nonatomic) BOOL checkVal;

+ (ShopVo*)convertToShop:(NSDictionary*)dic;
+ (NSDictionary*)getDictionaryData:(ShopVo*)shopVo;
@end
