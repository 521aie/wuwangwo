//
//  SelectItemCell.h
//  retailapp
//
//  Created by guozhi on 16/5/15.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INameItem.h"

@interface SelectItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *img;
- (void)initWithData:(id<INameItem>)data isSelected:(BOOL)isSelected;
@end
