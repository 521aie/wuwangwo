//
//  SortTableView.h
//  retailapp
//
//  Created by guozhi on 16/2/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortTableViewCell2.h"
typedef void (^SetCellContext)(SortTableViewCell2 *cell,NSIndexPath *indexPath);
typedef void (^OnRightClick)(NSMutableArray *datas);
@interface SortTableView2 : BaseViewController
/*
 *
 *  datas        需要排序的数据源
 *  onRightBtnClick   点击保存按钮需要执行的代码 datas 排序后的数据源
 *  setCellContext    排序显示的内容 cell 单元格 indexPath 位置
 *
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil datas:(NSMutableArray *)datas onRightBtnClick:(OnRightClick)onRightBtnClick setCellContext:(SetCellContext)setCellContext;

@end
