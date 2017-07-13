//
//  ShoesClothingCell.h
//  retailapp
//
//  Created by hm on 15/9/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PaperDetailVo;
@interface ShoesClothingCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel* lblName;
@property (nonatomic,weak) IBOutlet UILabel* lblStyleNo;
@property (nonatomic,weak) IBOutlet UILabel* lblStyleCount;
@property (nonatomic,weak) IBOutlet UILabel* lblTotalMoney;
@property (nonatomic,weak) IBOutlet UIImageView* imgNext;
- (void)loadData:(PaperDetailVo*)item isEdit:(BOOL)isEdit isSearchPrice:(BOOL)isSearchPrice;
- (void)showMarkRed:(BOOL)show;
@end
