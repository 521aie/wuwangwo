//
//  TDFComplexConditionFilter.h
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/9.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import "TDFBaseConditionFilter.h"


@interface TDFComplexConditionFilter : TDFBaseConditionFilter

- (void)addToView:(UIView *)view withDatas:(NSArray *)dataList;
- (void)renewListViewWithDatas:(NSArray *)dataList;
@end



