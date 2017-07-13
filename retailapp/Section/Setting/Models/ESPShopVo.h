//
//  ESPShopVo.h
//  retailapp
//  东软 园区火掌柜入驻商圈使用的shopVo
//  Created by qingmei on 15/12/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESPShopVo : NSObject
/**经度 */
@property (nonatomic, strong) NSNumber *longtitude;
/**纬度*/
@property (nonatomic, strong) NSNumber *latitude;
/**备注*/
@property (nonatomic, strong) NSString *memo;
/**简介*/
@property (nonatomic, strong) NSString *introduce;
/**QQ*/
@property (nonatomic, strong) NSString *qq;
/**邮箱*/
@property (nonatomic, strong) NSString *email;
/**AppId */
@property (nonatomic, strong) NSString *appId;
/**实体ID*/
@property (nonatomic, strong) NSString *entityId;
/**实体编码 */
@property (nonatomic, strong) NSString *entityCode;
/**商户ID */
@property (nonatomic, strong) NSString *shopId;
/**商户名 */
@property (nonatomic, strong) NSString *shopName;
/**商户简称 */
@property (nonatomic, strong) NSString *shortName;
/**地址  */
@property (nonatomic, strong) NSString *address;
/**省份ID */
@property (nonatomic, strong) NSString *provinceId;
/**城市ID */
@property (nonatomic, strong) NSString *cityId;
/**区县ID */
@property (nonatomic, strong) NSString *countyId;
/**街道ID */
@property (nonatomic, strong) NSString *streetId;
/**联系人 */
@property (nonatomic, strong) NSString *linkman;
/**联系电话一 */
@property (nonatomic, strong) NSString *phone1;
/**联系电话二 */
@property (nonatomic, strong) NSString *phone2;
/**微信 */
@property (nonatomic, strong) NSString *weixin;
/**上级商户ID */
@property (nonatomic, strong) NSString *parentId;
/**商户代码 */
@property (nonatomic, strong) NSString *code;
/**营业时间*/
@property (nonatomic, strong) NSString *businessTime;
/**版本号*/
@property (nonatomic, strong) NSNumber *lastVer;
/**是否复制标志*/
@property (nonatomic, strong) NSString *CopyFlag;
/**营业开始时间*/
@property (nonatomic, strong) NSString *startTime;
/**营业结束时间*/
@property (nonatomic, strong) NSString *endTime;
/**店家类型*/
@property (nonatomic, strong) NSString *shopType;
/**连锁Id*/
@property (nonatomic, strong) NSString *brandId;
/**机构Id*/
@property (nonatomic, strong) NSString *orgId;
/**上级机构名称*/
@property (nonatomic, strong) NSString *orgName;
/**品牌Id*/
@property (nonatomic, strong) NSString *plateId;
/**行业  0餐饮  1零售*/
@property (nonatomic, strong) NSNumber *industry;
/**被复制商户id*/
@property (nonatomic, strong) NSString *dataFromShopId;
/**入驻商圈ID*/
@property (nonatomic, strong) NSString *settledMallId;
/**入驻申请时间*/
@property (nonatomic, strong) NSNumber *creatTime;
/**文件路径*/
@property (nonatomic, strong) NSString *fileName;
/**文件内容*/
@property (nonatomic, strong) NSString *file;
/**商户面积*/
@property (nonatomic, strong) NSString *area;
/**文件操作*/
@property (nonatomic, strong) NSString *fileOperate;

/**店家list*/
@property (nonatomic, strong) NSMutableArray *shopList;

- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
