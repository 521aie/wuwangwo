//
//  RetailSellReturnVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RetailInstanceVo : NSObject

//条形码
@property (nonatomic, copy) NSString *barCode;

//款式id
@property (nonatomic, copy) NSString *styleId;

//店内码
@property (nonatomic, copy) NSString *innerCode;

//颜色
@property (nonatomic, copy) NSString *colorVal;

//尺码
@property (nonatomic, copy) NSString *sizeVal;

//单价
@property (nonatomic) double price;

//折前总额
@property (nonatomic) double fee;

//最终折扣价
//@property (nonatomic) double finalRatioFee;

@property (nonatomic ,assign) double salesPrice;/*<字段修改：最终折扣价>*/

//商品名
@property (nonatomic, copy) NSString *originalGoodsName;

//结账数量
@property (nonatomic) double accountNum;

//店铺id
@property (nonatomic, copy) NSString *shopId;

//商品id
@property (nonatomic, copy) NSString *goodsId;

//订单id
@property (nonatomic, copy) NSString *orderId;

//商品类别id
@property (nonatomic, copy) NSString *categoryId;

//销售区分
@property (nonatomic) short type;

//结账单位
@property (nonatomic, copy) NSString *accountUnit;

//说明
@property (nonatomic, copy) NSString *memo;

//促销id
@property (nonatomic, copy) NSString *salesId;

//折扣区分
@property (nonatomic) short discountType;
@end

@interface RetailExpansion : NSObject

@property (nonatomic ,strong) NSString *returnType;/*<退货理由>*/
@property (nonatomic ,strong) NSString *returnReason;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *isTotalReturn;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *payType;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *payAccount;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *accountName;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *totalReturnSupplyprice;/*<<#说明#>>*/
@end


// 其实是设计接口文档中包含： RetailSellReturnVo 和 SellReturnVo 对象所有字段的
@interface RetailSellReturnVo : NSObject

// ===================== 共同字段 ============================
@property (nonatomic ,strong) NSString *shopId;/*<<#说明#>>*/
@property (nonatomic ,assign) short status; /*<3,同意退货 4，退货中>*/
@property (nonatomic ,strong) NSString *entityId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *shopEntityId;/*<<#说明#>>*/
@property (nonatomic ,assign) NSInteger lastVer;//版本号
@property (nonatomic ,assign) NSInteger isValid;/*<<#说明#>>*/
@property (nonatomic ,assign) long long createTime;//退货时间
@property (nonatomic ,copy) NSString *orignId;//原始单据id
@property (nonatomic ,copy) NSString *globalCode;//全局单号
@property (nonatomic ,copy) NSString *outType;//单据来源
@property (nonatomic ,assign) short returnKind; //单据类型
@property (nonatomic ,copy) NSString *code;//单号
@property (nonatomic ,strong) NSString *cardId;//会员卡id
@property (nonatomic ,strong) NSString *card;//会员卡卡号
@property (nonatomic ,strong) NSString *memo;//备注
@property (nonatomic ,assign) double discountAmount;/*<实退总金额>*/
@property (nonatomic ,assign) short returnTypeId;//退货类型id
@property (nonatomic ,copy) NSString *customerName;//会员名字
@property (nonatomic ,copy) NSString *customerMobile;//会员手机号


// ===================== RetailSellReturnVo 独有字段 ============================
@property (nonatomic ,strong) NSString *sellReturnId;/*<退货单号>*/
@property (nonatomic) double totalAmount; //合计总金额
@property (nonatomic) double totalCount; //合计数量
@property (nonatomic, copy) NSString *returnType; //退货类型
@property (nonatomic, copy) NSString *returnReason; //退货理由
@property (nonatomic, copy) NSString *logisticsName; //物流公司名称
@property (nonatomic, copy) NSString *logisticsNo; //物流单号
@property (nonatomic, copy) NSString *refuseReason; //拒绝理由
@property (nonatomic, copy) NSString *linkeMan; //退货联系人
@property (nonatomic, copy) NSString *phone; //联系电话
@property (nonatomic, copy) NSString *address; //退货地址
@property (nonatomic, copy) NSString *zipCode; //邮编
@property (nonatomic, copy) NSString *refundFailureReason;//退款失败理由
@property (nonatomic, assign) NSInteger isTotalReturn;/*<<#说明#>>*/
@property (nonatomic, copy) NSString *customerId;//会员id
@property (nonatomic, strong) NSString *opUserName;//操作人
@property (nonatomic, strong) NSArray *instanceList;//商品明细
@property (nonatomic, strong) NSDictionary *customerReturnPayVo;//支付信息
@property (nonatomic, assign) short isCashOnDelivery;//是否货到付 	1.是 2.否
@property (nonatomic) short payMode;//支付方式 99 其他， 1，会员卡
@property (nonatomic) NSInteger returnSource;//所属角色
@property (nonatomic ,strong) NSString *organizationShopSellReturnId;/*<连锁门店退货关联表ID>*/


// ===================== SellReturnVo 独有字段 ============================
@property (nonatomic ,strong) NSString *id;/*<id>*/
@property (nonatomic ,strong) NSString *opUserId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *opTime;/*<<#说明#>>*/
@property (nonatomic ,assign) short sellReturnType;/*<<#说明#>>*/
@property (nonatomic ,assign) long long openTime;/*<<#说明#>>*/
@property (nonatomic ,assign) long long endTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *customerRegisterId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *cardEntityId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *degree;/*<<#说明#>>*/
@property (nonatomic ,assign) long long confirmRefundTime;/*<<#说明#>>*/
@property (nonatomic ,assign) double sourceAmount;/*<double:>*/
@property (nonatomic ,assign) double resultAmount;//应退总金额
@property (nonatomic ,assign) double recieveAmount;/*<<#说明#>>*/
@property (nonatomic ,strong) RetailExpansion *expansion;/*<退货说明信息>*/
@property (nonatomic, strong) NSString *isCheck; //是否选中

+ (RetailSellReturnVo *)converToVo:(NSDictionary *)dic;
+ (NSMutableArray *)converToArr:(NSArray *)sourceList;
- (NSDictionary *)convertToDic;
// 获取当前单子状态值status 对应的状态
- (NSString *)getStatusString;
@end
