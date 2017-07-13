//
//  MemberRechargeList.h
//  retailapp
//
//  Created by 果汁 on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"
#import "NavigateTitle2.h"

@class NavigateTitle2,ReportService,PaperFooterListView;
@interface MemberRechargeList : BaseViewController<INavigateEvent,UITableViewDataSource,UITableViewDelegate,FooterListEvent> {
    ReportService *service;//网络请求
}
/**查询会员充值记录列表所需要的参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/**导出页面所需要的参数*/
@property (nonatomic, strong) NSMutableDictionary *exportParam;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UITableView *mainGrid;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
/**分页标志*/
@property (nonatomic, assign) NSInteger pageNum;
/**查询会员充值记录总数*/
//@property (nonatomic, strong) NSMutableArray *memberRechargeListVos;
/**查询会员充值记录日期数*/
@property (nonatomic, strong) NSMutableArray *dates;
/**查询会员充值记录列表数据源*/
@property (nonatomic, strong) NSMutableDictionary *dict;
/**  后台返回数量需要传给后台 Integer*/
@property (nonatomic, strong) NSNumber *startNum;
/**  是否查询搜索引擎需要传给后台  Boolean*/
@property (nonatomic, strong) NSNumber *isFromSolr;
/**获得会员充植记录日期*/
//@property (nonatomic, strong) NSMutableDictionary *dateDict;
@property (weak, nonatomic) IBOutlet PaperFooterListView *footView;
@end
