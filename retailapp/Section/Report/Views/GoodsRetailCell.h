//
//  GoodsRetailCell.h
//  retailapp
//
//  Created by zhangzhiliang on 16/1/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsRetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCode;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblNetSales;
@property (weak, nonatomic) IBOutlet UILabel *lblNetAmount;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

- (void)visibleArrowImageView:(BOOL)visible;
@end
