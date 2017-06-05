//
//  LSEmployeeFilterModelFactory.m
//  retailapp
//
//  Created by taihangju on 2017/2/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSEmployeeFilterModelFactory.h"
#import "TDFFilterMoel.h"

@implementation LSEmployeeFilterModelFactory

//+ (NSArray<TDFFilterMoel *> *)employeeListViewFilterModels {
//    
//    TDFTwiceCellModel *dateModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellOneLine optionName:@"机构/门店" hideStatus:NO];
//    dateModel.arrowImageName = @"ico_next_down";
//    dateModel.restName = @"请选择";
//    
//    NSMutableArray *options = [NSMutableArray arrayWithCapacity:4];
//    TDFRegularCellModel *gradeModel = [[TDFRegularCellModel alloc] initWithOptionName:@"评价等级" hideStatus:NO];
//    [options addObject:[TDFFilterItem filterItem:@"全部" itemValue:nil]];
//    [options addObject:[TDFFilterItem filterItem:@"好评" itemValue:@1]];
//    [options addObject:[TDFFilterItem filterItem:@"中评" itemValue:@2]];
//    [options addObject:[TDFFilterItem filterItem:@"差评" itemValue:@3]];
//    gradeModel.optionItems = [options copy];
//    gradeModel.resetItemIndex = 0;
//    _filterModels = @[dateModel ,gradeModel];
//}
@end
