//
//  LSSaleProfitDetailController.h
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSSaleProfitDetailController : LSRootViewController
@property (nonatomic, strong) NSMutableDictionary   *param;
/** <#注释#> */
@property (nonatomic, copy) NSString *selectType;
@property (nonatomic, strong) NSString              *shopName;          /**门店名称*/
/**选中点的类型*/
@property (nonatomic, assign) NSInteger selectShopType;
/** <#注释#> */
@property (nonatomic, copy) NSString *saleMode;
@property (nonatomic, strong) NSString              *saleTime;          /**销售时间*/
@end
