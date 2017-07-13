//
//  EnterCircleShopCell.h
//  retailapp
//
//  Created by qingmei on 15/12/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterCircleShopCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgHead;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblState;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblLinkMan;
@property (strong, nonatomic) IBOutlet UILabel *lblTel;
@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;

+ (id)getInstance;
- (void)loadCell:(id)obj;

@end
