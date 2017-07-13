//
//  LSOrgInfoController.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSOrgInfoController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SettingModuleEvent.h"
#import "ServiceFactory.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "LSEditItemMemo.h"
#import "LSEditItemRadio.h"
#import "EditItemImage2.h"
#import "HeaderGridItem.h"
#import "OptionPickerBox.h"
#import "AddressPickerBox.h"
#import "MemoInputView.h"
#import "EmployeeManageView.h"
#import "SubOrgShopListView.h"
#import "SelectOrgListView.h"
#import "ColorHelper.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "XHAnimalUtil.h"
#import "PurchaseSupplyVo.h"
#import "OrganizationVo.h"
#import "LSImageVo.h"
#import "LSImageDataVo.h"
#import "ShopType.h"
#import "SelectAssignSupplierListView.h"

@interface LSOrgInfoController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,IEditItemImageEvent,IEditItemListEvent,IEditItemMemoEvent,AddressPickerClient,OptionPickerClient,HeaderGridItemDelegate,IEditItemRadioEvent,MemoInputClient>
@property (nonatomic,strong) SettingService* settingService;

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* container;

/**店家编号*/
@property (nonatomic, strong) LSEditItemText* txtShopNo;
/**店家名称*/
@property (nonatomic, strong) LSEditItemText* txtShopName;
/**机构类型 部门 公司*/
@property (nonatomic,strong) LSEditItemList* lsOrgType;
/**加盟商*/
@property (nonatomic,strong) LSEditItemRadio* rdoIsJoin;

/**所在地区:省市区*/
@property (nonatomic, strong) LSEditItemList* lsShopAdr;
/**详细地址*/
@property (nonatomic, strong) LSEditItemMemo* txtDetailAdr;
/**联系人*/
@property (nonatomic, strong) LSEditItemText* txtLinkMan;
/**手机号码*/
@property (nonatomic, strong) LSEditItemText* txtPhone;
/**联系电话*/
@property (nonatomic, strong) LSEditItemText* txtMobile;
/**员工信息*/
@property (nonatomic,strong) LSEditItemList* lsEmpInfo;
/**上级机构*/
@property (nonatomic,strong) LSEditItemList* lsSuperOrg;
/**下级机构*/
@property (nonatomic,strong) LSEditItemList* lsSubOrg;
/**允许供货*/
@property (nonatomic,strong) LSEditItemRadio* rdoAllowSupply;
/**向指定公司采购*/
@property (nonatomic,strong) LSEditItemRadio* rdoSupply;
@property (nonatomic,strong) UIView* supplyDiv;

/**只有总部的机构信息显示logo*/
@property (nonatomic, strong) EditItemImage2* imgLogo;
@property (nonatomic, strong) UIView* delView;

//机构模型
@property (nonatomic, strong) OrganizationVo* orgVo;
/**地址列表*/
@property (nonatomic, strong) NSArray* addressList;
/**图片选择器*/
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
/**店家logo图片*/
@property (nonatomic, strong) UIImage* shopImage;
/**店家logo图片名称*/
@property (nonatomic, copy) NSString* fileName;
//机构类型列表
@property (nonatomic, strong) NSMutableArray* shopTypeList;

//是否有修改机构信息权限
@property (nonatomic, assign) BOOL isEditLock;
//是否有删除机构权限
@property (nonatomic, assign) BOOL isDelLock;
//指定供应商
@property (nonatomic, strong) HeaderGridItem* gridItem;
@property (nonatomic, strong) NSMutableArray *supplyList;
@property (nonatomic, strong) NSMutableArray *delSupplyList;
@property (nonatomic, weak) id<INameCode> item;
/** 1是直营 0是加盟商 */
@property (nonatomic, assign) NSInteger joinMode;
@end

@implementation LSOrgInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self initNavigate];
    [self initMainView];
    [self reload];
    [self initData];
    [self configHelpButton:HELP_SETTING_SHOP_INFO];
    [UIHelper clearColor:self.container];
    [UIHelper clearColor:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    self.settingService = [ServiceFactory shareInstance].settingService;
    self.orgVo = [[OrganizationVo alloc] init];
    self.addressList = [NSArray array];
    self.shopTypeList = [[NSMutableArray alloc] init];
    self.supplyList = [[NSMutableArray alloc] init];
    self.delSupplyList = [[NSMutableArray alloc] init];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;
    
    //标题
    
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    //container
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
}

- (void)configContainerViews {
    //店家编号
    self.txtShopNo = [LSEditItemText editItemText];
    [self.container addSubview:self.txtShopNo];
    
    //店家名称
    self.txtShopName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtShopName];
    
    //机构类型
    self.lsOrgType = [LSEditItemList editItemList];
    [self.container addSubview:self.lsOrgType];
    
    //加盟商
    self.rdoIsJoin = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoIsJoin];
    
    //所在地区:省市区
    self.lsShopAdr =[LSEditItemList editItemList];
    [self.container addSubview:self.lsShopAdr];
    
    //详细地址
    self.txtDetailAdr = [LSEditItemMemo editItemMemo];
    [self.container addSubview:self.txtDetailAdr];
    
    //联系人
    self.txtLinkMan = [LSEditItemText editItemText];
    [self.container addSubview:self.txtLinkMan];
    
    //手机号码
    self.txtPhone = [LSEditItemText editItemText];
    [self.container addSubview:self.txtPhone];
    
    //联系电话
    self.txtMobile = [LSEditItemText editItemText];
    [self.container addSubview:self.txtMobile];
    
    //员工信息
    self.lsEmpInfo = [LSEditItemList editItemList];
    [self.container addSubview:self.lsEmpInfo];
    
    //上级机构
    self.lsSuperOrg = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSuperOrg];
    
    //下级机构
    self.lsSubOrg = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSubOrg];
    
    //允许供货
    self.rdoAllowSupply = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoAllowSupply];
    
    //向指定公司采购
    self.rdoSupply = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoSupply];
    
    self.supplyDiv = [[UIView alloc] init];
    
    self.gridItem = [HeaderGridItem loadFromNib];
    [self.container addSubview:self.gridItem];
    
    //店家logo
    self.imgLogo = [EditItemImage2 editItemImage];
    //店家logo图片
    self.shopImage = [[UIImage alloc] init];
    [self.container addSubview:self.imgLogo];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.delView = btn.superview;
}

//是否有修改机构信息权限
- (void)reload
{
    self.isEditLock = [[Platform Instance] lockAct:ACTION_SHOP_EDIT];
    self.isDelLock = [[Platform Instance] lockAct:ACTION_SHOP_DELETE];
}

#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"组织机构信息" leftPath:Head_ICON_BACK rightPath:nil];
}

//页面返回|更新
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        if (self.handlerOrgInfo) {
            self.handlerOrgInfo(nil,_action);
        }
        if (_isLogin) {
            //登录时返回
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }else{
            //非登录时返回
            [XHAnimalUtil animalEdit:self.navigationController action:_action];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma mark - 初始化主视图
- (void)initMainView
{
    [self.txtShopNo initLabel:@"机构编号" withHit:nil isrequest:YES type:UIKeyboardTypeASCIICapable];
    [self.txtShopNo initMaxNum:16];
    
    [self.txtShopName initLabel:@"机构名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtShopName initMaxNum:50];
    
    [self.lsOrgType initLabel:@"机构类型" withHit:nil delegate:self];
    
    [self.rdoIsJoin initLabel:@"加盟商" withHit:nil];
    
    [self.lsShopAdr initLabel:@"所在地区" withHit:nil isrequest:YES delegate:self];
    
    [self.txtDetailAdr initLabel:@"详细地址" isrequest:YES delegate:self];
    
    [self.txtLinkMan initLabel:@"联系人" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtLinkMan initMaxNum:50];
    
    [self.txtPhone initLabel:@"手机号码" withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtPhone initMaxNum:11];
    
    [self.txtMobile initLabel:@"联系电话" withHit:nil isrequest:NO type:UIKeyboardTypeNumbersAndPunctuation];
    [self.txtMobile initMaxNum:13];
    
    [self.lsEmpInfo initLabel:@"员工信息" withHit:nil delegate:self];
    self.lsEmpInfo.lblVal.placeholder = @"";
    self.lsEmpInfo.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
    
    [self.lsSuperOrg initLabel:@"上级机构" withHit:nil delegate:self];
    self.lsSuperOrg.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
    
    [self.lsSubOrg initLabel:@"下属机构/门店" withHit:nil delegate:self];
    self.lsSubOrg.lblVal.placeholder = @"";
    self.lsSubOrg.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
    
    [self.rdoAllowSupply initLabel:@"允许供货" withHit:@"允许向下属门店/仓库供货"];
    
    [self.rdoSupply initLabel:@"向指定公司采购" withHit:nil delegate:self];
    
    [self.gridItem initDelegate:self withAddName:@"添加供应商..."];
    self.supplyDiv.hidden = YES;
    
    [self.imgLogo initLabel:@"机构LOGO" delegate:self title:@"机构LOGO"];
    
    self.txtDetailAdr.tag = SHOP_DETAIL_ADR;
    self.lsOrgType.tag = ORG_TYPE;
    self.lsShopAdr.tag = SHOP_ADR;
    self.lsEmpInfo.tag = EMP_INFO;
    self.lsSuperOrg.tag = ORG_SUPER;
    self.lsSubOrg.tag = SUB_ORG;
    self.rdoSupply.tag = ASSIN_SUPPLY;
}

#pragma mark - UI变化通知
- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notification
{
    [self changeUINavigate];
}

#pragma mark - 添加|编辑模式
- (void)initData
{
    [self showView:_isLogin];
    [self changeTitle];
    [self registerNotification];
    if (_action==ACTION_CONSTANTS_EDIT) {
        //编辑
        [self selectOrgDetail:_organizationId];
    }else{
        //添加
        [self clearDo];
    }
}

//显示页面项
- (void)showView:(BOOL)show
{
    self.delView.hidden = (show||_action==ACTION_CONSTANTS_ADD||self.isDelLock);
    [self.txtShopNo editEnabled:!(_action==ACTION_CONSTANTS_EDIT||show)];
    [self.lsOrgType editEnable:!(_action==ACTION_CONSTANTS_EDIT||show)];
    [self.imgLogo visibal:_action==ACTION_CONSTANTS_EDIT];
    [self.lsSubOrg visibal:_action==ACTION_CONSTANTS_EDIT];
    [self.lsSuperOrg editEnable:!(_action==ACTION_CONSTANTS_EDIT||show)];
    [self.lsEmpInfo visibal:_action==ACTION_CONSTANTS_EDIT];
}

//更改页面标题
- (void)changeTitle
{
    if (_action==ACTION_CONSTANTS_EDIT) {
        [self configTitle:@"组织机构信息" leftPath:Head_ICON_BACK rightPath:nil];
    }else{
        [self configTitle:@"添加机构" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
    }
}

//添加时设置页面初始值
- (void)clearDo
{
    self.orgVo = [[OrganizationVo alloc] init];
    self.shopTypeList = [[Platform Instance] getShopTypeList];
    [self.txtShopName initData:nil];
    [self.txtShopNo initData:nil];
    [self.lsOrgType initData:@"请选择" withVal:nil];
    [self.rdoIsJoin initData:@"0"];
    self.addressList = [[Platform Instance] getAddressList];
    [self.txtDetailAdr initData:nil];
    [self.txtLinkMan initData:nil];
    [self.txtPhone initData:nil];
    [self.txtMobile initData:nil];
    [self.lsSuperOrg initData:self.organizationName withVal:self.organizationId];
    [self.rdoAllowSupply initData:@"1"];
    [self.rdoSupply initData:@"0"];
    self.gridItem.hidden = YES;
}

- (void)editOrg
{
    [self.txtShopName editEnabled:!self.isEditLock];
    [self.lsShopAdr editEnable:!self.isEditLock];
    [self.txtDetailAdr editEnable:!self.isEditLock];
    [self.txtLinkMan editEnabled:!self.isEditLock];
    [self.txtPhone editEnabled:!self.isEditLock];
    [self.txtMobile editEnabled:!self.isEditLock];
    [self.rdoAllowSupply editable:!self.isEditLock];
    //    [self.imgLogo isEditable:!self.isEditLock];
    [self.rdoSupply editable:!self.isEditLock];
}

#pragma mark - 编辑添加回调方法
- (void)changeOrgInfo:(HandlerOrgInfo)handler;
{
    self.handlerOrgInfo = handler;
}

#pragma mark - 查询机构详情
- (void)selectOrgDetail:(NSString*)organizationId
{
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    __weak typeof(self) weakSelf = self;
    
    [_settingService selectOrganizationInfo:organizationId completionHandler:^(id json) {
        _orgVo = [OrganizationVo convertToOrganization:[json objectForKey:@"organization"]];
        weakSelf.delView.hidden = (weakSelf.orgVo.sonCount>0||weakSelf.isLogin);
        weakSelf.addressList = [json objectForKey:@"addressList"];
        [[Platform Instance] setAddressList:weakSelf.addressList];
        [weakSelf.txtShopName initData:_orgVo.name];
        [weakSelf.txtShopNo initData:_orgVo.code];
        weakSelf.shopTypeList = [ShopType converToArr:[json objectForKey:@"shopTypeList"]];
        [[Platform Instance] setShopTypeList:weakSelf.shopTypeList];
        NSString* typeId = [NSString stringWithFormat:@"%ld",(long)_orgVo.type];
        NSString* typeName = [GlobalRender obtainItem:weakSelf.shopTypeList itemId:typeId];
        [weakSelf.lsOrgType initData:typeName withVal:typeId];
        [weakSelf.lsSubOrg visibal:(_orgVo.type!=1)];
        [weakSelf.rdoIsJoin visibal:![@"0" isEqualToString:_orgVo.parentId]];
        if (_orgVo.joinMode == 1) {
            [weakSelf.rdoIsJoin initData:@"0"];
        } else {
            [weakSelf.rdoIsJoin initData:@"1"];
        }
        [weakSelf.rdoIsJoin editable:NO];
        NSString* addr = [GlobalRender getAddress:weakSelf.addressList PId:_orgVo.provinceId CId:_orgVo.cityId DId:_orgVo.countyId];
        if ([addr isEqualToString:@"(null)(null)(null)"]) {
//            [weakSelf.lsShopAdr initData:@"请选择" withVal:nil];
        } else {
            [weakSelf.lsShopAdr initData:addr withVal:addr];
        }
        [weakSelf.txtDetailAdr initData:_orgVo.address];
        [weakSelf.txtLinkMan initData:_orgVo.linkman];
        [weakSelf.txtPhone initData:_orgVo.mobile];
        [weakSelf.txtMobile initData:_orgVo.tel];
        [weakSelf.lsSuperOrg initData:_orgVo.parentName withVal:_orgVo.parentId];
        NSString *flag = [@"1" isEqualToString:_orgVo.allowSupply]?@"1":@"0";
        [weakSelf.rdoAllowSupply initData:flag];
        [weakSelf.imgLogo initView:_orgVo.fileName path:_orgVo.fileName];
        if ([NSString isNotBlank:_orgVo.fileName]) {
            [[Platform Instance] setFileName:_orgVo.fileName];
        }
        [weakSelf.lsSuperOrg visibal:![_orgVo.parentId isEqualToString:@"0"]];
        [weakSelf.imgLogo visibal:[_orgVo.parentId isEqualToString:@"0"]];
        BOOL visibal = [@"1" isEqualToString:typeId];
        [weakSelf editOrg];
        if (visibal) {
            [weakSelf.rdoAllowSupply visibal:!visibal];
            [weakSelf.rdoSupply visibal:!visibal];
            weakSelf.supplyDiv.hidden = visibal;
            weakSelf.gridItem.hidden = visibal;
        }else{
            [weakSelf.rdoSupply visibal:![_orgVo.parentId isEqualToString:@"0"]];
            NSString *flg = [@"1" isEqualToString:_orgVo.appointCompany]?@"1":@"0";
            [weakSelf.rdoSupply initData:flg];
            weakSelf.supplyDiv.hidden = ![weakSelf.rdoSupply getVal];
            weakSelf.gridItem.hidden = ![weakSelf.rdoSupply getVal];
            weakSelf.supplyList = _orgVo.purchaseSupplyVoList;
            [weakSelf.gridItem loadData:weakSelf.supplyList withIsEdit:!weakSelf.isEditLock];
        }
        [UIHelper refreshUI:weakSelf.container scrollview:weakSelf.scrollView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj
{
    if (obj.tag==SHOP_ADR) {
        //地址选择
        [AddressPickerBox initAddress:_addressList pId:_orgVo.provinceId cId:_orgVo.cityId dId:_orgVo.countyId];
        [AddressPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag==ORG_TYPE) {
        //选择机构类型
        [OptionPickerBox initData:self.shopTypeList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag==EMP_INFO) {
        //进入员工管理页面
        EmployeeManageView *vc = [[EmployeeManageView alloc] init];
        [self pushViewController:vc];
    }else if (obj.tag==ORG_SUPER) {
        //添加机构时,进入选择机构页面
        SelectOrgListView* selectOrgListView = [[SelectOrgListView alloc] init];
        __weak typeof(self) weakSelf = self;
        [selectOrgListView loadData:[self.lsSuperOrg getStrVal] callBack:^(id<ITreeItem> item) {
            if (item&&![[item obtainItemId] isEqualToString:[self.lsSuperOrg getStrVal]]) {
                //更改上级机构，清空指定供应商
                [weakSelf.supplyList removeAllObjects];
                [weakSelf.gridItem loadData:weakSelf.supplyList withIsEdit:YES];
                [UIHelper refreshUI:weakSelf.container scrollview:weakSelf.scrollView];
                [weakSelf.lsSuperOrg changeData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            if (item) {
                weakSelf.joinMode = [item obtainJoinMode];
                [weakSelf.rdoIsJoin changeData:(([item obtainJoinMode] == 1)?@"0":@"1")];
                if ([[self.lsOrgType getDataLabel] isEqualToString:@"公司"]) {
                     [weakSelf.rdoIsJoin editable:!([item obtainJoinMode] != 1)];
                }
               
            }
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }];
        [self.navigationController pushViewController:selectOrgListView animated:NO];
        selectOrgListView = nil;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }else if (obj.tag==SUB_ORG) {
        //下属机构/门店页面
        SubOrgShopListView* subOrgShopListView = [[SubOrgShopListView alloc] init];
        [subOrgShopListView loadData:self.orgVo.organizationId withOrgName:self.orgVo.name withParent:(self.orgVo.hierarchyCode.length==12)];
        [self.navigationController pushViewController:subOrgShopListView animated:NO];
        subOrgShopListView= nil;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

//详细地址
-(void) onItemMemoListClick:(LSEditItemMemo*)obj {
    if (obj == self.txtDetailAdr) {
        int tag = (int)obj.tag;
        MemoInputView *vc = [[MemoInputView alloc] init];
        [vc limitShow:tag delegate:self title:self.txtDetailAdr.lblName.text val:[self.txtDetailAdr getStrVal] limit:100];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    }
}

-(void) finishInput:(int)event content:(NSString*)content {
    if (event == SHOP_DETAIL_ADR) {
        [self.txtDetailAdr changeData:content];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    [self.lsOrgType changeData:[item obtainItemName] withVal:[item obtainItemId]];
    if ([self.rdoIsJoin getVal]&&[@"1" isEqualToString:[item obtainItemId]]) {
        [self.rdoIsJoin changeData:@"0"];
    }
    [self.rdoIsJoin editable:![@"1" isEqualToString:[item obtainItemId]]];
    BOOL visibal = [@"1" isEqualToString:[item obtainItemId]];
    [self.rdoAllowSupply visibal:!visibal];
    [self.rdoSupply visibal:!visibal];
    self.supplyDiv.hidden = visibal?YES:![@"1" isEqualToString:[self.rdoSupply getStrVal]];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

- (BOOL)pickAddress:(NSMutableArray *)selectArr event:(NSInteger)eventType
{
    NSString* provinceName = [[selectArr objectAtIndex:0] objectForKey:@"provinceName"];
    _orgVo.provinceId = [[selectArr objectAtIndex:0] objectForKey:@"provinceId"];
    
    NSString* cityName = [[selectArr objectAtIndex:1] objectForKey:@"cityName"];
    _orgVo.cityId = [[selectArr objectAtIndex:1] objectForKey:@"cityId"];
    
    NSString* districtName = @"";
    if (selectArr.count==3) {
        districtName = [[selectArr objectAtIndex:2] objectForKey:@"districtName"];
        _orgVo.countyId = [[selectArr objectAtIndex:2] objectForKey:@"districtId"];
    }
    
    NSString* address = nil;
    if ([_orgVo.provinceId isEqualToString:@"33"]||[_orgVo.provinceId isEqualToString:@"34"]) {
        address = [NSString stringWithFormat:@"%@",provinceName];
    }else{
        address = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,districtName];
    }
    
    [self.lsShopAdr changeData:address withVal:address];
    
    return YES;
}

#pragma mark - 指定供应商开关
- (void)onItemRadioClick:(LSEditItemRadio *)obj
{
    if (obj.tag==ASSIN_SUPPLY) {
        self.supplyDiv.hidden = ![obj getVal];
        self.gridItem.hidden = ![obj getVal];
        [self.gridItem loadData:self.supplyList withIsEdit:YES];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 添加指定供应商
- (void)showAddGridItem
{
    if ([NSString isBlank:[self.lsSuperOrg getStrVal]]) {
        [AlertBox show:@"请选择上级机构!"];
        return;
    }
    
    SelectAssignSupplierListView *listView = [[SelectAssignSupplierListView alloc] init];
    __weak typeof(self) wself = self;
    
    [listView loadDataByOrgId:[self.lsSuperOrg getStrVal] completed:^(NSMutableArray *selList) {
        if ([ObjectUtil isNotEmpty:selList]) {
            NSMutableArray *addArr = [NSMutableArray arrayWithCapacity:selList.count];
            for (PurchaseSupplyVo *vo in selList) {
                BOOL isHave = NO;
                BOOL flg = NO;
                if (wself.delSupplyList.count>0) {
                    for (PurchaseSupplyVo *delVo in wself.delSupplyList) {
                        if ([vo.supplyOrgId isEqualToString:delVo.supplyOrgId]) {
                            flg = YES;
                            [addArr addObject:delVo];
                            [wself.delSupplyList removeObject:delVo];
                            break;
                        }
                    }
                }
                if (wself.supplyList.count>0) {
                    for (PurchaseSupplyVo *existVo in wself.supplyList) {
                        if ([vo.supplyOrgId isEqualToString:existVo.supplyOrgId]) {
                            isHave = YES;
                            break;
                        }
                    }
                }
                if (!flg&&!isHave) {
                    vo.operateType = @"add";
                    [addArr addObject:vo];
                }
            }
            [wself.supplyList addObjectsFromArray:addArr];
            [wself.gridItem loadData:wself.supplyList withIsEdit:YES];
            [UIHelper refreshUI:wself.container scrollview:wself.scrollView];
            [wself changeUINavigate];
        }
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:listView animated:NO];
    listView = nil;
}

- (void)delGridItem:(id)obj
{
    self.item = (id<INameCode>)obj;
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",[self.item obtainItemName]] event:101];
}

- (void)changeUINavigate
{
    BOOL isChange = NO;
    if (self.delSupplyList.count>0) {
        isChange = YES;
    }
    if (self.supplyList.count>0) {
        for (PurchaseSupplyVo *vo in self.supplyList) {
            if ([@"add" isEqualToString:vo.operateType]) {
                isChange = YES;
                break;
            }
        }
    }
    [self editTitle:(isChange||([UIHelper currChange:self.container])) act:self.action];
}

#pragma mark - logo图片处理

- (void)onDelImgClick
{
    [self.imgLogo changeImg:@"" img:nil];
    [self.imgLogo isEditable:YES];
}

- (void)onConfirmImgClick:(NSInteger)btnIndex
{
    if (btnIndex==1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(__bridge NSString*)kUTTypeImage]) {
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    }else if(btnIndex==0){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    _shopImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (_shopImage!=nil) {
        _fileName = [NSString stringWithFormat:@"%@/%@.png" ,[[Platform Instance] getkey:SHOP_ID], [NSString getUniqueStrByUUID]];
        [self.imgLogo changeImg:_fileName img:_shopImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 验证
- (BOOL)isValid
{
    if ([NSString isBlank:[self.txtShopNo getStrVal]]) {
        [AlertBox show:@"组织机构编号不能为空，请输入!"];
        return NO;
    }
    if (self.action == ACTION_CONSTANTS_ADD) {
        if ([NSString isInvalidatedOrgNum:[self.txtShopNo getStrVal]]) {
            [AlertBox show:@"机构编号必须包含字母，请重新输入!"];
            return NO;
        }
    }
    if ([NSString isNotNumAndLetter:[self.txtShopNo getStrVal]]) {
        [AlertBox show:@"组织机构编号格式不正确，请重新输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtShopName getStrVal]]) {
        [AlertBox show:@"组织机构名称不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsOrgType getStrVal]]) {
        [AlertBox show:@"请选择机构类型!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsShopAdr getStrVal]]) {
        [AlertBox show:@"请选择所在地区!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtDetailAdr getStrVal]]) {
        [AlertBox show:@"详细地址不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtLinkMan getStrVal]]) {
        [AlertBox show:@"联系人不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtPhone getStrVal]]) {
        [AlertBox show:@"手机号码不能为空，请输入!"];
        return NO;
    }
    if (![NSString validateMobile:[self.txtPhone getStrVal]]) {
        [AlertBox show:@"手机号码格式不正确，请重新输入!"];
        return NO;
    }
    // 同时支持 固话、手机号码、传真
    if ([NSString isNotBlank:[self.txtMobile getStrVal]] && !([NSString validateMobile:[self.txtMobile getStrVal]] || [NSString validateHomeMobile:[self.txtMobile getStrVal]] || [NSString isValidateFax:[self.txtMobile getStrVal]])) {
        [AlertBox show:@"联系电话格式不正确，请重新输入!"];
        return NO;
    }
    if ([self.rdoSupply getVal]&&self.supplyList.count==0) {
        [AlertBox show:@"请添加指定采购的公司!"];
        return NO;
    }
    return YES;
}

#pragma mark - 数据模型赋值
- (void)transMode
{
    if ([NSString isNotBlank:_orgVo.fileName]&&[NSString isBlank:[self.imgLogo getImageFilePath]]) {
        
        _orgVo.fileOperate = [NSNumber numberWithShort:0];
        
    }else if([NSString isNotBlank:[self.imgLogo getImageFilePath]]&&![_orgVo.fileName isEqualToString:[self.imgLogo getImageFilePath]]){
        
        _orgVo.fileOperate = [NSNumber numberWithShort:1];
        
        _orgVo.fileName = _fileName;
        
    }else{
        _orgVo.fileOperate =nil;
        _orgVo.file = nil;
        _orgVo.fileName = nil;
    }
    _orgVo.name = [self.txtShopName getStrVal];
    _orgVo.code = [self.txtShopNo getStrVal];
    _orgVo.parentId = [self.lsSuperOrg getStrVal];
    _orgVo.parentName = self.lsSuperOrg.lblName.text;
    _orgVo.type = [[self.lsOrgType getStrVal] integerValue];
    if ([self.rdoIsJoin getVal]) {
        _orgVo.joinMode = 0;
    } else {
        _orgVo.joinMode = 1;
    }
    _orgVo.address = [self.txtDetailAdr getStrVal];
    _orgVo.linkman = [self.txtLinkMan getStrVal];
    _orgVo.mobile = [self.txtPhone getStrVal];
    _orgVo.tel = [self.txtMobile getStrVal];
    _orgVo.allowSupply = [self.rdoAllowSupply getVal]?@"1":@"2";
    NSMutableArray *arr = [[NSMutableArray array] init];
    if (self.delSupplyList.count>0) {
        for (PurchaseSupplyVo *delVo in self.delSupplyList) {
            delVo.operateType = @"del";
            [arr addObject:delVo];
        }
    }
    [arr addObjectsFromArray:self.supplyList];
    _orgVo.purchaseSupplyVoList = arr;
    _orgVo.appointCompany = [self.rdoSupply getVal]?@"1":@"2";
    if (_action==ACTION_CONSTANTS_ADD) {
        _orgVo.brandId = [[Platform Instance] getkey:BRAND_ID];
    }
}

#pragma mark - 更新机构信息
- (void)save
{
    if (![self isValid]) {
        return;
    }
    [self transMode];
    //存放图片对象
    NSMutableArray *imageVoList = [NSMutableArray array];
    //存放图片数据
    NSMutableArray *imageDataList = [NSMutableArray array];
    LSImageVo *imageVo = nil;
    LSImageDataVo *imageDataVo = nil;
    
    if (self.imgLogo.isChange) {
        if ([NSString isNotBlank:self.imgLogo.oldVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.imgLogo.oldVal opType:2 type:@"shop"];
            [imageVoList addObject:imageVo];
        }
        if ([NSString isNotBlank:self.imgLogo.currentVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.imgLogo.currentVal opType:1 type:@"shop"];
            [imageVoList addObject:imageVo];
            NSData *data = UIImageJPEGRepresentation(self.imgLogo.img.image, 0.1);
            imageDataVo = [LSImageDataVo imageDataVoWithData:data file:self.imgLogo.currentVal];
            [imageDataList addObject:imageDataVo];
        }
    }
    if ([NSString isBlank:self.imgLogo.currentVal]) {
        [[Platform Instance] setFileName:nil];
    }
    _orgVo.fileName = self.imgLogo.currentVal;
    //上传图片
    
    [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];
    
    NSString* operateType = _action==ACTION_CONSTANTS_ADD?@"add":@"edit";
    __weak typeof(self) weakSelf = self;
    [_settingService saveOrganizationInfo:_orgVo operateType:operateType completionHandler:^(id json) {
        if (_isLogin) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }else{
            [XHAnimalUtil animalEdit:weakSelf.navigationController action:_action];
        }
        if (weakSelf.handlerOrgInfo) {
            weakSelf.handlerOrgInfo(weakSelf.orgVo,_action);
        }
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma  mark - delete机构
- (void)btnClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗?",_orgVo.name] event:100];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //确定删除
        if (actionSheet.tag==100) {
            __weak typeof(self) weakSelf = self;
            [_settingService deleteOrganizationInfo:_orgVo.organizationId completionHandler:^(id json) {
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                if (weakSelf.handlerOrgInfo) {
                    weakSelf.handlerOrgInfo(weakSelf.orgVo,ACTION_CONSTANTS_DEL);
                }
                [weakSelf.navigationController popViewControllerAnimated:NO];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else{
            PurchaseSupplyVo *vo = self.item;
            if ([NSString isBlank:vo.operateType]) {
                [self.delSupplyList addObject:self.item];
            }
            [self.supplyList removeObject:self.item];
            [self.gridItem loadData:self.supplyList withIsEdit:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [self changeUINavigate];
        }
    }
}

@end
