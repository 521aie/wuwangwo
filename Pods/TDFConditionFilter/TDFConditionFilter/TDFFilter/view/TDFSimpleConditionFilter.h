//
//  TDFSimpleConditionFilter.h
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/9.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFBaseConditionFilter.h"

typedef NS_ENUM(NSInteger ,TDFFilterHeaderType) {
    TDFFilterHeader_SuppilerCategory, // “供应商类别”头部样式
};

@interface TDFSimpleConditionFilter : TDFBaseConditionFilter

@property (nonatomic, strong, setter=setFilterItems:) NSArray *itemArray;/**<选项列表>*/

- (void)addToView:(UIView *)superView items:(NSArray<TDFFilterItem *> *)array callBack:(void(^)(TDFFilterItem *))block;
- (void)configHeader:(TDFFilterHeaderType)headerType headerAction:(void(^)())block;
@end
