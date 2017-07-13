//
//  TDFRegularFilterCell.h
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/13.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDFFilterItem,TDFRegularCellModel;
@interface TDFRegularFilterCell : UITableViewCell

@property (nonatomic ,strong) UILabel *itemName;/**<筛选项>*/
@property (nonatomic ,strong) UIView *bottomLine;/**<>*/
/**<选择某一选项后回调>*/
@property (nonatomic ,copy) void (^selectedCallBack)(TDFRegularCellModel *model);

/**
 TDFRegularFilterCell：用于多选一的情形，选项是固定的
 @param tableView 被添加到的UITableView
 @param model cell需要的数据 ，
 @return TDFRegularFilterCell 实例
 */
+ (instancetype)tdf_FilterCellWithTableView:(UITableView *)tableView data:(id)model;

/**
 重置到初始化时的状态
 */
- (void)tdf_FilterCellReset;
@end
