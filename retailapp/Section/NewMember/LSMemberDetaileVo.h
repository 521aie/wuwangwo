//
//  LSMemberSaveDetailVo.h
//  retailapp
//
//  Created by taihangju on 2016/10/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger ,MoneyActionType) {
    MoneyActionRecharge = 1, // 充值
    MoneyActionConsume,      // 消费
    MoneyActionRedRush,      // 红冲
    MoneyActionBackRush,     // 回冲
    MoneyActionGoodsReturn = 8, // 退货回冲
};

typedef NS_ENUM(NSInteger ,DegreeActionType) {
    DegreeActionConsume = 1 ,   // 操作-消费
    DegreeActionRedRush,        // 操作-红冲
    DegreeActionGift,           // 操作-赠分
    DegreeActionExchange,       // 积分兑换
    DegreeActionBackRush,       // 退货扣积分(回冲)
};

// 会员储值/积分明细 vo
@interface LSMemberDetaileVo : NSObject

// 公有属性
@property (nonatomic ,strong) NSString *sId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *s_Id;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *createTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *lastVer;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isValid;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *opTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *entityId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *consumeDate;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *cardId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *activeId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *operatorId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *disposeName;/*<eg：管理员>*/
@property (nonatomic ,strong) NSString *payId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *shopEntityId;/*<店铺等实体id>*/
@property (nonatomic ,strong) NSString *relationId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *status;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *memo;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *isChanged;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *cacheExpireTime;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *orign_Id;/*<<#说明#>>*/
@end

// 积分明细
@interface LSMemberDegreeFlowVo : LSMemberDetaileVo


@property (nonatomic ,strong) NSNumber *action;/*< 1: 消费  2、红冲 3、赠分 4、兑换 >*/
@property (nonatomic ,strong) NSNumber *degree;/*<float:>*/
@property (nonatomic ,strong) NSString *giftId;/*<积分商品对应id>*/
@property (nonatomic ,strong) NSString *giftName;/*<积分商品名称>*/
@property (nonatomic ,strong) NSNumber *quantity;/*<float:>*/
@property (nonatomic ,strong) NSNumber *num;/*<float:>*/

+ (NSArray *)getDegreeFlowVoVoList:(NSArray *)keyValuesArray;
- (NSString *)getActionStringWithTextColor:(UIColor * __autoreleasing *)color;
@end


// 储值明细
@interface LSMemberMoneyFlowVo : LSMemberDetaileVo

@property (nonatomic ,strong) NSNumber *action;/*< 1: 充值  2、消费 3、红冲 4、回冲 5、挂账储值卡支付 6、挂账回冲>*/
@property (nonatomic ,strong) NSNumber *pay;/*<float:>*/
@property (nonatomic ,strong) NSNumber *fee;/*<float:>*/
@property (nonatomic ,strong) NSNumber *balance;/*<float:>*/
@property (nonatomic ,strong) NSString *mobile;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *payMode;/*<NSInter:1，现金 2，银行卡 3，第三方支付 4，赠送 5，其他支付方式 6，微信 7，支付宝>*/
@property (nonatomic ,strong) NSString *sellerId;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *sellerName;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *opType;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *customerName;/*<<#说明#>>*/
@property (nonatomic ,strong) NSNumber *code;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *kindCardName;/*<<#说明#>>*/
@property (nonatomic ,strong) NSString *operatorName;/*<<#说明#>>*/
@property (nonatomic, strong) NSNumber *giftDegree;/*赠送积分*/

// 这个是独立于对象之外的，所以解析的时候要特别注意
@property (nonatomic ,strong) NSString *payModeStr;/*<付款方式>*/

+ (NSArray *)getMoneyFlowVoList:(NSArray *)keyValuesArray;
- (NSString *)getPayModeString;
- (NSString *)getActionStringWithTextColor:(UIColor * __autoreleasing *)color;
@end
