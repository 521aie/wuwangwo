//
//  AssignSupplierCell.m
//  retailapp
//
//  Created by hm on 15/9/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AssignSupplierCell.h"

@implementation AssignSupplierCell


- (void)initDelegate:(id<AssignSupplierCellDelegate>)delegate withItem:(id<INameCode>)item isEdit:(BOOL)isEdit
{
    self.delegate = delegate;
    self.item = item;
    self.lblName.text = [item obtainItemName];
    self.lblCode.text = [NSString stringWithFormat:@"机构编号：%@",[item obtainItemCode]];
    self.delBtn.hidden = !isEdit;
    self.imageDel.hidden = !isEdit;
}
- (IBAction)onDelEventClick:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showDelAssignCell:)]) {
        [self.delegate showDelAssignCell:self.item];
    }
}

@end
