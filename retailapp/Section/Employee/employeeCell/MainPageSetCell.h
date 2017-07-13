//
//  MainPageSetCell.h
//  retailapp
//
//  Created by qingmei on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageSetCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UILabel *lbldetail;

+ (id)getInstance;
- (void)loadCell:(id)obj;

@end
