//
//  GoodsInfoSelectFooterListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListView.h"

@interface FooterListView4 : UIView
@property (strong, nonatomic) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UIImageView *imgBatch;
@property (nonatomic, strong) IBOutlet UIButton *btnBatch;

@property (nonatomic, strong) IBOutlet UIImageView *imgScan;
@property (weak, nonatomic) IBOutlet UIImageView *imgHelp;
@property (nonatomic, strong) IBOutlet UIButton *btnScan;

@property (nonatomic, strong) UITableView *table;

@property (nonatomic,strong) id<FooterListEvent> delegate;

-(void) initDelegate:(id<FooterListEvent>) delegate btnArrs:(NSArray*) arr;
/**是否显示批量按钮*/
- (void)showBatch:(BOOL)isVisibal;
//- (IBAction) onAddClickEvent:(id)sender;
//- (IBAction) onExportClickEvent:(id)sender;
- (IBAction) onBatchClickEvent:(id)sender;
- (IBAction) onScanClickEvent:(id)sender;
- (IBAction) onHelpClickEvent:(id)sender;
@end
