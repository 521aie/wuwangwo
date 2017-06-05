//
//  TDFIntervalFilterCell.h
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/10.
//  Copyright © 2017年 2dfire. All rights reserved.
//  区间选择

#import <UIKit/UIKit.h>

@class TDFInterValCellModel;
@interface TDFIntervalFilterCell : UITableViewCell

@property (nonatomic ,strong) UILabel *itemName;/**<筛选项>*/
@property (nonatomic ,strong) UITextField *lowRangeTextField;/**<低区间>*/
@property (nonatomic ,strong) UITextField *highRangeTextField;/**<高区间>*/
@property (nonatomic ,strong) UIView *bottomLine;/**<>*/
/**<点击开始编辑时调用>*/
@property (nonatomic ,copy) void (^editActionBlock)(TDFInterValCellModel *model);

/**
 
 TDFIntervalFilterCell：用于区间限制
 @param tableView 被添加到的UITableView
 @param model cell需要的数据
 @return TDFIntervalFilterCell 实例
 */
+ (instancetype)tdf_FilterCellWithTableView:(UITableView *)tableView data:(id)model;

/**
 重置到初始化时的状态
 */
- (void)tdf_FilterCellReset;
@end
