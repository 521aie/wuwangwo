//
//  SortViewCell.h
//  retailapp
//
//  Created by qingmei on 15/11/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblItemName;

+ (id)getInstance;
- (void)loadCell:(id)obj;
@end
