//
//  SettingService.m
//  retailapp
//
//  Created by hm on 15/8/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SettingService.h"
#import "ShopVo.h"
@implementation SettingService

- (void)selecrSysParamCompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"config/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)updateSysParamSetting:(NSMutableDictionary*)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"config/setting"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)selectShopInfo:(NSString*)shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shop/detailById"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)saveShopInfo:(ShopVo*)shop operateType:(NSString*)operateType synIsShop:(BOOL)synIsShop completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:[ShopVo getDictionaryData:shop] forKey:@"shop"];
    [param setValue:operateType forKey:@"operateType"];
    [param setValue:[NSNumber numberWithBool:synIsShop] forKey:@"synIsShop"];
    [param setValue:@2 forKey:@"interface_version"];
    [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shop/save"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)selectOrganizationInfo:(NSString*)organizationId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:organizationId forKey:@"organizationId"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"organization/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)saveOrganizationInfo:(OrganizationVo*)organization operateType:(NSString*)operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:[OrganizationVo getDictionaryData:organization] forKey:@"organization"];
    [param setValue:operateType forKey:@"operateType"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"organization/save"];
    [param setValue:@2 forKey:@"interface_version"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)deleteOrganizationInfo:(NSString*)orgId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:orgId forKey:@"organizationId"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"organization/delete"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)deleteShopInfo:(NSString*)shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:shopId forKey:@"shopId"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shop/delete"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];

}

- (void)selectSubOrgInfo:(NSString*)organizationId withPage:(NSString*)currentPage withKeyWord:(NSString*)keyWord completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:organizationId forKey:@"organizationId"];
    [param setValue:currentPage forKey:@"currentPage"];
    if ([NSString isNotBlank:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"organization/orgShopList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**查询所有下属机构/店家（分支列表）无分页*/
- (void)selectAllSubOrg:(NSString*)organizationId withDepFlag:(BOOL)depFlag withShopFlag:(BOOL)shopFlag withIsMicroShop:(BOOL)isMicroShop completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setValue:organizationId forKey:@"organizationId"];
    [param setValue:@"1" forKey:@"currentPage"];
    [param setValue:[NSNumber numberWithBool:depFlag] forKey:@"depFlag"];
    [param setValue:[NSNumber numberWithBool:shopFlag] forKey:@"shopFlag"];
    [param setValue:[NSNumber numberWithBool:isMicroShop] forKey:@"isMicroShop"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"organization/selectBranch"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**所有下属机构/店家分支的查询结果(有分页)*/
- (void)selectInBranch:(NSString*)organizationId withPage:(NSString*)currentPage withKeyWord:(NSString*)keyWord withDepFlag:(BOOL)depFlag withShopFlag:(BOOL)shopFlag withIsMicroShop:(BOOL)isMicroShop completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
   NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setValue:organizationId forKey:@"organizationId"];
    [param setValue:currentPage forKey:@"currentPage"];
    if ([NSString isNotBlank:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    [param setValue:[NSNumber numberWithBool:depFlag] forKey:@"depFlag"];
    [param setValue:[NSNumber numberWithBool:shopFlag] forKey:@"shopFlag"];
    [param setValue:[NSNumber numberWithBool:isMicroShop] forKey:@"isMicroShop"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"organization/selectInBranch"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}

//查询所有下级门店
- (void)selectShopList:(NSString*)organizationId withPage:(NSString*)currentPage withKeyWord:(NSString*)keyWord isMicroShop:(BOOL)isMicroShop completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
   NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    [param setValue:organizationId forKey:@"organizationId"];
    [param setValue:currentPage forKey:@"currentPage"];
    if ([NSString isNotBlank:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    [param setValue:[NSNumber numberWithBool:isMicroShop] forKey:@"isMicroShop"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shop/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询同级门店
- (void)selectTransferList:(NSString*)shopId withPage:(NSString*)currentPage withKeyWord:(NSString*)keyWord completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:currentPage forKey:@"currentPage"];
    if ([NSString isNotBlank:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shop/transferList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询机构直属下级
- (void)selectSonShopList:(NSString *)orgId page:(NSInteger)currentPage keyWord:(NSString *)keyWord completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:orgId forKey:@"organizationId"];
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    if ([NSString isNotBlank:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"organization/selectSonShopList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**<小票设置 获取店铺信息>*/
- (void)getShopInfo:(NSString *)shopId completeHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock {
    
    if (shopId) {
        NSDictionary *param = @{@"shopId" : shopId};
        NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"receipt/v1/shopInfo"];
        [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
    }
}

/**获取小票设置详情*/
- (void)acquireNoteSettingDetail:(NSString *)shopId withShow:(BOOL)show completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSDictionary *param = @{@"shopId" : shopId};
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"receipt/v1/selectData"];
    if (show) {
        
        [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
    }else {
       [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
    }
}

/**更新小票设置*/
- (void)updateNoteSetting:(NSInteger)type receiptStyle:(ReceiptStyleVo *)receiptStyle completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:@(type) forKey:@"type"];
    [param setValue:[receiptStyle converToDic] forKey:@"receiptStyle"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"receipt/v1/setting"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**获取短信设置详情*/
- (void)acquireSmsSettingDetail:(NSMutableArray*)configCodeList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:configCodeList forKey:@"configCodeList"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"config/configDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)updateSmsSetting:(NSMutableArray*)configVoList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:configVoList forKey:@"configVoList"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"config/configSetting"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**数据清理、初始化验证*/
- (void)shopClearOrInitCheck:(NSString *)shopId doType:(NSString *)doType password:(NSString *)password completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:doType forKey:@"doType"];
    [param setValue:password forKey:@"password"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shop/shopClearOrShopInitCheck"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在验证..."];
}
/**数据清理、初始化*/
- (void)clearOrInitShopData:(NSString*)shopId doType:(NSString*)doType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:doType forKey:@"doType"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shop/shopClearOrShopInit"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}
//营业设置页面查询支付方式种类
- (void)querySettingModule:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"config/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//支付方式保存

- (void)payMentSave:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"payMent/save"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//支付方式列表
- (void)payMentList:(NSMutableArray *)list completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"payMent/list"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:list forKey:@"payIdList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//支付方式删除
- (void)paymentDelete:(NSString *)payId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:payId forKey:@"payId"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"payMent/delete"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在删除"];
    
}




/**获取自身店铺信息*/
- (void)getSelfShopInfo:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"settledMall/shopDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
/**商圈店铺列表*/
- (void)settledMallShopList:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"settledMall/settledMallList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];

}
/**根据商圈编码检索商圈详细*/
- (void)settledMallById:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"settledMall/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**入驻商圈申请*/
- (void)saveSettledMall:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"settledMall/saveSettledMall"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**商家详情*/
- (void)settledMallShopDetail:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"settledMall/settledMallDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
/**取消申请*/
- (void)delSettleMall:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"settledMall/delSettleMall"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
/**客单备注*/
- (void)getBillNoteInfo:(NSString *)path param:(NSMutableDictionary *)param  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,path];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
    
}

@end
