//
//  MemberService.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpEngine.h"
//#import "CustomerVo.h"
//#import "KindCardVo.h"
#import "SaleRechargeVo.h"

@interface MemberService : NSObject

//会员信息主页
- (void)selectMemberInfo:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员卡类型列表
- (void)selectKindCardList:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员卡类型详情
- (void)selectKindCardDetail:(NSString*) kindCardId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员卡类型添加/修改
//- (void)saveKindCard:(NSString*) operateType kindCard:(KindCardVo*) kindCard completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员卡类型删除
- (void)delKindCard:(NSString*) kindCardId lastVer:(NSString*) lastVer completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员信息查询
-(void) selectMemberInfoList:(NSString *)keywords keywordsKind:(NSString *)keywordsKind kindCardId:(NSString *)kindCardId statusCondition:(NSString *)statusCondition startActiveTime:(NSString *)startActiveTime endActiveTime:(NSString *)endActiveTime lastDateTime:(NSString *)lastDateTime disposeName:(NSString *)disposeName completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

//会员信息导出
- (void)exportMemberInfo:(NSString*) keywords kindCardId:(NSString*) kindCardId statusCondition:(NSString*) statusCondition startActiveTime:(NSString*) startActiveTime endActiveTime:(NSString*) endActiveTime createWay:(NSString*) createWay shopId:(NSString*) shopId disposeName:(NSString*) disposeName birthdayTime:(NSString*) birthdayTime email:(NSString *)email completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员信息详情
- (void)selectMemberInfoDetail:(NSString*) customerId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员充值记录
- (void)selectMemberChargeRecord:(NSString*) customerId chargeStartDate:(NSString*)chargeStartDate chargeEndDate:(NSString*) chargeEndDate lastDateTime:(NSString *)lastDateTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员信息添加/修改
//- (void)saveMemberInfo:(NSString*) operateType passwordFlg:(NSString*) passwordFlg doCheck:(NSString*) doCheck customer:(CustomerVo*) customer completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员删除
- (void)delMemberInfo:(NSString*) customerId cardId:(NSString*) cardId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员退卡详情
- (void)selectCardCancelDetail:(NSString*) customerId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员退卡
- (void)doCardCancel:(NSString*) cardId lastVer:(NSString*) lastVer amount:(NSString*) amount mobile:(NSString*) mobile customerName:(NSString*) customerName comments:(NSString*) comments token:(NSString*) token completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员挂失
-(void)doCardLoss:(NSString*) cardId lastVer:(NSString*) lastVer operate:(NSString*) operate code:(NSString*) code mobile:(NSString*) mobile completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//充值促销列表查询
-(void) selectRechargeSalesList:(NSString*) showDateRange completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//充值促销详情
-(void) selectRechargeSalesDetail:(NSString*) saleRechargeId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//充值促销添加/修改
-(void) saveRechargeSales:(NSString*) operateType saleRecharge:(SaleRechargeVo*) saleRecharge completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//充值促销删除
-(void) delRechargeSales:(NSString*) saleRechargeId lastVer:(NSString*) lastVer completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员充值
-(void) doRecharge:(NSString*) cardId lastVer:(NSString*) lastVer amount:(NSString*) amount presentAmount:(NSString*) presentAmount presentPoint:(NSString*) presentPoint rechargeRuleId:(NSString*) rechargeRuleId chargeTime:(NSString*) chargeTime payMode:(NSString*) payMode token:(NSString*) token completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//红冲详情
-(void) selectMemberRedRecharge:(NSString*) moneyFlowId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//红冲操作
-(void) doMemberRedRecharge:(NSString*) moneyFlowId lastVer:(NSString*) lastVer completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//积分商品一览
-(void) selectDegreeGoodsList:(NSString*) searchType searchCode:(NSString*) searchCode completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//积分兑换商品设置
-(void)saveDegreeGoodsWith:(NSDictionary *)param completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//取消积分兑换商品
-(void) cancelDegreeGoods:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//积分兑换商品列表
-(void) selectGiftGoodsList:(NSString*) point completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//积分兑换
-(void) doExchangeGiftGoods:(NSString*) cardId shopId:(NSString*) shopId lastVer:(NSString*) lastVer goodsGiftList:(NSMutableArray*) goodsGiftList token:(NSString*) token completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


@end
