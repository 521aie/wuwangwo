//
//  FooterListView3.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"

@interface FooterListView3 : UIView

@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UIImageView *imgAdd;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;

@property (nonatomic, strong) IBOutlet UIImageView *imgExport;
@property (nonatomic, strong) IBOutlet UIButton *btnExport;
@property (weak, nonatomic) IBOutlet UIImageView *imgHelp;

@property (nonatomic, strong) IBOutlet UIImageView *imgScan;
@property (nonatomic, strong) IBOutlet UIButton *btnScan;

@property (nonatomic, strong) UITableView *table;

@property (nonatomic,strong) id<FooterListEvent> delegate;

-(void) initDelegate:(id<FooterListEvent>) delegate btnArrs:(NSArray*) arr;


- (IBAction) onAddClickEvent:(id)sender;
- (IBAction) onExportClickEvent:(id)sender;
- (IBAction) onScanClickEvent:(id)sender;
- (IBAction) onHelpClickEvent:(id)sender;

@end
