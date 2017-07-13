//
//  TDFFilterMoel.h
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/16.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,TDFFilterCellType){
    TDF_TwiceFilterCellOneLine,
    TDF_TwiceFilterCellTwoLine,
    TDF_IntervalFilterCell,
    TDF_RegularFilterCell
};

typedef NS_ENUM(NSInteger ,TDFFilterAction) {
    TDF_Action_None,               // 默认状态，无操作状态
    TDF_Action_EditLowRange,       // 编辑TDFIntervalFilterCell低区间
    TDF_Action_EditHighRange,      // 编辑TDFInterValFilterCell高区间
};

@interface TDFFilterMoel : NSObject

@property (nonatomic ,assign) TDFFilterCellType type;/**<指定cell类型样式>*/
@property (nonatomic ,strong) NSString *optionName;/**<筛选类型：如订单状态>*/
@property (nonatomic ,assign) BOOL currentHideStatus;/**<当前隐藏与否>*/

- (instancetype)initWithOptionName:(NSString *)optionName hideStatus:(BOOL)status;
- (void)resetSelf;
@end


@interface TDFFilterItem : NSObject

@property (nonatomic ,strong) NSString *itemName;/**<选项名称>*/
@property (nonatomic ,strong) id itemValue;/**<选项对应的真实值>*/

+ (instancetype)filterItem:(NSString *)itemName itemValue:(id)value;

/**
 获取array数组中和itemName对应的对象的index
 */
+ (NSInteger)indexInArray:(NSArray<TDFFilterItem *> *)array withItemName:(NSString *)itemName;
@end

@interface TDFInterValCellModel : TDFFilterMoel

@property (nonatomic ,strong) NSString *lowPlaceholder;/**<区间左边界说明>*/
@property (nonatomic ,strong) NSString *lowRange;/**<区间左边界值>*/
@property (nonatomic ,strong) NSString *highPlaceholder;/**<区间右边界说明>*/
@property (nonatomic ,strong) NSString *highRange;/**<区间右边界值>*/
@property (nonatomic ,assign) TDFFilterAction currentAction;/**<当前的action状态>*/

- (NSString *)noticeTitle;
- (NSString *)currentNumberString;
@end

@interface TDFRegularCellModel : TDFFilterMoel

@property (nonatomic ,strong) NSArray<TDFFilterItem *> *optionItems;/**<选项列表>*/
@property (nonatomic ,assign) NSInteger resetItemIndex;/**<默认选项,在optionItems中的index>*/
@property (nonatomic ,assign) NSInteger selectItemIndex;/**<选中选项，在optionItems中的序index>*/
@property (nonatomic ,strong ,readonly) id currentValue;/**<当前选中项对应的真实值>*/
@property (nonatomic ,assign) BOOL updateOption;/**<是否更新选项>*/
@end

@interface TDFTwiceCellModel : TDFFilterMoel

@property (nonatomic ,strong) NSString *restName;/**<默认选项名>*/
@property (nonatomic ,strong) id restValue;/**<默认值>*/
@property (nonatomic ,strong) NSString *currentName;/**<当前选项名>*/
@property (nonatomic ,strong) id currentValue;/**<当前值>*/
@property (nonatomic ,strong) NSString *arrowImageName;/**<指示箭头图标名称>*/

- (instancetype)initWithType:(TDFFilterCellType)type optionName:(NSString *)optionName hideStatus:(BOOL)status;
@end
