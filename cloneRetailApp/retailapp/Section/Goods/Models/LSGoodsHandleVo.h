//
//  LSGoodsHandleVo.h
//  retailapp
//
//  Created by guozhi on 16/2/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LSOldGoodsVo : NSObject
/**老商品条码*/
@property (nonatomic, copy) NSString *barCode;
/**老商品ID*/
@property (nonatomic, copy) NSString *goodsId;
/**老商品名称*/
@property (nonatomic, copy) NSString *goodsName;
/**老商品数量*/
@property (nonatomic, strong) NSNumber *oldGoodsNum;
+ (instancetype)oldGoodsVoWithDict:(NSDictionary *)dict;
@end



@interface LSGoodsHandleVo : NSObject
/**商品操作Id*/
@property (nonatomic, copy) NSString *goodsHandId;
/**操作区分*/
@property (nonatomic, strong) NSNumber *handleType;
/**版本号*/
@property (nonatomic, strong) NSNumber *lastVer;
/**大件商品类别check*/
@property (nonatomic, strong) NSNumber *checkType;
/**备注*/
@property (nonatomic, copy) NSString *memo;
/**新商品条码*/
@property (nonatomic, copy) NSString *goodsBarCode;
/**新商品ID*/
@property (nonatomic, copy) NSString *goodsId;
/**新商品名称*/
@property (nonatomic, copy) NSString *goodsName;
/**新商品数量*/
@property (nonatomic, strong) NSNumber *goodsNum;
/**旧商品列表*/
@property (nonatomic, strong) NSMutableArray *oldGoodsList;
/**新商品销售价*/
@property (nonatomic, strong) NSNumber *retailPrice;
+ (instancetype)goodsHandleVoWithDict:(NSDictionary *)dict;
@end
