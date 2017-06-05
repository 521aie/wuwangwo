//
//  HistoryPaperListView.h
//  retailapp
//
//  Created by hm on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

typedef void(^SelectPaperHandler)(NSString* paperId, NSString *recordType, id json);

typedef NS_ENUM(NSInteger, HistoryPaperListViewType) {
    //默认查询的是历史采购单 历史入库单 历史退货单列表 商超点击查询会返回相应的单据id 服鞋点击历史单据会报提示导入后将生成一张新的*****单!点击确认后会生成一条新的单据并且返回单据id
    HistoryPaperListViewTypeHistoryPurchase,//历史采购单导入 服鞋 从历史采购单导入生成一条新的采购单 商超查询历史采购单
    HistoryPaperListViewTypeHistoryIn, //历史入库单导入 服鞋 从历史入库单导入生成一条新的收货入库单 商超查询历史入库单
    
    HistoryPaperListViewTypeHistoryReturn, //历史退货单导入 服鞋 从历史退货单导入生成一条新的退货出库单 商超查询历史退货单
    
    HistoryPaperListViewTypeHistoryFromInToReturn, //历史入库单导入 服鞋 从历史入库单单导入生成一条新的退货出库单 商超服鞋查询历史入库单
};

@interface HistoryPaperListView : LSRootViewController


/**
 *  设置页面参数
 *
 *  @param paperId   单据id
 *  @param paperType 单据类型
 *  @param callBack  回调block
 */
- (void)loadPaperId:(NSString*)paperId withType:(HistoryPaperListViewType)paperType callBack:(SelectPaperHandler)callBack;
@end
