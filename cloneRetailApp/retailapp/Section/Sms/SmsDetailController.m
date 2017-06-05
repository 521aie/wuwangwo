//
//  SmsDetailController.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "SmsDetailController.h"
#import "LSEditItemList.h"
#import "LSEditItemMemo.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "SelectOrgShopListView.h"
#import "SubOrgVo.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "MemoInputView.h"
#import "IEditItemListEvent.h"
#import "IEditItemMemoEvent.h"
#import "ServiceFactory.h"
#import "LSEditItemList.h"
#import "LSSmsMainListController.h"

@interface SmsDetailController ()<MemoInputClient,IEditItemListEvent,IEditItemMemoEvent>

@property(nonatomic,strong)SmsService *service;
@property(nonatomic,strong)SettingService *settingService;
@property (nonatomic,strong)  UIScrollView* scrollView;
@property (nonatomic,strong) UIView* container;
//接收门店
@property (nonatomic,strong) LSEditItemMemo* tagetShopMemo;
@property (nonatomic,strong) LSEditItemList* lsShop;
//消息标题
@property (nonatomic,strong) LSEditItemText* txtTitle;
//消息内容
@property (nonatomic,strong) LSEditItemMemo* contentMemo;
//提示
@property ( nonatomic,strong) UILabel *lblDetail;
@end

@implementation SmsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [ServiceFactory shareInstance].smsService;
    self.settingService =  [ServiceFactory shareInstance].settingService;
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    UIView *superView = self.view;
    __weak typeof(self) wself = self;
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.top.equalTo(wself.view).offset(kNavH);
    }];
    
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
    
    //接收门店
    self.tagetShopMemo = [LSEditItemMemo editItemMemo];
    [self.container addSubview:self.tagetShopMemo];
    
    self.lsShop = [LSEditItemList editItemList];
    [self.container addSubview:self.lsShop];
    
    //消息标题
    self.txtTitle = [LSEditItemText editItemText];
    [self.container addSubview:self.txtTitle];
    
    //消息内容
    self.contentMemo = [LSEditItemMemo editItemMemo];
    self.contentMemo.userInteractionEnabled = YES;
    [self.container addSubview:self.contentMemo];
    
    //提示
    self.lblDetail = [[UILabel alloc] init];
    
    [self initNavigate];
    [self initMainView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 初始化导航栏
- (void)initNavigate
{
    [self configTitle:@"添加" leftPath:Head_ICON_BACK rightPath:nil];
}

#pragma mark - 导航栏点击事件
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[ LSSmsMainListController class]]) {
                 LSSmsMainListController *listView = ( LSSmsMainListController *)vc;
                [listView.mainGrid headerBeginRefreshing];
            }
        }
    
        if (self.action == ACTION_CONSTANTS_EDIT) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma mark - 初始化页面
- (void)initMainView
{
    [self.tagetShopMemo initLabel:@"接收门店" isrequest:NO delegate:nil];
    [self.lsShop initLabel:@"接收门店" withHit:nil delegate:self];
    self.lsShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self.lsShop visibal:NO];
        [self.contentMemo editEnable:NO];
        [self.tagetShopMemo editEnable:NO];
        [self.txtTitle editEnabled:NO];
        self.txtTitle.txtVal.textColor = [ColorHelper getTipColor6];;
    } else {
        [self.tagetShopMemo visibal:NO];
        self.txtTitle.txtVal.textColor = [ColorHelper getBlueColor];
    }
    [self.txtTitle initLabel:@"公告标题" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtTitle initMaxNum:50];
    [self.contentMemo initLabel:@"公告内容" isrequest:YES delegate:self];
    
    if ([[Platform Instance] getShopMode] == 3) {//机构、门店
        self.lblDetail.text = @"提示：接收门店选择机构时，该机构及其下属门店都能接收到此消息。";
        [LSViewFactor addExplainText:self.container text:self.lblDetail.text y:0];
        if (self.action == ACTION_CONSTANTS_EDIT) {
            [self.lsShop initData:[[Platform Instance] getkey:ORG_NAME] withVal:[[Platform Instance] getkey:ORG_ID]];
        } else {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LSSmsMainListController class]]) {
                    LSSmsMainListController *listView = (LSSmsMainListController *)vc;
                    [self.lsShop initData:[listView.lsShop getDataLabel] withVal:[listView.lsShop getStrVal]];
                }
            }
        }
    } else {
        [self.lsShop initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
        [self.lsShop visibal:NO];
        [self.tagetShopMemo visibal:NO];
    }
    
    if ([[Platform Instance] getShopMode] != 3) {
        self.lblDetail.hidden = YES;
    }
    
    if (self.action == ACTION_CONSTANTS_EDIT) { //编辑模式
        [self loadData];
    } else {
//        self.titleBox.lblTitle.text = @"添加";
        [self configTitle:@"添加消息公告"];
        [self editTitle:NO act:self.action];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

-(void) onItemMemoListClick:(LSEditItemMemo*)obj {
    if (obj == self.contentMemo) {
        int tag = (int)obj.tag;
        MemoInputView *vc = [[MemoInputView alloc] init];
        [vc limitShow:tag delegate:self title:self.contentMemo.lblName.text val:[self.contentMemo getStrVal] limit:500];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    }
}

-(void) finishInput:(int)event content:(NSString*)content {
    [self.contentMemo changeData:content];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 加载数据
- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [self editTitle:NO act:self.action];
    [_service selectSmsDetail:self.noticeId completionHandler:^(id json) {
        weakSelf.notice = [Notice converToNotice:[json objectForKey:@"notice"]];
        [weakSelf configTitle:weakSelf.notice.noticeTitle];
   
        [weakSelf.txtTitle initData:weakSelf.notice.noticeTitle];
        [weakSelf.contentMemo initData:weakSelf.notice.noticeContent];
        [weakSelf.tagetShopMemo initData:nil];
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[ LSSmsMainListController class]]) {
                 LSSmsMainListController *listView = ( LSSmsMainListController *)vc;
                weakSelf.tagetShopMemo.lblHit.text = listView.lsShop.lblVal.text;
            }
        }
        
        [weakSelf.contentMemo editEnable:NO];
        [weakSelf.tagetShopMemo editEnable:NO];
        [self editTitle:NO act:self.action];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 加载机构门店
- (void)onItemListClick:(EditItemList *)obj
{
    SelectOrgShopListView *vc = [[SelectOrgShopListView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
    __weak typeof(self) weakSelf = self;
    [vc loadData:[obj getStrVal] withModuleType:3 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if (item) {
            [weakSelf.lsShop initData:[item obtainItemName] withVal:[item obtainItemId]];
            if (weakSelf.action == ACTION_CONSTANTS_EDIT) {
                [weakSelf loadData];
            }
        }
    }];
}

#pragma mark - 保存的条件
- (BOOL)isValide
{
    if ([NSString isBlank:[self.txtTitle getStrVal]]) {
        [AlertBox show:@"消息标题不能为空!"];
        return NO;
    }
    if ([NSString isBlank:[self.contentMemo getStrVal]]) {
        [AlertBox show:@"消息内容不能为空"];
        return NO;
    }
    return YES;
}

#pragma mark - 保存的消息对象
- (Notice*)transModel
{
    Notice* notice = [Notice new];
    notice.currShopId = [[Platform Instance] getShopMode]==3?[[Platform Instance] getkey:ORG_ID]:[[Platform Instance] getkey:SHOP_ID];
    if ([[self.lsShop getStrVal] isEqualToString:[[Platform Instance] getkey:ORG_ID]]) {
        notice.targetShopId = @"0";
    } else {
        notice.targetShopId = [self.lsShop getStrVal];
    }
    notice.targetShopName = self.lsShop.lblVal.text;
    notice.noticeTitle = [self.txtTitle getStrVal];
    notice.noticeContent = [self.contentMemo getStrVal];
    notice.publishTime = [[NSDate date] timeIntervalSince1970];
    return notice;
}

#pragma mark - 点击保存时请求服务器
- (void)save
{
    if (![self isValide]) {
        return;
    }
    NSString* operateType = _action==ACTION_CONSTANTS_ADD?@"add":@"edit";
    __weak typeof(self) weakSelf = self;
    [_service saveSms:[self transModel] operateType:operateType completionHandler:^(id json) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[ LSSmsMainListController class]]) {
                 LSSmsMainListController *listView = ( LSSmsMainListController *)vc;
                [listView.lsShop initData:[weakSelf.lsShop getDataLabel] withVal:[weakSelf.lsShop getStrVal]];
                [listView.mainGrid headerBeginRefreshing];
            }
        }
        if (weakSelf.action == ACTION_CONSTANTS_ADD) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        }
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
