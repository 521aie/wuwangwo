//
//  LSWechatHomeSetGoodListViewController.h
//  retailapp
//
//  Created by guozhi on 16/8/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MicroWechatGoodsVo;
typedef void(^CallBlock)(MicroWechatGoodsVo *microWechatGoodsVo);
@interface LSWechatHomeSetGoodListViewController : UIViewController
/**
 *  seaechType 1：按输入关键字查询 2：按筛选条件查询
 */
@property (nonatomic, assign) int searchType;
/**
 *  搜索关键字
 */
@property (nonatomic, strong) NSString *searchCode;
/**
 *  扫码关键字
 */
@property (nonatomic, strong) NSString *scanCode;
@property (nonatomic, strong) NSString *barCode;
@property (nonatomic, assign) long createTime;

@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSMutableDictionary* condition;

@property (nonatomic, copy) NSString *saleCount;
@property (nonatomic, copy) CallBlock callBlock;
- (instancetype)initWithBlock:(CallBlock)callBlock;
- (void)selectMicGoodsList;
@end
