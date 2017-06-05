//
//  LSShopCollectionListCell.h
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSHandoverPayTypeVo.h"
@interface LSShopCollectionListCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) LSHandoverPayTypeVo *handoverPayTypeVo;
+ (instancetype)shopCollectionListCellWithTableView:(UITableView *)tableView;
- (void)setHandoverPayTypeVo:(LSHandoverPayTypeVo *)handoverPayTypeVo showNextimg:(BOOL)show;
@end
