//
//  LSWeChatFilterModelFactory.m
//  retailapp
//
//  Created by taihangju on 2017/2/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSWeChatFilterModelFactory.h"
#import "TDFFilterMoel.h"

@implementation LSWeChatFilterModelFactory

+ (NSArray<TDFFilterMoel *> *)wechatSellOrderListViewFilterModels {
    
    // 订单状态筛选
    TDFRegularCellModel *orderStatusModel = [[TDFRegularCellModel alloc] initWithOptionName:@"订单状态" hideStatus:NO];
    
    NSMutableArray *optionArray = [NSMutableArray arrayWithCapacity:10];
    [optionArray addObject:[TDFFilterItem filterItem:@"全部" itemValue:nil]];
//    if ([[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"] ||  [[Platform Instance] getShopMode] == 2) {
        //总部用户和门店
        TDFFilterItem *item = [TDFFilterItem filterItem:@"待付款" itemValue:@11];
        [optionArray addObject:item];
//    }
    
//    if ([[Platform Instance] isTopOrg]) {//连锁总部才有待分配
//        TDFFilterItem *item = [TDFFilterItem filterItem:@"待分配" itemValue:@13];
//        [optionArray addObject:item];
//    }
    
    [optionArray addObject:[TDFFilterItem filterItem:@"待处理" itemValue:@15]];
    [optionArray addObject:[TDFFilterItem filterItem:@"配送中" itemValue:@20]];
    [optionArray addObject:[TDFFilterItem filterItem:@"配送完成" itemValue:@24]];
    [optionArray addObject:[TDFFilterItem filterItem:@"交易成功" itemValue:@21]];
    [optionArray addObject:[TDFFilterItem filterItem:@"拒绝配送" itemValue:@16]];
//    [optionArray addObject:[TDFFilterItem filterItem:@"配送中" itemValue:@20]];

//    if ([[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]) {//总部用户
       [optionArray addObject:[TDFFilterItem filterItem:@"交易取消" itemValue:@22]];
//    }
    [optionArray addObject:[TDFFilterItem filterItem:@"交易关闭" itemValue:@23]];
    orderStatusModel.optionItems = [optionArray copy];
    
    // 默认选项
    orderStatusModel.resetItemIndex = [TDFFilterItem indexInArray:optionArray withItemName:@"待处理"];

   
    // 订单日期筛选
    TDFTwiceCellModel *orderDateModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellOneLine optionName:@"订单日期" hideStatus:NO];;
    orderDateModel.restName = @"请选择";
    orderDateModel.arrowImageName = @"ico_next_down";
    return @[orderStatusModel, orderDateModel];
}

+ (NSArray<TDFFilterMoel *> *)wechatIntegralExchangeOrderListViewFilterModels {
    // 订单状态筛选
    TDFRegularCellModel *orderStatusModel = [[TDFRegularCellModel alloc] initWithOptionName:@"订单状态" hideStatus:NO];
    NSMutableArray *optionArray = [NSMutableArray arrayWithCapacity:3];
    [optionArray addObject:[TDFFilterItem filterItem:@"全部" itemValue:nil]];
    [optionArray addObject:[TDFFilterItem filterItem:@"待处理" itemValue:@15]];
    [optionArray addObject:[TDFFilterItem filterItem:@"配送中" itemValue:@20]];
    [optionArray addObject:[TDFFilterItem filterItem:@"交易成功" itemValue:@21]];
    orderStatusModel.optionItems = [optionArray copy];
    orderStatusModel.resetItemIndex = 1; // 默认选项“待处理”
    
    // 订单日期筛选
    TDFTwiceCellModel *orderDateModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellOneLine optionName:@"订单日期" hideStatus:NO];
    orderDateModel.restName = @"请选择";
    orderDateModel.arrowImageName = @"ico_next_down";
    return @[orderStatusModel, orderDateModel];
}

+ (NSArray<TDFFilterMoel *> *)wechatSellReturnListViewFilterModels {
    
    // 订单状态筛选
    TDFRegularCellModel *orderStatusModel = [[TDFRegularCellModel alloc] initWithOptionName:@"订单状态" hideStatus:NO];
    
    NSMutableArray *optionArray = [NSMutableArray arrayWithCapacity:10];
    [optionArray addObject:[TDFFilterItem filterItem:@"全部" itemValue:@0]];
    [optionArray addObject:[TDFFilterItem filterItem:@"待审核" itemValue:@1]];
    [optionArray addObject:[TDFFilterItem filterItem:@"同意退货" itemValue:@3]];
    [optionArray addObject:[TDFFilterItem filterItem:@"退货中" itemValue:@4]];
    [optionArray addObject:[TDFFilterItem filterItem:@"待退款" itemValue:@5]];
    [optionArray addObject:[TDFFilterItem filterItem:@"退款成功" itemValue:@2]];
    [optionArray addObject:[TDFFilterItem filterItem:@"拒绝退货" itemValue:@6]];
    [optionArray addObject:[TDFFilterItem filterItem:@"拒绝退款" itemValue:@7]];
    [optionArray addObject:[TDFFilterItem filterItem:@"取消退货" itemValue:@8]];
    orderStatusModel.optionItems = [optionArray copy];
    orderStatusModel.resetItemIndex = [TDFFilterItem indexInArray:optionArray withItemName:@"待审核"]; // 默认选项“待处理”
    
    // 订单日期筛选
    TDFTwiceCellModel *orderDateModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellOneLine optionName:@"退货日期" hideStatus:NO];
    orderDateModel.restName = @"请选择";
    orderDateModel.arrowImageName = @"ico_next_down";
    return @[orderStatusModel, orderDateModel];
}

+ (NSArray<TDFFilterMoel *> *)wechatReturnMoneyListViewFilterModels {
    
    // 订单状态筛选
    TDFRegularCellModel *orderStatusModel = [[TDFRegularCellModel alloc] initWithOptionName:@"订单状态" hideStatus:NO];
    
    NSMutableArray *optionArray = [NSMutableArray arrayWithCapacity:3];
    [optionArray addObject:[TDFFilterItem filterItem:@"全部" itemValue:@0]];
    [optionArray addObject:[TDFFilterItem filterItem:@"待退款" itemValue:@5]];
    [optionArray addObject:[TDFFilterItem filterItem:@"退款成功" itemValue:@2]];
    orderStatusModel.optionItems = [optionArray copy];
    orderStatusModel.resetItemIndex = 1; // 默认选项“待退款”
    
    // 订单日期筛选
    TDFTwiceCellModel *orderDateModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellOneLine optionName:@"退货日期" hideStatus:NO];
    orderDateModel.restName = @"请选择";
    orderDateModel.arrowImageName = @"ico_next_down";
    return @[orderStatusModel, orderDateModel];
}

+ (NSArray<TDFFilterMoel *> *)wechatVirtualStockSetListViewFilterModels {
    
    BOOL isCloMode = [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101;
    if (isCloMode) {
        // 微店品类
        TDFTwiceCellModel *cateModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellOneLine optionName:@"微店中品类" hideStatus:NO];
        cateModel.restName = @"全部";
        cateModel.arrowImageName = @"ico_next";
        
        // 性别
        TDFRegularCellModel *sexModel = [[TDFRegularCellModel alloc] initWithOptionName:@"性别" hideStatus:NO];
        NSMutableArray *optionArray = [NSMutableArray arrayWithCapacity:3];
        [optionArray addObject:[TDFFilterItem filterItem:@"全部" itemValue:@0]];
        [optionArray addObject:[TDFFilterItem filterItem:@"男" itemValue:@1]];
        [optionArray addObject:[TDFFilterItem filterItem:@"女" itemValue:@2]];
        [optionArray addObject:[TDFFilterItem filterItem:@"中性" itemValue:@3]];
        sexModel.optionItems = [optionArray copy];
        sexModel.resetItemIndex = 0; // 默认选项“待处理”
        
        // 日期
        TDFTwiceCellModel *dateModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellOneLine optionName:@"年份" hideStatus:NO];
        dateModel.restName = @"可不填";
        dateModel.arrowImageName = @"ico_next_down";
        
        // 季节
        TDFRegularCellModel *seasonModel = [[TDFRegularCellModel alloc] initWithOptionName:@"季节" hideStatus:NO];
        NSMutableArray *seasons = [NSMutableArray arrayWithCapacity:3];
        [seasons addObject:[TDFFilterItem filterItem:@"全部" itemValue:[NSNull null]]];
        seasonModel.optionItems = [seasons copy];
        seasonModel.resetItemIndex = 0; // 默认选项“全部”
//        seasonModel.currentHideStatus = YES; // 获取到季节才会显示
    
        
        // 可销售数量
        TDFInterValCellModel *interValModel = [[TDFInterValCellModel alloc] initWithOptionName:@"可销售数量区间" hideStatus:NO];
        interValModel.lowPlaceholder =  @"最低数";
        interValModel.highPlaceholder = @"最高数";
        return @[cateModel,sexModel,dateModel,seasonModel,interValModel];
        
    } else {
        
        TDFTwiceCellModel *cateModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellOneLine optionName:@"微店分类" hideStatus:NO];
        cateModel.restName = @"全部";
        cateModel.arrowImageName = @"ico_next";
        
        TDFInterValCellModel *interValModel = [[TDFInterValCellModel alloc] initWithOptionName:@"可销售数量区间" hideStatus:NO];
        interValModel.lowPlaceholder =  @"最低数";
        interValModel.highPlaceholder = @"最高数";
        return @[cateModel,interValModel];
    }
    return nil;
}

@end
