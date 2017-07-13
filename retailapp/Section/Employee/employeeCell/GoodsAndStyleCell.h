//
//  GoodsAndStyleCell.h
//  retailapp
//
//  Created by qingmei on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsAndStyleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblLeft;
@property (strong, nonatomic) IBOutlet UILabel *lblRight;

+ (id)getInstance;
- (void)loadCell:(id)obj;
@end
