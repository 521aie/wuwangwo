//
//  LSMemberGiftVo.h
//  retailapp
//
//  Created by taihangju on 16/10/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class LSMemberGiftGoodVo,LSMemberGiftBalanceVo;
// 积分兑换 赠品vo ，赠品分为商品和卡余额
//@interface LSMemberGiftVo : NSObject
//
//@property (nonatomic ,strong) NSArray<LSMemberGiftGoodVo *> *goodsGiftList;/*<兑换商品列表>*/
//@property (nonatomic ,strong) NSArray<LSMemberGiftBalanceVo *> *giftPojoList;/*<兑换卡余额列表>*/
//+ (LSMemberGiftVo *)memberGiftVo:(NSDictionary *)dic;
//@end

@interface LSMemberGoodsGiftVo : NSObject

@property (nonatomic ,strong) NSString *sId;/*<id 兑换的“卡余额”商品id>*/
@property (nonatomic ,strong) NSString *goodsId;/*<积分兑换的商品id>*/
@property (nonatomic ,strong) NSString *name;/*<商品名称>*/
@property (nonatomic ,strong) NSNumber *point;/*<所需积分: int>*/
@property (nonatomic ,strong) NSString *barCode;/*<商品条码>*/
@property (nonatomic ,strong) NSString *innerCode;/*<内部编码码>*/
@property (nonatomic ,strong) NSString *goodsColor;/*<商品颜色>*/
@property (nonatomic ,strong) NSString *goodsSize;/*<商品尺码>*/
@property (nonatomic ,strong) NSNumber *number;/*<商品兑换数量 :int>*/
@property (nonatomic ,strong) NSNumber *price;/*<商品价格>*/
@property (nonatomic ,strong) NSString *picture;/**<商品图片*/
@property (nonatomic, strong) NSNumber *giftStore;/**<实体积分库存>*/
@property (nonatomic, strong) NSNumber *weixinGiftStore;/**<微店积分库存>*/
@property (nonatomic, strong) NSNumber *limitedGiftStore;/**<实体积分商品库存是否限制:false-不限 true-限制>*/
@property (nonatomic, assign) NSNumber *limitedWXGiftStore;/**<微店积分商品库存是否限制:false-不限 true-限制>*/
@property (nonatomic, strong) NSNumber *goodsType;/**<1-普通商品 2-拆分商品 3-组装商品 4-散装商品 5-原料商品 6-加工商品>*/
@property (nonatomic ,strong) NSNumber *type;/*<1：积分兑换钱  2：积分兑换商品>*/
@property (nonatomic, strong) NSNumber *goodsStatus;/**<商品状态:1-上架 2-下架>*/
//@property (nonatomic ,strong) NSNumber *quantity;/*< 所需积分:整形>*/
@property (nonatomic ,strong) NSNumber *cardFee;/*<兑换的卡余额金额:整形>*/

@property (nonatomic, assign) BOOL selected;/**<保存选择的状态>*/
//@property (nonatomic ,strong) NSNumber *goodsNumber;/*<<#说明#>>*/
//@property (nonatomic ,strong) NSNumber *giftGoodsNumber;/*<<#说明#>>*/
//@property (nonatomic ,strong) NSNumber *canDistributeNumber;/*<<#说明#>>*/
//@property (nonatomic ,strong) NSNumber *purchasePrice;/*<<#说明#>>*/
//@property (nonatomic ,strong) NSNumber *hangTagPrice;/*<<#说明#>>*/
//@property (nonatomic ,strong) NSNumber *styleCode;/*<>*/

+ (NSArray *)voListFromJsonArray:(NSArray *)keyValuesArray;
+ (NSString *)jsonStringFromVoList:(NSArray *)voArray;
+ (NSArray *)jsonArrayFromVoList:(NSArray *)voArray;
- (NSString *)toJsonString;
// 返回当前商品类型对应的图标名称
- (NSString *)goodTypeImageString;
@end

// 积分兑换卡余额 vo
//@interface LSMemberGiftBalanceVo : NSObject
//
//@property (nonatomic ,strong) NSString *sId;/*<id>*/
//@property (nonatomic ,strong) NSNumber *isValid;/*<>*/
//@property (nonatomic ,strong) NSNumber *opTime;/*<操作时间>*/
//@property (nonatomic ,strong) NSNumber *createTime;/*<创建时间>*/
//@property (nonatomic ,strong) NSNumber *lastVer;/*<版本号>*/
//@property (nonatomic ,strong) NSString *extendFields;/*<<#说明#>>*/
//@property (nonatomic ,strong) NSString *name;/*<卡余额(+333)元>*/
//@property (nonatomic ,strong) NSNumber *quantity;/*< 所需积分:整形>*/
//@property (nonatomic ,strong) NSString *unit;/*<单位>*/
//@property (nonatomic ,strong) NSString *entityId;/*<<#说明#>>*/
//@property (nonatomic ,strong) NSNumber *cardFee;/*<兑换的卡余额金额:整形>*/
//@property (nonatomic ,strong) NSString *productId;/*<<#说明#>>*/
//@property (nonatomic ,strong) NSString *_OrginId;/*<<#说明#>>*/
//
//- (NSString *)giftBalanceVoJsonString;
//@end

