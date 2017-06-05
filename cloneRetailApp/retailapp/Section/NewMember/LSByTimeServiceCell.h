//
//  LSByTimeServiceCell.h
//  retailapp
//
//  Created by taihangju on 2017/4/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSByTimeServiceCell : UITableViewCell

- (void)fillCellData:(id)vo expired:(BOOL)isExpiry callBackBlock:(void (^)())block;
@end
