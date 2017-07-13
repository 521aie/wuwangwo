//
//  ShopCell.h
//  retailapp
//
//  Created by hm on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopCell;
@protocol ShopCellDelegate <NSObject>
@optional
- (void)expandCell:(ShopCell*)cell;

@end

@class TreeItem;
@interface ShopCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView* shopImage;

@property (nonatomic,weak) IBOutlet UILabel* lblName;

@property (nonatomic,weak) IBOutlet UILabel* lblNo;

@property (nonatomic,weak) IBOutlet UIImageView* nextImage;

@property (nonatomic,weak) IBOutlet UIButton* expandBtn;

@property (nonatomic,strong) TreeItem* item;

@property(nonatomic)BOOL isOpen;

@property (nonatomic,weak) id<ShopCellDelegate>delegate;

- (IBAction)expandBtnClick:(id)sender;

- (void)initDelegate:(id<ShopCellDelegate>)delegateTemp withItem:(TreeItem*)item;

- (void)showImg:(BOOL)show withType:(NSInteger)type;
- (void)setLevel:(NSInteger)level;
@end
