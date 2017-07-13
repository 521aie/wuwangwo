//
//  LSMarketListController.h
//  retailapp
//
//  Created by guozhi on 2016/10/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMarketListController : UIViewController

- (instancetype)initWithAction:(int)action;

// 从促销活动页面返回
- (void)loadDatasFromEditView:(int)action;

// 从促销规则页面返回
- (void)loadDatasFromSalesRegulationEditView:(int)action salesId:(NSString *)salesId;
@end
