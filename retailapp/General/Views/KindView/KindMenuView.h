//
//  KindMenuView.h
//  retailapp
//
//  Created by hm on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleCheckHandle.h"

@interface KindMenuView : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UIView *bgView;

@property (nonatomic,weak) IBOutlet UIButton* bgBtn;

@property (nonatomic,weak) IBOutlet UIButton* managerBtn;

@property (nonatomic,weak) IBOutlet UITableView* mainGrid;

@property (nonatomic,assign) id<SingleCheckHandle> singleCheckDelegate;

@property (nonatomic, assign) BOOL isShowManagerBtn;
/*
 * 外部是否需要自己做动画
 */
@property (nonatomic, assign) BOOL isAnimated;

@property int event;

- (IBAction)bgBtnClick:(id)sender;
- (IBAction)managerBtnClick:(id)sender;

- (void)initDelegate:(id<SingleCheckHandle>)delegate event:(int)event isShowManagerBtn:(BOOL) isShow;
// 加载数据
- (void) loadData:(NSMutableArray *)kindList nodes:(NSMutableArray *)nodes endNodes:(NSMutableArray *)endNodes;

- (void)showMoveIn;

- (void)hideMoveOut;

@end
