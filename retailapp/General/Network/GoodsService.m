//
//  GoodsService.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsService.h"
#import "SignUtil.h"
#import "CategoryVo.h"
#import "JsonHelper.h"
#import "ObjectUtil.h"

@implementation GoodsService

-(void) selectCategoryList:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"category/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveCategory:(CategoryVo *)categoryVo operateType:(NSString *)operateType completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"category/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:[JsonHelper getObjectData:categoryVo] forKey:@"category"];
    [param setValue:operateType forKey:@"operateType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) delCategory:(NSString *)categoryId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"category/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:categoryId forKey:@"categoryId"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) exportCategory:(NSString *)email completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"category/exportGoodsCategory"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:email forKey:@"email"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

// 叶子节点分类查询
- (void) selectLastCategoryInfo:(NSString*) hasNoCategory completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"category/lastCategoryInfo"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:hasNoCategory forKey:@"hasNoCategory"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

// 中品类查询
- (void) selectFirstCategoryInfo:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"category/firstCategoryInfo"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectInnerCodeSetting:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"skuRule/detail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) closeInnerCodeSetting:(NSString *)isOpen completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"skuRule/switch"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:isOpen forKey:@"isOpen"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveInnerCodeSetting:(NSMutableArray *)skuList completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"skuRule/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:[JsonHelper transDictionaryList:skuList] forKey:@"skuList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectAttributeList:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) delAttribute:(NSString *)attributeId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:attributeId forKey:@"attributeId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveAttribute:(NSString *)operateType attributeVo:(AttributeVo *)attributeVo completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:operateType forKey:@"operateType"];
    [param setValue:[JsonHelper transDictionary:attributeVo] forKey:@"attribute"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectAttributeTypeList:(NSString *)attributeId attributeType:(NSString *)attributeType completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/group/lib"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:attributeId forKey:@"attributeId"];
    [param setValue:attributeType forKey:@"attributeType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveAttributeVal:(NSString *)operateType baseAttributeType:(NSString *)baseAttributeType collectionType:(NSString *)collectionType attributeVal:(AttributeValVo*)attributeVal completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/val/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    [param setValue:operateType forKey:@"operateType"];
    [param setValue:baseAttributeType forKey:@"baseAttributeType"];
    [param setValue:collectionType forKey:@"collectionType"];
    [param setValue:[JsonHelper transDictionary:attributeVal] forKey:@"attributeVal"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)delAttributeVal:(NSMutableArray*) attributeValVoList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/val/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:attributeValVoList forKey:@"attributeValVoList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];

}

-(void) saveAttributeType:(NSString *)operateType attributeGroupVo:(AttributeGroupVo *)attributeGroupVo completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/group/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:[JsonHelper getObjectData:attributeGroupVo] forKey:@"attributeGroup"];
    [param setValue:operateType forKey:@"operateType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) delAttributeType:(NSString *)attributeGroupId lastVer:(NSString*) lastVer completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/group/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:attributeGroupId forKey:@"attributeGroupId"];
    
    [param setValue:lastVer forKey:@"lastVer"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

// 属性分类排序
-(void) sortAttributeGroup:(NSString*) attributeNameId groupList:(NSMutableArray*) groupList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/group/sort"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:attributeNameId forKey:@"attributeNameId"];
    
    [param setValue:groupList forKey:@"groupList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

// 属性值排序
-(void) sortAttributeVal:(NSString*) attributeGroupId groupList:(NSMutableArray*) valList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/val/sort"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:attributeGroupId forKey:@"attributeGroupId"];
    
    [param setValue:valList forKey:@"valList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectBaseAttributeValList:(NSString *)baseAttributeType completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/baseVal/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:baseAttributeType forKey:@"baseAttributeType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) changeAttributeCategory:(NSMutableArray*) attributeValVoList completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"attribute/val/modifyCategory"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:attributeValVoList forKey:@"attributeValVoList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)selectNotGiftGoodsList:(NSString *)searchCode searchType:(NSString *)type currentPage:(NSInteger)page completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/v1/notGiftGoodsList"];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:@(page) forKey:@"currentPage"];
    [param setValue:searchCode forKey:@"searchCode"];
    [param setValue:type forKey:@"searchType"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectGoodsList:(NSString *)searchType shopId:(NSString *)shopId searchCode:(NSString *)searchCode barCode:(NSString *)barCode categoryId:(NSString *)categoryId createTime:(NSString *)createTime validTypeList:(NSMutableArray*) validTypeList completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [param setValue:searchType forKey:@"searchType"];
    
    if (![NSString isBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if (![NSString isBlank:searchCode]) {
        [param setValue:searchCode forKey:@"searchCode"];
    }
    if (![NSString isBlank:barCode]) {
        [param setValue:barCode forKey:@"barCode"];
    }
    if (![NSString isBlank:categoryId]) {
        [param setValue:categoryId forKey:@"categoryId"];
    }
    if (![NSString isBlank:createTime]) {
        [param setValue:createTime forKey:@"createTime"];
    }
    
    if (validTypeList != nil) {
        [param setValue:validTypeList forKey:@"validTypeList"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}



-(void) selectGoodsCount:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/goodsCount"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:shopId forKey:@"shopId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}

-(void) selectGoodsBaseInfo:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/goodsBaseInfo"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];

    [param setValue:goodsId forKey:@"goodsId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectGoodsDetail:(NSString*) shopId goodsId:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/goodsDetail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:goodsId forKey:@"goodsId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//商品条码、名称check
-(void) checkGoods:(NSString*) goodsId barcode:(NSString*) barcode name:(NSString*) name completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/checkGoods"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    if ([NSString isNotBlank:goodsId]) {
        [param setValue:goodsId forKey:@"goodsId"];
    }
    [param setValue:barcode forKey:@"barcode"];
    [param setValue:name forKey:@"name"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void)saveGoodsDetail:(NSDictionary *)goodsVo operateType:(NSString *)operateType searchStatus:(id) searchStatus completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:goodsVo forKey:@"goodsVo"];
    [param setValue:operateType forKey:@"operateType"];
    if ([ObjectUtil isNotNull:searchStatus]) {
        [param setValue:searchStatus forKey:@"searchStatus"];
    }
    [param setValue:@2 forKey:@"interface_version"];
    [param setValue:[NSNull null] forKey:@"purchasePrice"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) deleteGoods:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    [param setValue:shopId forKey:@"shopId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) setUpDownStatus:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId status:(NSString *) status completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/setUpDownStatus"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:status forKey:@"status"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveBatchMicroGoods:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/saveBatch"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    [param setValue:shopId forKey:@"shopId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) setNotSaleMicroGoods:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/setNotSale"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    [param setValue:shopId forKey:@"shopId"];
    NSLog(@"setNotSale url:%@",url);
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) setGoodsBatchSales:(NSMutableArray*) goodsIdList percentage:(NSString*) percentage hasDegree:(NSString*) hasDegree isSales:(NSString*) isSales completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/setSales"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    if ([NSString isNotBlank:percentage]) {
        [param setValue:percentage forKey:@"percentage"];
    }
    [param setValue:hasDegree forKey:@"hasDegree"];
    [param setValue:isSales forKey:@"isSales"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectBrandList:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"brand/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) delBrand:(NSString*) goodsBrandId lastVer:(NSString*) lastVer completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"brand/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:goodsBrandId forKey:@"goodsBrandId"];
    
    [param setValue:lastVer forKey:@"lastVer"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveBrand:(NSString*) operateType goodsBrand:(NSDictionary*) goodsBrand completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"brand/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:operateType forKey:@"operateType"];
    [param setValue:goodsBrand forKey:@"goodsBrand"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectMicroGoodsDetail:(NSString*) shopId goodsId:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/goodsDetail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:goodsId forKey:@"goodsId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//-(void) saveMicroGoodsDetail:(NSString*) operateType microGoodsVo:(NSDictionary*) microGoodsVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
//{
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/save"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
//    
//    [param setValue:operateType forKey:@"operateType"];
//    [param setValue:microGoodsVo forKey:@"microGoodsVo"];
//    
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

-(void) saveMicroGoodsPictures:(NSDictionary*) microGoodsVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/saveInfoImageList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:microGoodsVo forKey:@"microGoodsVo"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectInfoImageList:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/infoImageList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:goodsId forKey:@"goodsId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectMicroPriceDetail:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/microPriceRelateInfo"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:goodsId forKey:@"goodsId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveMicroPriceDetail:(NSMutableArray*) goodsIdList minSaleDiscountRate:(NSString*) minSaleDiscountRate maxSupplyDiscountRate:(NSString*) maxSupplyDiscountRate completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/relateMicroPrice"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    
    if (![NSString isBlank:minSaleDiscountRate]) {
        [param setValue:minSaleDiscountRate forKey:@"minSaleDiscountRate"];
    }
    
    if (![NSString isBlank:maxSupplyDiscountRate]) {
        [param setValue:maxSupplyDiscountRate forKey:@"maxSupplyDiscountRate"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectStyleCount:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/styleCount"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:shopId forKey:@"shopId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}

- (void)selectStyleList:(NSMutableDictionary*) condition completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:12];
    
    [param setValue:[condition objectForKey:@"searchType"] forKey:@"searchType"];
    
    if ([NSString isNotBlank:[condition objectForKey:@"shopId"]]) {
        [param setValue:[condition objectForKey:@"shopId"] forKey:@"shopId"];
    }
    if([NSString isNotBlank:[condition objectForKey:@"searchCode"]]){
        [param setValue:[condition objectForKey:@"searchCode"] forKey:@"searchCode"];
    }
    if ([NSString isNotBlank:[condition objectForKey:@"categoryId"]]) {
        [param setValue:[condition objectForKey:@"categoryId"] forKey:@"categoryId"];
    }
    
    if ([NSString isNotBlank:[condition objectForKey:@"applySex"]]) {
        [param setValue:[condition objectForKey:@"applySex"] forKey:@"applySex"];
    }
    
    if ([NSString isNotBlank:[condition objectForKey:@"prototypeValId"]]) {
        [param setValue:[condition objectForKey:@"prototypeValId"] forKey:@"prototypeValId"];
    }
    
    if ([NSString isNotBlank:[condition objectForKey:@"auxiliaryValId"]]) {
        [param setValue:[condition objectForKey:@"auxiliaryValId"] forKey:@"auxiliaryValId"];
    }
    
    if ([NSString isNotBlank:[condition objectForKey:@"year"]]) {
        [param setValue:[condition objectForKey:@"year"] forKey:@"year"];
    }
    
    if ([NSString isNotBlank:[condition objectForKey:@"seasonValId"]]) {
        [param setValue:[condition objectForKey:@"seasonValId"] forKey:@"seasonValId"];
    }
    
    if ([NSString isNotBlank:[condition objectForKey:@"minHangTagPrice"]]) {
        [param setValue:[condition objectForKey:@"minHangTagPrice"] forKey:@"minHangTagPrice"];
    }
    
    if ([NSString isNotBlank:[condition objectForKey:@"maxHangTagPrice"]]) {
        [param setValue:[condition objectForKey:@"maxHangTagPrice"] forKey:@"maxHangTagPrice"];
    }
    
    if ([NSString isNotBlank:[condition objectForKey:@"createTime"]]) {
        [param setValue:[condition objectForKey:@"createTime"] forKey:@"createTime"];
    }
    
    if ([[condition objectForKey:@"isSearchTopOrg"] isEqualToString:@"0"]) {
        [param setValue:[NSNumber numberWithBool:NO] forKey:@"isSearchTopOrg"];
    }
    //非必传 如果需要上下架这个参数传
    [param setValue:@YES forKey:@"needUpDownStatus"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];

}

-(void) checkStyleCode:(NSString*) operateType styleId:(NSString*) styleId styleCode:(NSString*) styleCode completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/checkStyleCode"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:operateType forKey:@"operateType"];
    if (![NSString isBlank:styleId]) {
        [param setValue:styleId forKey:@"styleId"];
    }
    [param setValue:styleCode forKey:@"styleCode"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveStyleDetail:(NSDictionary*) styleVo shopId:(NSString *)shopId synPriceFlg:(NSString*) synPriceFlg token:(NSString *)token completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:styleVo forKey:@"styleVo"];
    [param setValue:synPriceFlg forKey:@"synPriceFlg"];
    if ([NSString isNotBlank:token]) {
        [param setValue:token forKey:@"token"];

    }
    [param setValue:@2 forKey:@"interface_version"];
    [param setValue:shopId forKey:@"shopId"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

// 查询款式基础信息
-(void) selectStyleBaseInfo:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/styleBaseInfo"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:styleId forKey:@"styleId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectStyleDetail:(NSString*) shopId styleId:(NSString*) styleId distributionId:(NSString *) distributionId sourceId:(NSString*) sourceId  completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/styleDetail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:styleId forKey:@"styleId"];
    [param setValue:sourceId forKey:@"sourceId"];
    if([distributionId isEqual:@""] || distributionId==nil){
        
    }else{
        [param setValue:distributionId forKey:@"distributionId"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) deleteStyle:(NSString*) shopId styleIdList:(NSMutableArray*) styleIdList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:styleIdList forKey:@"styleIdList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) setStyleUpDownStatus:(NSMutableArray*) styleIdList shopId:(NSString*) shopId status:(NSString *) status completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/setUpDownStatus"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:styleIdList forKey:@"styleIdList"];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:status forKey:@"status"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) setStyleBatchSales:(NSMutableArray*) styleIdList percentage:(NSString*) percentage hasDegree:(NSString*) hasDegree isSales:(NSString*) isSales completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/setSales"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [param setValue:styleIdList forKey:@"styleIdList"];
    if ([NSString isNotBlank:percentage]) {
        [param setValue:percentage forKey:@"percentage"];
    }
    [param setValue:hasDegree forKey:@"hasDegree"];
    [param setValue:isSales forKey:@"isSales"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//款式微店价格详情查询
-(void) selectMicroPriceDetailOfStyle:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/microPriceRelateInfo"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:styleId forKey:@"styleId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//款式微店关联价格保存
-(void) saveMicroPriceDetailOfStyle:(NSMutableArray*) styleIdList minSaleDiscountRate:(NSString*) minSaleDiscountRate maxSupplyDiscountRate:(NSString*) maxSupplyDiscountRate completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/relateMicroPrice"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:styleIdList forKey:@"styleIdList"];
    
    if (![NSString isBlank:minSaleDiscountRate]) {
        [param setValue:minSaleDiscountRate forKey:@"minSaleDiscountRate"];
    }
    
    if (![NSString isBlank:maxSupplyDiscountRate]) {
        [param setValue:maxSupplyDiscountRate forKey:@"maxSupplyDiscountRate"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveStyleGoods:(NSString*) styleId lastVer:(NSString*) lastVer addColorVoList:(NSMutableArray*) addColorVoList addSizeVoList:(NSMutableArray*) addSizeVoList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/updateByAddGoods"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [param setValue:styleId forKey:@"styleId"];
    [param setValue:lastVer forKey:@"lastVer"];
    [param setValue:addSizeVoList forKey:@"addSizeVoList"];
    [param setValue:addColorVoList forKey:@"addColorVoList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectStyleGoodsList:(NSString*) shopId styleId:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/styleGoodsDetail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:styleId forKey:@"styleId"];
    [param setValue:shopId forKey:@"shopId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) updateStyleGoods:(NSString*) styleId lastVer:(NSString*) lastVer synShopId:(NSString*) synShopId styleGoodsVo:(NSDictionary*) styleGoodsVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/updateStyleGoods"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [param setValue:styleId forKey:@"styleId"];
    [param setValue:lastVer forKey:@"lastVer"];
    [param setValue:synShopId forKey:@"synShopId"];
    [param setValue:styleGoodsVo forKey:@"styleGoodsVo"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) deleteStyleGoods:(NSString*) styleId lastVer:(NSString*) lastVer goodsId:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/deleteStyleGoods"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:styleId forKey:@"styleId"];
    [param setValue:lastVer forKey:@"lastVer"];
    [param setValue:goodsId forKey:@"goodsId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) setStyleGoodsPriceByGoods:(NSString*) styleId lastVer:(NSString*) lastVer synShopId:(NSString*) synShopId purchasePrice:(NSString*) purchasePrice memberPrice:(NSString*) memberPrice wholesalePrice:(NSString*) wholesalePrice retailPrice:(NSString*) retailPrice goodsIdList:(NSMutableArray*) goodsIdList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/unifySinglePrice"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:8];
    
    [param setValue:styleId forKey:@"styleId"];
    [param setValue:lastVer forKey:@"lastVer"];
    [param setValue:synShopId forKey:@"synShopId"];
    [param setValue:purchasePrice forKey:@"purchasePrice"];
    [param setValue:retailPrice forKey:@"retailPrice"];
    [param setValue:memberPrice forKey:@"memberPrice"];
    [param setValue:wholesalePrice forKey:@"wholesalePrice"];
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) setStyleGoodsPriceByColor:(NSString *)styleId lastVer:(NSString *)lastVer synShopId:(NSString *)synShopId purchasePrice:(NSString *)purchasePrice hangTagPrice:(NSString *)hangTagPrice memberPrice:(NSString *)memberPrice wholesalePrice:(NSString *)wholesalePrice retailPrice:(NSString *)retailPrice colorValList:(NSMutableArray *)colorValList completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/unifyColorPrice"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:9];
    
    [param setValue:styleId forKey:@"styleId"];
    [param setValue:lastVer forKey:@"lastVer"];
    [param setValue:synShopId forKey:@"synShopId"];
    [param setValue:purchasePrice forKey:@"purchasePrice"];
    
    if ([NSString isNotBlank:hangTagPrice]) {
        [param setValue:hangTagPrice forKey:@"hangTagPrice"];
    }
    [param setValue:retailPrice forKey:@"retailPrice"];
    [param setValue:memberPrice forKey:@"memberPrice"];
    [param setValue:wholesalePrice forKey:@"wholesalePrice"];
    [param setValue:colorValList forKey:@"colorValList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectStyleGoods:(NSString*) searchType shopId:(NSString*) shopId searchCodeType:(NSString*) searchCodeType searchCode:(NSString*) searchCode categoryId:(NSString*) categoryId createTime:(NSString*) createTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"style/styleGoodsList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [param setValue:searchType forKey:@"searchType"];
    
    if (![NSString isBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if (![NSString isBlank:searchCode]) {
        [param setValue:searchCode forKey:@"searchCode"];
    }
    if ([searchType isEqualToString:@"1"]) {
        [param setValue:searchCodeType forKey:@"searchCodeType"];
    }
    if (![NSString isBlank:categoryId]) {
        [param setValue:categoryId forKey:@"categoryId"];
    }
    if (![NSString isBlank:createTime]) {
        [param setValue:createTime forKey:@"createTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}



//批量添加微店商品
-(void) batchAddWechatGoods:(NSString *)shopId goodsIdList:(NSMutableArray*) goodsIdList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url=[NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/saveBatch"];
    NSLog(@"url:%@",url);
    NSLog(@"batchAddWechatGoods");
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}

//商品拆分组装加工
-(void)getGoodsInfo:(NSString *)path param:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,path];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

@end
