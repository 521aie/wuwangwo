//
//  GoodsInfoSelectFooterListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"

@interface GoodsFooterListView : UIView

@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UIView *addView;
@property (nonatomic, strong) IBOutlet UIImageView *imgAdd;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;

@property (nonatomic, strong) IBOutlet UIView *exportView;
@property (nonatomic, strong) IBOutlet UIImageView *imgExport;
@property (nonatomic, strong) IBOutlet UIButton *btnExport;

@property (nonatomic, strong) IBOutlet UIView *batchView;
@property (nonatomic, strong) IBOutlet UIImageView *imgBatch;
@property (nonatomic, strong) IBOutlet UIButton *btnBatch;

@property (nonatomic, strong) IBOutlet UIView *scanView;
@property (nonatomic, strong) IBOutlet UIImageView *imgScan;
@property (nonatomic, strong) IBOutlet UIButton *btnScan;

@property (nonatomic, strong) IBOutlet UIView *chkAllView;
@property (nonatomic, strong) IBOutlet UIImageView *imgChkAll;
@property (nonatomic, strong) IBOutlet UIButton *btnChk;

@property (nonatomic, strong) IBOutlet UIView *notChkAllView;
@property (nonatomic, strong) IBOutlet UIImageView *imgNotChkAll;
@property (nonatomic, strong) IBOutlet UIButton *btnNotChk;

@property (nonatomic, strong) UITableView *table;

@property (nonatomic,strong) id<FooterListEvent> delegate;

-(void) initDelegate:(id<FooterListEvent>) delegate btnArrs:(NSArray*) arr;

+ (GoodsFooterListView *)goodFooterListView;

- (IBAction)onAddClickEvent:(id)sender;
- (IBAction)onExportClickEvent:(id)sender;
- (IBAction)onBatchClickEvent:(id)sender;
- (IBAction)onScanClickEvent:(id)sender;
- (IBAction)onCheckAllClickEvent:(id)sender;
- (IBAction)onNotCheckAllClickEvent:(id)sender;
//- (IBAction) onHelpClickEvent:(id)sender;
@end
