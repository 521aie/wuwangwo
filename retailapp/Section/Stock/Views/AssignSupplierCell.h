//
//  AssignSupplierCell.h
//  retailapp
//
//  Created by hm on 15/9/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INameCode.h"
@protocol AssignSupplierCellDelegate <NSObject>

@optional
- (void)showDelAssignCell:(id)obj;

@end

@interface AssignSupplierCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel* lblName;

@property (nonatomic,weak) IBOutlet UILabel* lblCode;

@property (nonatomic,weak) IBOutlet UIButton* delBtn;

@property (nonatomic,weak) IBOutlet UIImageView* imageDel;

@property (nonatomic, weak) id<INameCode> item;

@property (nonatomic,weak) id<AssignSupplierCellDelegate>delegate;

- (IBAction)onDelEventClick:(id)sender;

- (void)initDelegate:(id<AssignSupplierCellDelegate>)delegate withItem:(id<INameCode>)item isEdit:(BOOL)isEdit;

@end
