//
//  LSWechatGoodSortController.h
//  retailapp
//
//  Created by taihangju on 2017/3/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
// 微店中商品品类选择页面
#import "BaseViewController.h"

// 分类名称：LSWechatGoodSortName 实体店分类名 LSWechatGoodSortMicroname：微店别名
typedef NS_ENUM(NSInteger ,LSWechatGoodSortNameType) {
    LSWechatGoodSortName,
    LSWechatGoodSortMicroname,
};

@interface LSWechatGoodSortController : BaseViewController


/**
 服鞋：中品类， 商超：分类

 @param option 初始选择的分类
 @param type 分类名称：实体店分类名还是微店别名
 @param block 选择分类后的回调block
 @return LSWechatGoodSortController 实例
 */
- (instancetype)initWith:(NSString *)option sortNameType:(LSWechatGoodSortNameType)type  block:(void(^)())block;
@end
