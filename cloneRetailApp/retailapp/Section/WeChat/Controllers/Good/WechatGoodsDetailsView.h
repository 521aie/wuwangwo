//
//  GoodsMicroEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WechatGoodsDetailsView : UIViewController

@property (nonatomic, strong) NSString* shopId;
@property (nonatomic, strong) NSString* goodsId;
/**<门店登录synShopEntityId为null, 连锁登录时  选择不同步传0  如果同步则传选择的门店或者机构的ShopEntityId>*/
@property (nonatomic, strong) NSString *synShopEntityId;

/**
 *  模式 编辑 ACTION_CONSTANTS_EDIT 添加 ACTION_CONSTANTS_ADD
 */
@property (nonatomic, assign) int action;
@end
