//
//  TDFSimpleConditionFilter.m
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/9.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import "TDFSimpleConditionFilter.h"
#import "TDFBasicFilterCell.h"


@interface TDFSimpleConditionFilter ()<UITableViewDelegate ,UITableViewDataSource>
{
    NSUInteger rowNum;
}

@property (nonatomic ,copy) void (^returnBlcok)(TDFFilterItem *);/**<选择的cell对应的index>*/
@property (nonatomic, copy) void (^headerAction)();/**<头部回调>*/
@end

@implementation TDFSimpleConditionFilter

- (void)configHeader:(TDFFilterHeaderType)headerType headerAction:(void (^)())block {
    self.headerAction = block;
    [self addHeaderView:headerType];
}

- (void)addToView:(UIView *)superView items:itemArray callBack:(void(^)(TDFFilterItem *))block {
    
    self.returnBlcok = block;
    [superView addSubview:self];
    [self setFilterItems:itemArray];
}

- (void)setFilterItems:(NSArray *)itemArray {
    
    _itemArray = itemArray;
    rowNum = itemArray.count;
    if (rowNum) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
    }
}

- (void)addHeaderView:(TDFFilterHeaderType)type {
    
    if (type == TDFFilterHeader_SuppilerCategory) {
        
        //设置顶部按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.tableView.frame.origin.x, 20.0f, self.tableView.frame.size.width, 40.0f);
        [button setImage:[UIImage imageNamed:@"ico_manage"] forState:UIControlStateNormal];
        [button setTitle:@"  类别管理" forState:0];
        [button setTitleColor:[UIColor colorWithRed:0.0 green:136/255.0 blue:204/255.0 alpha:1] forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4.0f;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightView addSubview:button];
    }
}

- (void)btnClick:(UIButton *)sender {
    
    if (self.headerAction) {
        self.headerAction();
    }
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TDFBasicFilterCell *cell = [TDFBasicFilterCell tdf_basicFilterCellWithTableView:tableView];
    TDFFilterItem *item = self.itemArray[indexPath.row];
    cell.itemName.text = item.itemName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self changeFilterFrame];
    if (self.returnBlcok) {
        TDFFilterItem *item = self.itemArray[indexPath.row];
        self.returnBlcok(item);
    }
}

@end
