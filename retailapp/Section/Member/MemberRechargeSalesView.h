//
//  MemberRechargeSalesView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleListView.h"
@class MemberService, SaleRechargeVo;
@interface MemberRechargeSalesView : SampleListView<ISampleListEvent>

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void)loadDatas;

-(void)loadDatasFromEdit:(SaleRechargeVo*) saleRechargeVo action:(int) action;

-(void)selectRechargeSalesList;

@end
