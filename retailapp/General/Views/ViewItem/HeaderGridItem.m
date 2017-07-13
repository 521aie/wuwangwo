//
//  HeaderGridItem.m
//  retailapp
//
//  Created by hm on 16/1/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "HeaderGridItem.h"
#import "UIView+Sizes.h"
#import "INameCode.h"

@implementation HeaderGridItem
+ (HeaderGridItem *)loadFromNib
{
    HeaderGridItem *gridItem = [[[NSBundle mainBundle] loadNibNamed:@"HeaderGridItem" owner:self options:nil] lastObject];
    gridItem.ls_width = SCREEN_W;
    [gridItem.panel.layer setMasksToBounds:YES];
    gridItem.panel.alpha = 0.5;
    gridItem.panel.layer.cornerRadius = CELL_HEADER_RADIUS;
    return gridItem;
}

- (void)initDelegate:(id<HeaderGridItemDelegate>)delegate withAddName:(NSString *)addName
{
    self.delegate = delegate;
    self.lblAddInfo.text = addName;
}

- (void)loadData:(NSMutableArray *)dataList withIsEdit:(BOOL)isEdit
{
    self.lblTitle.text = [NSString stringWithFormat:@"合计%tu个供应商",dataList.count];
    self.dataList = dataList;
    self.isEdit = isEdit;
    self.imageAdd.hidden = !isEdit;
    self.addButton.hidden = !isEdit;
    self.footView.hidden = !isEdit;
    CGFloat height = (dataList==nil||dataList.count==0)?0:(dataList.count*60);
    self.tableHeightConstraint.constant = height;
    self.footViewHeightConstraint.constant = isEdit ? 48 : 0;
    [self layoutIfNeeded];
    height = self.footView.ls_bottom;
    [self setLs_height:height];
    [self.superview setLs_height:self.ls_height];
    [self.mainGrid reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"AssignSupplierCell";
    AssignSupplierCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"AssignSupplierCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id<INameCode> item = [self.dataList objectAtIndex:indexPath.row];
    [cell initDelegate:self withItem:item isEdit:self.isEdit];
    return cell;
}

- (IBAction)onAddEventClick:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showAddGridItem)]) {
        [self.delegate showAddGridItem];
    }
}

- (void)showDelAssignCell:(id)obj
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(delGridItem:)]) {
        [self.delegate delGridItem:obj];
    }
}

@end
