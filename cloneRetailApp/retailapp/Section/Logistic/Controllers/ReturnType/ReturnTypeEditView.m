//
//  ReturnTypeEditView.m
//  retailapp
//
//  Created by hm on 16/2/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReturnTypeEditView.h"
#import "LSEditItemText.h"
#import "LSEditItemRadio.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "ReturnTypeVo.h"
#import "XHAnimalUtil.h"

@interface ReturnTypeEditView ()<UIActionSheetDelegate>
@property (nonatomic, strong) LogisticService *logisticService;
@property (nonatomic, copy) EditReturnTypeBlock returnTypeBlock;
@property (nonatomic, copy) NSString *returnTypeId;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, copy) NSString *token;
@end

@implementation ReturnTypeEditView

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.logisticService = [ServiceFactory shareInstance].logisticService;
    [self initNavigate];
    [self configViews];
    [self initMainView];
    [self initNotification];
    [self loadMainView];
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
    
    self.rdoReturnCount = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoReturnCount];

}

- (void)loadDataWithId:(NSString *)returnTypeId withName:(NSString *)name withAction:(NSInteger)action callBack:(EditReturnTypeBlock) callBack
{
    self.returnTypeId = returnTypeId;
//    self.titleName = (action==ACTION_CONSTANTS_ADD)?@"添加":name;
    self.titleName = (action==ACTION_CONSTANTS_ADD)?@"添加退货类型":name;
    self.action = action;
    self.returnTypeBlock = callBack;
    self.param = [NSMutableDictionary dictionaryWithCapacity:5];
}

#pragma mark - 初始化主视图
- (void)initMainView
{
    [self.txtName initLabel:@"退货类型" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.rdoReturnCount initLabel:@"控制退货数量" withHit:nil];
    [self.rdoReturnCount visibal:NO]; // 应报表改造要求，进行隐藏（退货类型只是服鞋连锁总部才有）
    [UIHelper refreshUI:self.container];
    self.delBtn.ls_top += 10.0;
}

#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"" leftPath:Head_ICON_CANCEL rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animalEdit:self.navigationController action:self.action];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma mark - 初始化UI通知
- (void)initNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification *)notification
{
    [self editTitle:[UIHelper currChange:self.container] act:self.action];
}

#pragma mark - 加载视图
- (void)loadMainView
{
    [self showView];
    [self configTitle:self.titleName];
    if (self.action==ACTION_CONSTANTS_ADD) {
        [self clearDo];
    }else{
        [self queryReturnTypeDetil];
    }
}

//添加模式隐藏删除按钮
- (void)showView
{
    self.delBtn.hidden = (self.action==ACTION_CONSTANTS_ADD);
}

#pragma mark - 添加模式
- (void)clearDo
{
    [self.txtName initData:nil];
    [self.rdoReturnCount initData:@"0"];
}

#pragma mark - 查询退货类别详情
- (void)queryReturnTypeDetil
{
    __weak typeof(self) wself = self;
    [self.logisticService selectReturnTypeDetailById:self.returnTypeId completionHandler:^(id json) {
        [wself.txtName initData:[json objectForKey:@"name"]];
        [wself.rdoReturnCount initData:[json objectForKey:@"onOff"]];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (IBAction)onDelClick:(id)sender {
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确定要删除[%@]吗?",[self.txtName getStrVal]]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self operateReturnType:@"del"];
    }
}

#pragma mark - 验证页面参数
- (BOOL)isValide
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:@"退货类型不能为空，请输入!"];
        return NO;
    }
    return YES;
}

#pragma mark - 保存
- (void)save
{
    if (![self isValide]) {
        return;
    }
    if (self.action==ACTION_CONSTANTS_ADD) {
        [self operateReturnType:@"add"];
    }else{
        [self operateReturnType:@"edit"];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.token = nil;
}
- (void)operateReturnType:(NSString *)operateType
{
    [self.param setValue:self.returnTypeId forKey:@"returnTypeId"];
    [self.param setValue:operateType forKey:@"operation"];
    [self.param setValue:[self.txtName getStrVal] forKey:@"returnTypeName"];
    [self.param setValue:[self.rdoReturnCount getStrVal] forKey:@"offController"];
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    [self.param setValue:self.token forKey:@"token"];
    
    __weak typeof(self) wself = self;
    [self.logisticService operateReturnTypeByParam:self.param completionHandler:^(id json) {
        wself.token = nil;
        if ([@"add" isEqualToString:operateType]) {
            wself.returnTypeBlock(nil,ACTION_CONSTANTS_ADD);
        }else if ([@"edit" isEqualToString:operateType]) {
            ReturnTypeVo *vo = [[ReturnTypeVo alloc] init];
            vo.dicItemId = wself.returnTypeId;
            vo.name = [wself.txtName getStrVal];
            wself.returnTypeBlock(vo,ACTION_CONSTANTS_EDIT);
        }else if ([@"del" isEqualToString:operateType]) {
            ReturnTypeVo *vo = [[ReturnTypeVo alloc] init];
            vo.dicItemId = wself.returnTypeId;
            vo.name = [wself.txtName getStrVal];
            wself.returnTypeBlock(vo,ACTION_CONSTANTS_DEL);
        }
        [XHAnimalUtil animalEdit:wself.navigationController action:wself.action];
        [wself.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


@end
