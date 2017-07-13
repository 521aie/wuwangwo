//
//  GoodsOperationVo.h
//  retailapp
//
//  Created by guozhi on 16/2/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsOperationVo : NSObject
/**价钱*/
@property (nonatomic, copy) NSString *retailPrice;
/**商品名字*/
@property (nonatomic, copy) NSString *goodsName;
/**图片路径*/
@property (nonatomic, copy) NSString *filePath;
/**商品条形码*/
@property (nonatomic, copy) NSString *barCode;
/**商品id*/
@property (nonatomic, copy) NSString *goodsId;
/**商品类型*/
@property (nonatomic, strong) NSNumber *type;
- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
