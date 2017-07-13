//
//  LSUserHandoverVo.h
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSUserHandoverVo : NSObject

/** <#注释#> */
@property (nonatomic, copy) NSString *id;
/** <#注释#> */
@property (nonatomic, copy) NSString *entityId;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopEntityId;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopId;
/** <#注释#> */
@property (nonatomic, copy) NSString *userId;
/** 开始工作时间 Long */
@property (nonatomic, strong) NSNumber *startWorkTime;
/** 结束工作时间 Long */
@property (nonatomic, strong) NSNumber *endWorkTime;
/** 收银单数 Integer */
@property (nonatomic, strong) NSNumber *orderNumber;
/** 销售数量 BigDecimal */
@property (nonatomic, strong) NSNumber *saleGoodsNumber;
/** 总应收金额 BigDecimal */
@property (nonatomic, strong) NSNumber *totalResultAmount;
/** 总实收金额 */
@property (nonatomic, strong) NSNumber *totalRecieveAmount;
/** 销售应收总价 */
@property (nonatomic, strong) NSNumber *resultAmount;
/** 销售实收总价 */
@property (nonatomic, strong) NSNumber *recieveAmount;
/** 折后总费用/销售金额 */
@property (nonatomic, strong) NSNumber *discountAmount;
/** 充值金额 BigDecimal */
@property (nonatomic, strong) NSNumber *chargeAmount;
/** 赠送金额 BigDecimal */
@property (nonatomic, strong) NSNumber *presentAmount;
/** 退货单数 Integer */
@property (nonatomic, strong) NSNumber *returnOrderNumber;
/** 提成 BigDecimal */
@property (nonatomic, strong) NSNumber *royalties;
/** 退单金额 BigDecimal */
@property (nonatomic, strong) NSNumber *returnAmount;
/** 储值充值金额 */
@property (nonatomic, strong) NSNumber *chargeStoreAmount;
/** 储值充值单数 */
@property (nonatomic, strong) NSNumber *chargeStoreNumber;
/** 会员卡退卡 */
@property (nonatomic, strong) NSNumber *chargeReturnAmount;
/** 退卡单数 */
@property (nonatomic, strong) NSNumber *chargeReturnNumber;
/** 计次充值 */
@property (nonatomic, strong) NSNumber *chargeAccAmount;
/** 计次充值单数 */
@property (nonatomic, strong) NSNumber *chargeAccNumber;
/** 计次服务退款 */
@property (nonatomic, strong) NSNumber *chargeAccReturnAmount;
/** 计次退款单数 */
@property (nonatomic, strong) NSNumber *chargeAccReturnNumber;
/** 不计入销售额 */
@property (nonatomic, strong) NSNumber *salesNotInclude;
/** 损益 */
@property (nonatomic, strong) NSNumber *profitLoss;
/** 创建时间 */
@property (nonatomic, strong) NSNumber *createTime;
/** 操作时间 */
@property (nonatomic, strong) NSNumber *opTime;
/** 操作人 */
@property (nonatomic, copy) NSString *opUserId;
/** 员工姓名 */
@property (nonatomic, copy) NSString *userName;
/** 员工工号 */
@property (nonatomic, copy) NSString *staffId;
/** 角色名称 */
@property (nonatomic, copy) NSString *roleName;
/** 性别:1：男，2：女，3：中性 */
@property (nonatomic, strong) NSNumber *sex;
/** <#注释#> */
@property (nonatomic, strong) NSNumber *isValid;
/** <#注释#> */
@property (nonatomic, strong) NSNumber *lastVer;
//判断掌柜端是否升级：已升级=3，其余的为未升级
@property (nonatomic, strong) NSNumber *handoverSrc;
@property (nonatomic, strong) NSArray *payTypeExpansionVos;
/** 头像 */
@property (nonatomic, copy) NSString *filePath;
@end
