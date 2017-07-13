//
//  GoodsGiftVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameValueItem.h"

@interface GoodsGiftVo : Jastor

@property (nonatomic, strong) NSString *goodsId;/**<商品ID*/

@property (nonatomic, strong) NSString *name;/**<商品名称*/

@property (nonatomic, strong) NSString *barCode;/**<商品条码*/

@property (nonatomic, strong) NSString *innerCode;/**<内部编码*/

@property (nonatomic) NSInteger point;/**<所需积分*/

@property (nonatomic) NSInteger number;/**<商品数量*/

@property (nonatomic) double price;/**<商品价格*/

@property (nonatomic, strong) NSString *picture;/**<商品图片*/

@property (nonatomic, strong) NSString *isCheck;/**<是否选中*/

@property (nonatomic, strong) NSString *goodsColor;/**<商品颜色*/

@property (nonatomic, strong) NSString *goodsSize;/**<商品尺码*/

+(GoodsGiftVo*)convertToGoodsGiftVo:(NSDictionary*)dic;

+ (NSDictionary*)getDictionaryData:(GoodsGiftVo *)goodsGiftVo;

@end
