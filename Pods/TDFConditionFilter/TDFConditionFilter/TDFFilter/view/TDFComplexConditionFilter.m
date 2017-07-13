//
//  TDFComplexConditionFilter.m
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/9.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import "TDFComplexConditionFilter.h"
#import "TDFIntervalFilterCell.h"
#import "TDFRegularFilterCell.h"
#import "TDFTwiceFilterCell.h"


@interface TDFComplexConditionFilter ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic ,strong) UIButton *resetButton;/**<重置按钮>*/
@property (nonatomic ,strong) UIButton *confirmButton;/**<确认按钮>*/
@property (nonatomic ,strong) NSArray *dataList;/**<>*/
@end

@implementation TDFComplexConditionFilter

- (instancetype)initFilter:(NSString *)title image:(NSString *)imageName highlightImage:(NSString *)highlightImageName {
    
    self = [super initFilter:title image:imageName highlightImage:highlightImageName];
    if (self) {
        
        CGFloat levelMargin = 10.0;
        CGFloat tableInsetDy = 64.0;
        CGFloat buttonHeight = 34.0;
        UIView *rightView = self.tableView.superview;
        CGFloat baseWidth = CGRectGetWidth(rightView.frame);
        CGFloat baseHeight = CGRectGetHeight(rightView.frame);
        CGFloat interval = 10.0; // 重置button 和 确认button 的水平间距
        CGFloat buttonWidth = (baseWidth - 2*(levelMargin+5) - interval)/2; // button的宽度
        
        // 调整tableView 的高度
        self.tableView.frame = CGRectMake(levelMargin, tableInsetDy, baseWidth-2*levelMargin, baseHeight-2*tableInsetDy);
        
        // 设置底部分割线
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(levelMargin, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(rightView.frame)-2*levelMargin, 1/[UIScreen mainScreen].scale)];
        bottomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [rightView addSubview:bottomLine];
        
        // 重置按钮
        self.resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.resetButton.frame = CGRectMake(levelMargin+5, CGRectGetMaxY(self.tableView.frame)+(tableInsetDy-buttonHeight)/2, buttonWidth, buttonHeight);
        self.resetButton.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self.resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [self.resetButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
        self.resetButton.titleLabel.font = [UIFont systemFontOfSize:13];
        self.resetButton.layer.cornerRadius = 4;
        [self.resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:self.resetButton];
        
        // 确认按钮
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.confirmButton.frame = CGRectMake(CGRectGetMaxX(self.resetButton.frame)+interval, CGRectGetMinY(self.resetButton.frame), buttonWidth, buttonHeight);
        self.confirmButton.backgroundColor = [UIColor colorWithRed:204/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        self.confirmButton.layer.cornerRadius = 4;
        [rightView addSubview:self.confirmButton];
        
        self.tableView.estimatedRowHeight = 84.0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}


- (void)addToView:(UIView *)view withDatas:(NSArray *)dataList {
    
    [view addSubview:self];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentHideStatus==NO"];
    NSArray *array = [dataList filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:array];
        [array enumerateObjectsUsingBlock:^(TDFFilterMoel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == TDF_RegularFilterCell) {
                TDFRegularCellModel *model = (TDFRegularCellModel *)obj;
                if (model.optionItems == nil) {
                    [tempArr removeObject:model];
                }
            }
        }];
        self.dataList = [tempArr copy];
    }
    
    [self.tableView reloadData];
}

- (void)resetAction {
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), self.tableView.contentSize.height);
    NSArray *indexPaths = [self.tableView indexPathsForRowsInRect:rect];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexpath, NSUInteger idx, BOOL * _Nonnull stop) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
        [cell performSelector:@selector(tdf_FilterCellReset)];
    }];
    
    if ([self.delegate respondsToSelector:@selector(tdf_filterReset)]) {
        [self.delegate tdf_filterReset];
    }
}

- (void)confirmAction {
    
    if ([self.delegate respondsToSelector:@selector(tdf_filterShouldHide)]) {
        if ([self.delegate tdf_filterShouldHide] == NO) {
            return;
        }
    }
    if ([self.delegate respondsToSelector:@selector(tdf_filterCompleted)]) {
        [self.delegate tdf_filterCompleted];
    }
    [self changeFilterFrame];
}

- (void)renewListViewWithDatas:(NSArray *)dataList  {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentHideStatus==NO"];
    NSArray *array = [dataList filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:array];
        [array enumerateObjectsUsingBlock:^(TDFFilterMoel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == TDF_RegularFilterCell) {
                TDFRegularCellModel *model = (TDFRegularCellModel *)obj;
                if (model.optionItems == nil) {
                    [tempArr removeObject:model];
                }
            }
        }];
        self.dataList = [tempArr copy];
    }
    [self.tableView reloadData];
}

- (void)changeFilterFrame {
    
    if (self.frame.origin.x > 0) {
        if ([self.delegate respondsToSelector:@selector(tdf_filterWillShow)]) {
            if ([self.delegate tdf_filterWillShow]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [super changeFilterFrame];
                });
            }
        } else {
            [super changeFilterFrame];
        }
    } else {
//        if ([self.delegate respondsToSelector:@selector(tdf_filterShouldHide)]) {
//            
//            if ([self.delegate tdf_filterShouldHide]) {
//                [super changeFilterFrame];
//            }
//            return;
//        }
        [super changeFilterFrame];
    }
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) wself = self;
    TDFFilterMoel *model = [self.dataList objectAtIndex:indexPath.row];
    if (model.type == TDF_RegularFilterCell) {
        
        TDFRegularFilterCell *cell = [TDFRegularFilterCell tdf_FilterCellWithTableView:tableView data:model];
        cell.selectedCallBack = ^(TDFRegularCellModel *model){
            if ([wself.delegate respondsToSelector:@selector(tdf_filter:actionWithCellModel:)]) {
                [wself.delegate tdf_filter:wself actionWithCellModel:model];
            }
        };
        return cell;
   
    } else if (model.type == TDF_IntervalFilterCell) {
     
        TDFIntervalFilterCell *cell = [TDFIntervalFilterCell tdf_FilterCellWithTableView:tableView data:model];
        cell.editActionBlock = ^(TDFInterValCellModel *model) {
            if ([wself.delegate respondsToSelector:@selector(tdf_filter:actionWithCellModel:)]) {
                [wself.delegate tdf_filter:wself actionWithCellModel:model];
            }
        };
        return cell;
    
    } else if (model.type == TDF_TwiceFilterCellOneLine || model.type == TDF_TwiceFilterCellTwoLine) {
       
        TDFTwiceFilterCell *cell = [TDFTwiceFilterCell tdf_FilterCellWithTableView:tableView data:model];
        cell.showSelectPage = ^(TDFTwiceCellModel *model){
            if ([wself.delegate respondsToSelector:@selector(tdf_filter:actionWithCellModel:)]) {
                [wself.delegate tdf_filter:wself actionWithCellModel:model];
            }
        };
        return cell;
    
    }
    abort();
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
