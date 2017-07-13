//
//  LSCostAdjustStyleBatchViewController.m
//  retailapp
//
//  Created by guozhi on 2017/4/12.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_COST_AFTER 1
#define kDataChange @"dataChange"
#import "LSCostAdjustStyleBatchViewController.h"
#import "LSEditItemList.h"
#import "SymbolNumberInputBox.h"
@interface LSCostAdjustStyleBatchViewController ()<IEditItemListEvent, SymbolNumberInputClient>
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
/** 调整后成本价 */
@property (nonatomic, strong) LSEditItemList *lstCostAfter;
/** <#注释#> */
@property (nonatomic, copy) BatchCallBlock callBlock;
@end

@implementation LSCostAdjustStyleBatchViewController
- (instancetype)initWithCallBlock:(BatchCallBlock)callBlock {
    if (self = [super init]) {
        self.callBlock = callBlock;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self initNotification];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)configViews {
    [self configTitle:@"批量设置成本价" leftPath:Head_ICON_BACK rightPath:nil];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, self.view.ls_width, self.view.ls_height - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    //调整后成本价
    self.lstCostAfter = [LSEditItemList editItemList];
    [self.lstCostAfter initLabel:@"调整后成本价（元）" withHit:nil isrequest:NO delegate:self];
    self.lstCostAfter.tag = TAG_LST_COST_AFTER;
    [self.container addSubview:self.lstCostAfter];
    
}

- (void)initNotification {
    [UIHelper initNotification:self.container event:kDataChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:kDataChange object:nil];
}

- (void)dataChange:(NSNotification *)notification {
    [self editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}

- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.lstCostAfter) {
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        [SymbolNumberInputBox initData:obj.lblVal.text];

    }
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)direct {
    if (direct == LSNavigationBarButtonDirectLeft) {
        [self popViewController];
    } else {
        if (self.callBlock) {
            double cost = [[self.lstCostAfter getDataLabel] doubleValue];
            self.callBlock(cost);
        }
        [self popViewController];
    }
}
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if (eventType == TAG_LST_COST_AFTER) {
        double costAfter = val.doubleValue;
        [self.lstCostAfter changeData:[NSString stringWithFormat:@"%.2f", costAfter] withVal:[NSString stringWithFormat:@"%.2f", costAfter]];
    }
}

@end
