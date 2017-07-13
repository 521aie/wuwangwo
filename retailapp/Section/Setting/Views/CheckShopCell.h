//
//  CheckShopCell.h
//  retailapp
//
//  Created by hm on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckShopCell;
@protocol CheckShopCellDelegate <NSObject>

@optional
- (void)expandCell:(CheckShopCell*)cell;

@end

@class TreeItem;
@interface CheckShopCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView* shopImage;

@property (nonatomic,weak) IBOutlet UIImageView* checkImage;

@property (nonatomic,weak) IBOutlet UIImageView* uncheckImage;

@property (nonatomic,weak) IBOutlet UILabel* lblName;

@property (nonatomic,weak) IBOutlet UILabel* lblNo;

@property (nonatomic,weak) IBOutlet UIButton* btnExpand;

@property (nonatomic,weak) id<CheckShopCellDelegate>delegate;

@property (nonatomic,strong) TreeItem* item;

- (IBAction)btnExpandClick:(id)sender;

- (void)showImg:(BOOL)show withType:(NSInteger)type withCheck:(BOOL)check;

- (void)initDeleagte:(id<CheckShopCellDelegate>)delegate withItem:(TreeItem*)item;

@end
