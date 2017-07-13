//
//  SupplierTypeEditView.m
//  retailapp
//
//  Created by hm on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SupplierTypeEditView.h"
#import "ServiceFactory.h"
#import "LSEditItemText.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"

@interface SupplierTypeEditView ()

@property (strong, nonatomic) CommonService *commonService;

@property (nonatomic, copy) AddTypeHandler addBlock;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;

@end

@implementation SupplierTypeEditView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.commonService = [ServiceFactory shareInstance].commonService;
    [self initNavigate];
    [self initMainView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


- (void)loadDataWithCallBack:(AddTypeHandler)handler
{
    self.addBlock = handler;
}

#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"添加" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma mark - 初始化主视图
- (void)initMainView
{
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];

    self.txtName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtName];
    [self.txtName initLabel:@"类别名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName initMaxNum:50];
}

#pragma mark - 保存
- (void)save
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:@"类别名称不能为空，请输入!"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.commonService saveSupplyType:[self.txtName getStrVal] completionHandler:^(id json) {
        weakSelf.addBlock();
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

@end
