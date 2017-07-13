//
//  ReasonEditView.m
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReasonEditView.h"
#import "LSEditItemText.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "ServiceFactory.h"

@interface ReasonEditView ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;

@property (nonatomic,strong) LSEditItemText* txtName;

@property (nonatomic,strong) CommonService *commonService;
/**回调block*/
@property (nonatomic, copy) AddCallBack addBlock;
/**字典code*/
@property (nonatomic,copy) NSString *dicCode;

@end

@implementation ReasonEditView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.commonService = [ServiceFactory shareInstance].commonService;
    [self initNavigate];
    [self initMainView];
}

- (void)initMainView {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    
    self.txtName = [LSEditItemText editItemText];
    [self.txtName initLabel:@"退货原因" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName initMaxNum:50];
    [self.container addSubview:self.txtName];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


- (void)loadDataWithCode:(NSString *)dicCode callBack:(AddCallBack)callBack
{
    self.addBlock = callBack;
    self.dicCode = dicCode;
}

#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"添加退货原因" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
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

#pragma mark - 保存
- (void)save
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:@"退货原因不能为空，请输入!"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.commonService addReasonByCode:self.dicCode withReasonName:[self.txtName getStrVal] completionHandler:^(id json) {
        weakSelf.addBlock();
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

@end
