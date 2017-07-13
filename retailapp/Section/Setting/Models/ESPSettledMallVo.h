//
//  SettledMallVo.h
//  retailapp
//
//  Created by qingmei on 15/12/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESPSettledMallVo : NSObject
/**id*/
@property (nonatomic, strong) NSNumber *Id;
/**商圈编号*/
@property (nonatomic, strong) NSString *code;
/**商圈名*/
@property (nonatomic, strong) NSString *shopName;
/**联系人*/
@property (nonatomic, strong) NSString *linkman;
/**联系电话*/
@property (nonatomic, strong) NSString *phone1;
/**会计期*/
@property (nonatomic, strong) NSString *reportCycle;

/**实体ID*/
@property (nonatomic, strong) NSString *entityId;
/**商店ID*/
@property (nonatomic, strong) NSString *shopId;
/**创建时间*/
@property (nonatomic, strong) NSString *createTime;
/**申请实体ID*/
@property (nonatomic, strong) NSString *agreeEntityId;
/**申请商店ID*/
@property (nonatomic, strong) NSString *agreeShopId;
/**申请商店名字*/
@property (nonatomic, strong) NSString *agreeShopName;
/**申请商店code*/
@property (nonatomic, strong) NSString *agreeShopCode;
/**开户行*/
@property (nonatomic, strong) NSString *bank;
/**银行账号*/
@property (nonatomic, strong) NSString *account;
/**开户名*/
@property (nonatomic, strong) NSString *accountName;
/**开户省份ID*/
@property (nonatomic, strong) NSString *provinceId;
/**开户城市ID*/
@property (nonatomic, strong) NSString *cityId;
/**开户支行*/
@property (nonatomic, strong) NSString *subBranch;

/**开户行*/
@property (nonatomic, strong) NSString *bankName;
/**开户支行中文名*/
@property (nonatomic, strong) NSString *subBranchName;
/**省份中文名*/
@property (nonatomic, strong) NSString *provinceName;
/**开户城市中文名*/
@property (nonatomic, strong) NSString *cityName;



/**协议编号*/
@property (nonatomic, strong) NSString *protocolCode;
/**协议照片*/
@property (nonatomic, strong) NSMutableArray *imageVoList;
/**申请时间*/
@property (nonatomic, strong) NSNumber *endTime;
/**到期时间*/
@property (nonatomic, strong) NSNumber *agreeTime;
/**结算周期*/
@property (nonatomic, strong) NSNumber *cycle;
/**允许查看营业数据*/
@property (nonatomic, strong) NSString *isLookData;
/**折扣率*/
@property (nonatomic, strong) NSNumber *ratio;
/**园区结算费率*/
@property (nonatomic, strong) NSNumber *settlementRatio;

/**状态*/
@property (nonatomic, strong) NSNumber *status;

/**文件*/
@property (nonatomic, strong) NSString *fileName;
/**文件*/
@property (nonatomic, strong) NSString *logofileName;


- (instancetype)initWithDictionary:(NSDictionary *)json;

@end
