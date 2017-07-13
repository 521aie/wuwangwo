//
//  SupplierCell.h
//  retailapp
//
//  Created by hm on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupplierCell : UITableViewCell

/**简称*/
@property (nonatomic,weak) IBOutlet UILabel* lblName;
/**联系人和联系方式*/
@property (nonatomic,weak) IBOutlet UILabel* lblDetail;
/**仓库图标*/
@property (nonatomic,weak) IBOutlet UIImageView* warehousePic;

@property (nonatomic,weak) IBOutlet UIImageView* nextPic;

@property (nonatomic,weak) IBOutlet UIImageView* checkPic;

@property (nonatomic,weak) IBOutlet UIImageView* uncheckPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraint;

- (void)loadDataWithName:(NSString *)name withDetail:(NSString *)detail withShow:(BOOL)isShow withCheck:(BOOL)isHideCheck;
//门店显示门店图标，仓库显示仓库图标
- (void)showImageType:(BOOL)shopType;
@end
