//
//  MultiHeadCell.h
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadCheckHandle.h"

@interface MultiHeadCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UIView *panel;
@property (strong, nonatomic) IBOutlet UIImageView *imgCheck;
@property (strong, nonatomic) IBOutlet UIImageView *imgUnCheck;
@property (strong, nonatomic) IBOutlet UIButton *btnCheck;
@property (strong, nonatomic) IBOutlet UILabel *lblcheck;

@property (nonatomic) id<HeadCheckHandle> delegate;
@property (nonatomic) id<INameValueItem> item;
@property BOOL checkFlag;

-(void)loadData:(id<INameValueItem>)item delegate:(id<HeadCheckHandle>)delegate;
-(IBAction)btnCheckClick:(id)sender;
- (void)checked:(BOOL)check;
@end
