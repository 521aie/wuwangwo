//
//  SortTableView.h
//  retailapp
//
//  Created by guozhi on 16/2/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "SortTableViewCell.h"
typedef void (^SetCellContext)(SortTableViewCell *cell,id obj);
typedef void (^OnRightClick)(NSMutableArray *datas);
@interface SortTableView : LSRootViewController
@property (nonatomic, copy) NSString *titleStr;
/*
 *
 *  datas        需要排序的数据源
 *  onRightBtnClick   点击保存按钮需要执行的代码 datas 排序后的数据源
 *  setCellContext    排序显示的内容 cell 单元格 indexPath 位置
 *
 */
- (instancetype)initWithDatas:(NSMutableArray *)datas onRightBtnClick:(OnRightClick)onRightBtnClick setCellContext:(SetCellContext)setCellContext;

@end
