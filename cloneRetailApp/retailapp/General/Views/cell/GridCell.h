//
//  GridCell.h
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridCell;
@protocol GridCellDelegate <NSObject>

@optional
- (void)deleteGridCell:(GridCell*)cell;

@end

@interface GridCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel* lblName;

@property (nonatomic,weak) IBOutlet UIImageView* delPic;

@property (nonatomic,weak) IBOutlet UIButton* delBtn;

@property (nonatomic,weak) id<GridCellDelegate>delegate;

@property (nonatomic,assign) NSInteger index;

- (IBAction)delBtnClick:(id)sender;



@end
