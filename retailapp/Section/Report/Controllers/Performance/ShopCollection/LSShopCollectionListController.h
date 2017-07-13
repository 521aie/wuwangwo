//
//  LSShopCollectionListController.h
//  retailapp
//
//  Created by guozhi on 2016/11/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSShopCollectionListController : LSRootViewController
/** 是否显示下一个图标可以点击进入下一个页面若选择的来源是全部、微店，不支持点击支付方式栏进入详情页 */
@property (nonatomic, assign, getter=isShow) BOOL show;
@property (nonatomic, strong) NSMutableDictionary *param;
/** 是否是今天查询  只有今天的才有手动生成 */
@property (nonatomic, assign) BOOL isToday;
@end
