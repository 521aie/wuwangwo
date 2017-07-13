//
//  AdjustReasonEditView.m
//  retailapp
//
//  Created by hm on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AdjustReasonEditView.h"
#import "ServiceFactory.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"

@interface AdjustReasonEditView ()

@property (nonatomic, strong) StockService *stockService;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* container;
@property (nonatomic, strong) LSEditItemText* txtName;
/** <#注释#> */
@property (nonatomic, assign) AdjustReasonEditViewType type;
@end

@implementation AdjustReasonEditView
- (instancetype)initWithType:(AdjustReasonEditViewType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.stockService = [ServiceFactory shareInstance].stockService;
    [self initNavigate];
    [self configViews];
    [self initMainView];
    [self registerNotification];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.txtName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtName];
}

#pragma mark - 初始化导航栏
- (void)initNavigate
{
    [self configTitle:@"添加调整原因" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
        
    }else{
        [self save];
    }
}

#pragma mark - 初始化详情
- (void)initMainView
{
    [self.txtName initLabel:@"调整原因名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName initMaxNum:50];
}

#pragma mark - 注册|移除UI变化通知
- (void)registerNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notification
{
    [self editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_ADD];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 验证原因名称
- (BOOL)isValide
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:@"调整原因名称不能为空，请输入!"];
        return NO;
    }
    return YES;
}

#pragma mark - 保存调整原因
- (void)save
{
    if (![self isValide]) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:[self.txtName getStrVal] forKey:@"adjustReason"];
    NSString *url = @"";
    if (self.type == AdjustReasonEditViewTypeCostAdjust) {
        url = @"costPriceOpBills/addCostReason";
    } else if (self.type == AdjustReasonEditViewTypeStockAdjust) {
        url = @"stockAdjust/addAdjustReason";
    }
    __typeof(self)  strongSelf =self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [XHAnimalUtil animal: strongSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [ strongSelf.navigationController popViewControllerAnimated:NO];

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

@end
