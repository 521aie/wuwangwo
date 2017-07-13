//
//  HeaderGridItem.h
//  retailapp
//
//  Created by hm on 16/1/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssignSupplierCell.h"

@protocol HeaderGridItemDelegate <NSObject>
- (void)showAddGridItem;
- (void)delGridItem:(id)obj;
@end

@interface HeaderGridItem : UIView<UITableViewDataSource,UITableViewDelegate,AssignSupplierCellDelegate>
@property (nonatomic, weak) IBOutlet UIView *headerView;  //页眉
@property (nonatomic, weak) IBOutlet UIView *panel;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIImageView *imageAdd;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet UITableView *mainGrid;  //表格
@property (nonatomic, weak) IBOutlet UIView *footView;  //页脚
@property (nonatomic, weak) IBOutlet UILabel *lblAddInfo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footViewHeightConstraint;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, weak) id<HeaderGridItemDelegate> delegate;
+ (HeaderGridItem *)loadFromNib;
- (void)initDelegate:(id<HeaderGridItemDelegate>)delegate withAddName:(NSString *)addName;
- (void)loadData:(NSMutableArray *)dataList withIsEdit:(BOOL)isEdit;
- (IBAction)onAddEventClick:(id)sender;
@end
