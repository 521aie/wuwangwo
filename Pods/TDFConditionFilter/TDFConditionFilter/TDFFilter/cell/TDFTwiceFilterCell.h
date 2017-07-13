//
//  TDFTwiceFilterCell.h
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/13.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDFTwiceCellModel;
@interface TDFTwiceFilterCell : UITableViewCell

@property (nonatomic ,copy) void (^showSelectPage)(TDFTwiceCellModel *model);/**<<#说明#>>*/

/**
 TDFTwiceFilterCell：用于不定选项的情形，选项需另外获取，另外的界面来展示
 @param tableView 被添加到的UITableView
 @param model cell需要的数据
 @return TDFTwiceFilterCell 实例
 */
+ (instancetype)tdf_FilterCellWithTableView:(UITableView *)tableView data:(id)model;
- (void)tdf_FilterCellReset;
@end
