//
//  LSGoodsSaleListController.h
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSGoodsSaleListController : LSRootViewController
@property (nonatomic ,strong) NSString *titleName;/*<商品销售报表：分类，品牌名称>*/
@property (nonatomic, strong) NSMutableDictionary *param;/*<从上一个界面传递来的参数>*/
@end
