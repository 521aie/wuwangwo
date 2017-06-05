//
//  SelectGoodsList.h
//  retailapp
//
//  Created by guozhi on 16/2/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class GoodsOperationVo,SelectGoodsItem;
typedef void (^GoodsInfoBlock)(GoodsOperationVo *goodsOperationVo);
@interface SelectGoodsList : LSRootViewController
/*
 *    isBig            参数用来区分是大件商品小件商品
 *    fileType         参数用来区分是商品拆分商品组装商品加工的请求
 *    item             用来区分是哪个对象的请求
 *    goodsInfoBlock   代码回调会传回一个对象和对象的数据
 *    list             已添加的商品
 */
- (instancetype)initWithBig:(BOOL)isBig fileType:(int)fileType searchCodeList:(NSMutableArray *)list goodsIndoBlock:(GoodsInfoBlock)goodsInfoBlock;
@end
