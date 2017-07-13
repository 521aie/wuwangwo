//
//  GridHead.h
//  RestApp
//
//  Created by zxh on 14-7-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

@class INameValueItem;
@interface GridHead : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIImageView *imgAdd;
@property (strong, nonatomic) IBOutlet UIImageView *imgEdit;
@property (nonatomic, retain) IBOutlet UIButton *btnAdd;
@property (nonatomic, retain) IBOutlet UIButton *btnEdit;
@property (nonatomic, retain) IBOutlet UIView *panel;

@property (nonatomic,strong) id<ISampleListEvent> delegate;
@property (strong, nonatomic) id<INameValueItem> obj;
@property (strong, nonatomic) NSString* event;

+(id)getInstance:(UITableView *)tableView;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp event:(NSString*)event;

-(void) initOperateWithAdd:(BOOL)addEnable edit:(BOOL)editEnable;

-(IBAction) btnEditClick:(id)sender;

-(IBAction) btnAddClick:(id)sender;

@end
