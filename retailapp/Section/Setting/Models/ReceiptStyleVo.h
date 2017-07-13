//
//  ReceiptStyleVo.h
//  retailapp
//
//  Created by hm on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptStyleVo : NSObject

@property (nonatomic ,copy) NSString *receiptStyleId; /**<小票属性id>*/
@property (nonatomic ,assign) NSInteger hasLogo; /**<是否显示店铺Logo>*/
@property (nonatomic ,copy) NSString *receiptTitle; /**<小票标题>*/
@property (nonatomic ,assign) NSInteger hasWeiqrcode; /**<是否打印微店二维码>*/
@property (nonatomic ,assign) NSInteger orderNumToBarCode; /**<是否单号打印成条码>*/
@property (nonatomic ,assign) NSInteger hasGoodsName; /*<是否显示品名>*/
@property (nonatomic ,assign) NSInteger hasBarCode; /*<是否显示货号>*/
@property (nonatomic ,assign) NSInteger hasTotalOriginal;/*<是否显示原价合计>*/
@property (nonatomic ,assign) NSInteger hasDiscount; /*<是否显示优惠合计>*/
@property (nonatomic ,assign) NSInteger hasPayDetail; /*<是否显示支付明细>*/
@property (nonatomic ,assign) NSInteger hasDiscountDetail; /*<是否显示优惠明细>*/
@property (nonatomic ,assign) NSInteger hasPoint; /*<是否显示本次积分>*/
@property (nonatomic ,assign) NSInteger hasPointBalance;/*<是否显示卡内积分>*/
@property (nonatomic ,assign) NSInteger hasMoneyBalance;/*<是否显示卡内余>*/
@property (nonatomic ,assign) NSInteger bottomLocation;/*<尾注打印位置>*/
@property (nonatomic ,assign) NSInteger hasComment;/*<是否打印客单备注>*/
@property (nonatomic ,copy) NSString *shopId; /**<门店id>*/
@property (nonatomic ,assign) long lastVer; /**<版本号>*/
@property (nonatomic ,strong) NSMutableArray *bottomContentList; /*<尾注内容>*/
@property (nonatomic ,assign) NSInteger receiptWithType; /*<小票宽度1:58mm 2:80mm>*/
@property (nonatomic ,assign) NSInteger hasDiscountMoney; /*<是否显示折后价 0 1>*/
@property (nonatomic ,assign) NSInteger hasRetailPrice; /*<是否显示零售价 0 1>*/
@property (nonatomic ,assign) NSInteger hasCustomerName; /*<是否显示会员名 0 1>*/
@property (nonatomic ,assign) NSInteger hasCustomerMobile; /*<是否显示会员手机号 0 1>*/
@property (nonatomic ,assign) NSInteger hasCardCode; /*<是否显示会员卡号 0 1>*/
/** 是否显示商品单位 0不显示 1显示 */
@property (nonatomic, strong) NSNumber *hasGoodsUnit;

- (NSDictionary *)converToDic;
+ (ReceiptStyleVo *)converToVo:(NSDictionary *)dic;
@end
