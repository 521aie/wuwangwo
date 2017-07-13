//
//  SettingService.h
//  retailapp
//
//  Created by hm on 15/8/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopVo.h"
#import "OrganizationVo.h"
#import "ReceiptStyleVo.h"

@interface SettingService : NSObject
//系统参数设置详情
- (void)selecrSysParamCompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//更新系统参数设置
- (void)updateSysParamSetting:(NSMutableDictionary*)dataList CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**查询店铺信息*/
- (void)selectShopInfo:(NSString*)shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**添加\保存店铺信息*/
- (void)saveShopInfo:(ShopVo*)shop operateType:(NSString*)operateType synIsShop:(BOOL)synIsShop completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**查询组织机构信息*/
- (void)selectOrganizationInfo:(NSString*)organizationId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**添加\保存组织机构信息*/
- (void)saveOrganizationInfo:(OrganizationVo*)shop operateType:(NSString*)operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**删除组织机构信息*/
- (void)deleteOrganizationInfo:(NSString*)orgId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**删除门店信息*/
- (void)deleteShopInfo:(NSString*)shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**查询下属一级机构/店家*/
- (void)selectSubOrgInfo:(NSString*)organizationId withPage:(NSString*)currentPage withKeyWord:(NSString*)keyWord completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**查询所有下属机构/店家（分支列表）无分页*/
- (void)selectAllSubOrg:(NSString*)organizationId withDepFlag:(BOOL)depFlag withShopFlag:(BOOL)shopFlag withIsMicroShop:(BOOL)isMicroShop completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**所有下属机构/店家分支的查询结果(有分页)*/
- (void)selectInBranch:(NSString*)organizationId withPage:(NSString*)currentPage withKeyWord:(NSString*)keyWord withDepFlag:(BOOL)depFlag withShopFlag:(BOOL)shopFlag withIsMicroShop:(BOOL)isMicroShop completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**查询店家一览*/
- (void)selectShopList:(NSString*)organizationId withPage:(NSString*)currentPage withKeyWord:(NSString*)keyWord isMicroShop:(BOOL)isMicroShop completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**查询同级下所有门店(用于门店调拨) */
- (void)selectTransferList:(NSString*)shopId withPage:(NSString*)currentPage withKeyWord:(NSString*)keyWord completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  查询机构直属下一级门店
 *
 *  @param orgId           机构id
 *  @param currentPage     分页
 *  @param keyWord         检索词
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectSonShopList:(NSString *)orgId page:(NSInteger)currentPage keyWord:(NSString *)keyWord completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**获取小票设置详情*/
- (void)acquireNoteSettingDetail:(NSString *)shopId withShow:(BOOL)show completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**更新小票设置*/
- (void)updateNoteSetting:(NSInteger)type receiptStyle:(ReceiptStyleVo *)receiptStyle completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**获取店铺信息*/
- (void)getShopInfo:(NSString *)shopId completeHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**获取短信设置详情*/
- (void)acquireSmsSettingDetail:(NSMutableArray*)configCodeList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**更新短信设置*/
- (void)updateSmsSetting:(NSMutableArray*)configVoList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**数据清理、初始化验证*/
- (void)shopClearOrInitCheck:(NSString *)shopId doType:(NSString *)doType password:(NSString *)password completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**数据清理或初始化数据*/
- (void)clearOrInitShopData:(NSString*)shopId doType:(NSString*)doType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
//营业设置页面查询支付方式种类
- (void)querySettingModule:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
//支付方式保存

- (void)payMentSave:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//支付方式列表
- (void)payMentList:(NSMutableArray *)list completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

- (void)paymentDelete:(NSString *)payId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


//入驻商圈
/**获取自身店铺信息*/
- (void)getSelfShopInfo:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**商圈店铺列表*/
- (void)settledMallShopList:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**根据商圈编码检索商圈详细*///弃用
- (void)settledMallById:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**入驻商圈修改*/
- (void)saveSettledMall:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**入驻商圈店铺详情*/
- (void)settledMallShopDetail:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**取消申请*/
- (void)delSettleMall:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**客单备注*/
- (void)getBillNoteInfo:(NSString *)path param:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

@end
