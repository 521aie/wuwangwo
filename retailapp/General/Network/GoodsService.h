//
//  GoodsService.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpEngine.h"
#import "CategoryVo.h"
#import "AttributeVo.h"
#import "AttributeValVo.h"
#import "AttributeGroupVo.h"

@interface GoodsService : NSObject

//商品分类
- (void) selectCategoryList:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

- (void) saveCategory:(CategoryVo*) categoryVo operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

- (void) delCategory:(NSString*) categoryId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

- (void) exportCategory:(NSString*) email completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//叶子节点的类别一览
- (void) selectLastCategoryInfo:(NSString*) hasNoCategory completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

// 中品类查询
- (void) selectFirstCategoryInfo:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//商品店内码规则设置
- (void)selectInnerCodeSetting:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

- (void)closeInnerCodeSetting:(NSString*) isOpen completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

- (void)saveInnerCodeSetting:(NSMutableArray*) skuList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


//商品属性
- (void)selectAttributeList:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

- (void)delAttribute:(NSString*) attributeId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

- (void)saveAttribute:(NSString*) operateType attributeVo:(AttributeVo*) attributeVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void)selectAttributeTypeList:(NSString*) attributeId attributeType:(NSString*) attributeType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

- (void)saveAttributeVal:(NSString*) operateType baseAttributeType:(NSString*) baseAttributeType collectionType:(NSString *)collectionType attributeVal:(AttributeValVo*) attributeVal completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

- (void)delAttributeVal:(NSMutableArray*) attributeValVoList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) saveAttributeType:(NSString *)operateType attributeGroupVo:(AttributeGroupVo *)attributeGroupVo completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

- (void)delAttributeType:(NSString*) attributeGroupId lastVer:(NSString*) lastVer completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

// 属性分类排序
-(void) sortAttributeGroup:(NSString*) attributeNameId groupList:(NSMutableArray*) groupList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

// 属性值排序
-(void) sortAttributeVal:(NSString*) attributeGroupId groupList:(NSMutableArray*) valList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//基础属性值一览
-(void) selectBaseAttributeValList:(NSString *)baseAttributeType completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

//属性值换分类
-(void) changeAttributeCategory:(NSMutableArray*) attributeValVoList completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

//商品信息管理
//商品一览
/**
 * @searchType @"1" 按输入关键字查询 @"2" 按分类查询
 * @shopId  当前店铺/组织id
 * @searchCode 搜索关键字
 * @barCode 条形码
 * @categoryId 商品分类id
 @ @createTime 分页时间
 **/
-(void) selectGoodsList:(NSString *)searchType shopId:(NSString *)shopId searchCode:(NSString *)searchCode barCode:(NSString *)barCode categoryId:(NSString *)categoryId createTime:(NSString *)createTime validTypeList:(NSMutableArray*) validTypeList completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

// 积分商品添加的查询列表
- (void)selectNotGiftGoodsList:(NSString *)searchCode searchType:(NSString *)type currentPage:(NSInteger)page completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;


//商品数量
-(void) selectGoodsCount:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//商品详情
-(void) selectGoodsDetail:(NSString*) shopId goodsId:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

// 根据id查询商品基础信息
-(void) selectGoodsBaseInfo:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//商品条码、名称check
-(void) checkGoods:(NSString*) goodsId barcode:(NSString*) barcode name:(NSString*) name completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//商品新增/修改
-(void)saveGoodsDetail:(NSDictionary *)goodsVo operateType:(NSString *)operateType searchStatus:(id) searchStatus completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

//商品删除
-(void) deleteGoods:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//商品批量操作
//批量上下架
-(void) setUpDownStatus:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId status:(NSString *) status completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//批量设置微店销售
-(void) saveBatchMicroGoods:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//批量设置微店不销售
-(void) setNotSaleMicroGoods:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//商品批量销售设置
-(void) setGoodsBatchSales:(NSMutableArray*) goodsIdList percentage:(NSString*) percentage hasDegree:(NSString*) hasDegree isSales:(NSString*) isSales completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//品牌管理
//品牌一览
-(void) selectBrandList:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//品牌删除
-(void) delBrand:(NSString*) goodsBrandId lastVer:(NSString*) lastVer completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//新增or修改品牌
-(void) saveBrand:(NSString*) operateType goodsBrand:(NSDictionary*) goodsBrand completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店管理
//微店商品详情
-(void) selectMicroGoodsDetail:(NSString*) shopId goodsId:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//添加or更新微店商品详情
//-(void) saveMicroGoodsDetail:(NSString*) operateType microGoodsVo:(NSDictionary*) microGoodsVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店图片详情保存
-(void) saveMicroGoodsPictures:(NSDictionary*) microGoodsVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店图片详情查询
-(void) selectInfoImageList:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店价格详情查询
-(void) selectMicroPriceDetail:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店关联价格保存
-(void) saveMicroPriceDetail:(NSMutableArray*) goodsIdList minSaleDiscountRate:(NSString*) minSaleDiscoutRate maxSupplyDiscountRate:(NSString*) maxSupplyDiscountRate completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//款式
//获取款式种数
-(void) selectStyleCount:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//款式检索
- (void)selectStyleList:(NSMutableDictionary*) condition completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//款号冲突检索
-(void) checkStyleCode:(NSString*) operateType styleId:(NSString*) styleId styleCode:(NSString*) styleCode completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//添加or更新款式
-(void) saveStyleDetail:(NSDictionary*) styleVo shopId:(NSString *)shopId synPriceFlg:(NSString*) synPriceFlg token:(NSString *)token completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

// 查询款式基础信息
-(void) selectStyleBaseInfo:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//查询款式详情
-(void) selectStyleDetail:(NSString*) shopId styleId:(NSString*) styleId distributionId:(NSString*) distributionId sourceId:(NSString*) sourceId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//删除款式
-(void) deleteStyle:(NSString*) shopId styleIdList:(NSMutableArray*) styleIdList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//批量款式上下架
-(void) setStyleUpDownStatus:(NSMutableArray*) styleIdList shopId:(NSString*) shopId status:(NSString *) status completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//款式批量销售设置
-(void) setStyleBatchSales:(NSMutableArray*) styleIdList percentage:(NSString*) percentage hasDegree:(NSString*) hasDegree isSales:(NSString*) isSales completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//款式微店价格详情查询
-(void) selectMicroPriceDetailOfStyle:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//款式微店关联价格保存
-(void) saveMicroPriceDetailOfStyle:(NSMutableArray*) styleIdList minSaleDiscountRate:(NSString*) minSaleDiscountRate maxSupplyDiscountRate:(NSString*) maxSupplyDiscountRate completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//添加款式商品
-(void) saveStyleGoods:(NSString*) styleId lastVer:(NSString*) lastVer addColorVoList:(NSMutableArray*) addColorVoList addSizeVoList:(NSMutableArray*) addSizeVoList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//查询款式商品
-(void) selectStyleGoodsList:(NSString*) shopId styleId:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//更新款式商品
-(void) updateStyleGoods:(NSString*) styleId lastVer:(NSString*) lastVer synShopId:(NSString*) synShopId styleGoodsVo:(NSDictionary*) styleGoodsVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//更新款式商品
-(void) deleteStyleGoods:(NSString*) styleId lastVer:(NSString*) lastVer goodsId:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//根据款式商品设置款式商品价格
-(void) setStyleGoodsPriceByGoods:(NSString*) styleId lastVer:(NSString*) lastVer synShopId:(NSString*) synShopId purchasePrice:(NSString*) purchasePrice memberPrice:(NSString*) memberPrice wholesalePrice:(NSString*) wholesalePrice retailPrice:(NSString*) retailPrice goodsIdList:(NSMutableArray*) goodsIdList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//根据款式商品颜色设置款式商品价格
-(void) setStyleGoodsPriceByColor:(NSString*) styleId lastVer:(NSString*) lastVer synShopId:(NSString*) synShopId purchasePrice:(NSString*) purchasePrice hangTagPrice:(NSString*) hangTagPrice memberPrice:(NSString*) memberPrice wholesalePrice:(NSString*) wholesalePrice retailPrice:(NSString*) retailPrice colorValList:(NSMutableArray*) colorValList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//查询款式商品
-(void) selectStyleGoods:(NSString*) searchType shopId:(NSString*) shopId searchCodeType:(NSString*) searchCodeType searchCode:(NSString*) searchCode categoryId:(NSString*) categoryId createTime:(NSString*) createTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//批量添加微店商品
-(void) batchAddWechatGoods:(NSString *)shopId goodsIdList:(NSMutableArray*) goodsIdList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//商品拆分组装加工
-(void)getGoodsInfo:(NSString *)path param:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;
@end
