//
//  WarehouseEditView.m
//  retailapp
//
//  Created by hm on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WarehouseEditView.h"
#import "ServiceFactory.h"
#import "StockModuleEvent.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "XHAnimalUtil.h"
#import "AddressPickerBox.h"
#import "INameItem.h"
#import "SelectOrgListView.h"
#import "AlertBox.h"
#import "WareHouseVo.h"
#import "AllShopVo.h"
#import "SupplyTypeVo.h"

@interface WarehouseEditView ()<IEditItemListEvent,AddressPickerClient,AlertBoxClient>

@property (strong, nonatomic) StockService* stockService;

@property (strong, nonatomic) CommonService *commonService;

/**页面模式*/
@property (nonatomic) NSInteger action;
/**省市区*/
@property (nonatomic,strong) NSArray* addressList;
/**回调block*/
@property (copy, nonatomic) EditWarehouseHandler editHandler;
/**仓库id*/
@property (copy, nonatomic) NSString *warehouseId;
/**仓库数据模型*/
@property (strong, nonatomic) WareHouseVo* warehouseVo;
/**代理*/
@property (weak, nonatomic) id<INameCode> item;

@end

@implementation WarehouseEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stockService = [ServiceFactory shareInstance].stockService;
    self.commonService = [ServiceFactory shareInstance].commonService;
    [self initNavigate];
    [self configViews];
    [self initMainView];
    [UIHelper clearColor:self.container];
    [UIHelper clearColor:self.container];
    [UIHelper refreshUI:self.container];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [self showViewEditable:(self.action==ACTION_CONSTANTS_ADD)];
    [self selectAddressList];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H)];
    [self.view addSubview:self.scrollView];
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.txtName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtName];
    
    self.txtCode = [LSEditItemText editItemText];
    [self.container addSubview:self.txtCode];
    
    self.lsOrg = [LSEditItemList editItemList];
    [self.container addSubview:self.lsOrg];
    
    self.lsDistrict = [LSEditItemList editItemList];
    [self.container addSubview:self.lsDistrict];
    
    self.txtAddress = [LSEditItemText editItemText];
    [self.container addSubview:self.txtAddress];
    
    self.txtLinkMan = [LSEditItemText editItemText];
    [self.container addSubview:self.txtLinkMan];
    
    self.txtMobile = [LSEditItemText editItemText];
    [self.container addSubview:self.txtMobile];
    
    self.txtTel = [LSEditItemText editItemText];
    [self.container addSubview:self.txtTel];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.delView = btn.superview;
    
    

}

#pragma mark - 获取省市区列表
- (void)selectAddressList
{
    __weak typeof(self) weakSelf = self;
    [self.stockService selelctAddressList:^(id json) {
        weakSelf.addressList = [json objectForKey:@"addressList"];
        [weakSelf loadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 接收前一页面参数
- (void)showDetail:(NSString*)warehouseId action:(NSInteger)action callBack:(EditWarehouseHandler)handler;
{
    self.action = action;
    self.editHandler = handler;
    self.warehouseId = warehouseId;
}

#pragma mark - 初始化导航栏
- (void)initNavigate
{
    [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        [XHAnimalUtil animalEdit:self.navigationController action:self.action];
        [self.navigationController popViewControllerAnimated:NO];
        
    }else{
        [self save];
    }
}

#pragma mark - 初始化详情页面
- (void)initMainView
{
    [self.txtName initLabel:@"仓库名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName initMaxNum:50];
    [self.txtCode initLabel:@"仓库编号" withHit:nil isrequest:YES type:UIKeyboardTypeASCIICapable];
    [self.txtCode initMaxNum:20];
    [self.lsOrg initLabel:@"所属机构" withHit:nil delegate:self];
    self.lsOrg.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
    [self.lsDistrict initLabel:@"所在地区" withHit:nil delegate:self];
    [self.txtAddress initLabel:@"详细地址" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtAddress initMaxNum:100];
    [self.txtLinkMan initLabel:@"联系人" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtLinkMan initMaxNum:50];
    [self.txtMobile initLabel:@"手机号码" withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtMobile initMaxNum:11];
    [self.txtTel initLabel:@"联系电话" withHit:nil isrequest:NO type:UIKeyboardTypeNumbersAndPunctuation];
    [self.txtTel initMaxNum:13];

    self.lsOrg.tag = ORGANIZATION;
    self.lsDistrict.tag = ADDRESS;
}

#pragma mark - 是否可编辑项
- (void)showViewEditable:(BOOL)isEdit
{
    self.txtCode.txtVal.enabled = isEdit;
    self.txtCode.txtVal.textColor = isEdit?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
    [self.lsOrg editEnable:isEdit];
    self.delView.hidden = YES;
}

#pragma mark - 注册|移除UI变化通知
- (void)registerNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];

}

- (void)dataChange:(NSNotification *)notification
{
    [self editTitle:[UIHelper currChange:self.container] act:self.action];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 加载页面数据
- (void)loadData
{
    [self registerNotification];
    if (self.action==ACTION_CONSTANTS_ADD) {
//        self.titleBox.lblTitle.text = @"添加";
        [self configTitle:@"添加仓库"];
        [self clearDo];
    }else{
        [self selectWarehouseDetail];
    }
}

//添加设置页面默认值
- (void)clearDo
{
    self.warehouseVo = [[WareHouseVo alloc] init];
    [self.txtName initData:nil];
    [self.txtCode initData:nil];
    [self.lsOrg initData:@"请选择" withVal:nil];
    [self.lsDistrict initData:@"请选择" withVal:nil];
    [self.txtAddress initData:nil];
    [self.txtLinkMan initData:nil];
    [self.txtMobile initData:nil];
    [self.txtTel initData:nil];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 查询仓库详情
- (void)selectWarehouseDetail
{
    __weak typeof(self) weakSelf = self;
    [_stockService selectWarehouseDetailById:self.warehouseId CompletionHandler:^(id json) {
        weakSelf.warehouseVo = [WareHouseVo converToVo:[json objectForKey:@"wareHouse"]];
        [weakSelf configTitle:weakSelf.warehouseVo.wareHouseName];
        [weakSelf.txtName initData:weakSelf.warehouseVo.wareHouseName];
        [weakSelf.txtCode initData:weakSelf.warehouseVo.wareHouseCode];
        [weakSelf.lsOrg initData:weakSelf.warehouseVo.orgName withVal:weakSelf.warehouseVo.orgId];
        NSString* addr = [GlobalRender getAddress:weakSelf.addressList PId:weakSelf.warehouseVo.provinceId CId:weakSelf.warehouseVo.cityId DId:weakSelf.warehouseVo.countryId];
        [weakSelf.lsDistrict initData:addr withVal:addr];
        [weakSelf.txtAddress initData:weakSelf.warehouseVo.address];
        [weakSelf.txtLinkMan initData:weakSelf.warehouseVo.linkMan];
        [weakSelf.txtMobile initData:weakSelf.warehouseVo.mobile];
        [weakSelf.txtTel initData:weakSelf.warehouseVo.phone];
        weakSelf.delView.hidden = NO;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}

#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj
{
    if (obj.tag==ORGANIZATION) {
        //选择机构
        SelectOrgListView* selectOrgListView = [[SelectOrgListView alloc] init];
        __weak typeof(self) weakSelf = self;
        [selectOrgListView loadData:[obj getStrVal] callBack:^(id<ITreeItem> item) {
            if (item) {
                [obj changeData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:selectOrgListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        selectOrgListView = nil;
    }else if (obj.tag==ADDRESS) {
        //选择省市区
        [AddressPickerBox initAddress:self.addressList pId:self.warehouseVo.provinceId cId:self.warehouseVo.cityId dId:self.warehouseVo.countryId];
        [AddressPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}

- (BOOL)pickAddress:(NSMutableArray *)selectArr event:(NSInteger)eventType
{
    NSString* provinceName = [[selectArr objectAtIndex:0] objectForKey:@"provinceName"];
    self.warehouseVo.provinceId = [[selectArr objectAtIndex:0] objectForKey:@"provinceId"];
    
    NSString* cityName = [[selectArr objectAtIndex:1] objectForKey:@"cityName"];
    self.warehouseVo.cityId = [[selectArr objectAtIndex:1] objectForKey:@"cityId"];
    
    NSString* districtName = @"";
    if (selectArr.count==3) {
        districtName = [[selectArr objectAtIndex:2] objectForKey:@"districtName"];
        self.warehouseVo.countryId = [[selectArr objectAtIndex:2] objectForKey:@"districtId"];
    }
    
    NSString* address = nil;
    if ([self.warehouseVo.provinceId isEqualToString:@"33"]||[self.warehouseVo.provinceId isEqualToString:@"34"]) {
        address = [NSString stringWithFormat:@"%@",provinceName];
    }else{
        address = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,districtName];
    }
    
    [self.lsDistrict changeData:address withVal:address];
    return YES;
}

#pragma mark - 删除仓库
- (void)btnClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"删除仓库[%@]吗?",self.warehouseVo.wareHouseName]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //删除仓库
        [self checkWareHouse];
    }
}

#pragma mark - 删除仓库
- (void)checkWareHouse
{
    __weak typeof(self) weakSelf = self;
    [self.stockService checkWareHouse:self.warehouseId CompletionHandler:^(id json) {
       short hasRecord = [[json objectForKey:@"hasRecord"] shortValue];
        if (hasRecord==0) {
            [weakSelf deleteWarehouse];
        }else{
            [AlertBox showBox:@"该仓库存在库存记录，确认要删除吗？" client:self];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)confirm
{
    [self deleteWarehouse];
}

- (void)understand
{
    
}

- (void)deleteWarehouse
{
    __weak typeof(self) weakSelf = self;
    [self.stockService deleteWareHouse:self.warehouseId CompletionHandler:^(id json) {
        weakSelf.editHandler(weakSelf.warehouseVo,ACTION_CONSTANTS_DEL);
        [weakSelf removeNotification];
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 验证页面参数
- (BOOL)isValide
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:@"仓库名称不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtCode getStrVal]]) {
        [AlertBox show:@"仓库编号不能为空，请输入!"];
        return NO;
    }
    if ([NSString isNotNumAndLetter:[self.txtCode getStrVal]]) {
        [AlertBox show:@"仓库编号格式不正确，请重新输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsOrg getStrVal]]) {
        [AlertBox show:@"请选择所属机构!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsDistrict getStrVal]]) {
        [AlertBox show:@"请选择所在地区!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtAddress getStrVal]]) {
        [AlertBox show:@"详细地址不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtLinkMan getStrVal]]) {
        [AlertBox show:@"联系人不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtMobile getStrVal]]) {
        [AlertBox show:@"手机号码不能为空，请输入!"];
        return NO;
    }
    if (![NSString validateMobile:[self.txtMobile getStrVal]]) {
        [AlertBox show:@"手机号码格式不正确，请重新输入!"];
        return NO;
    }
    if ([NSString isNotBlank:[self.txtTel getStrVal]]&&![NSString isValidateFax:[self.txtTel getStrVal]]) {
        [AlertBox show:@"联系电话格式不正确，请重新输入!"];
        return NO;
    }

    return YES;
}

#pragma mark - 数据转化
- (void)transMode
{
    self.warehouseVo.wareHouseId = self.warehouseId;
    self.warehouseVo.wareHouseName = [self.txtName getStrVal];
    self.warehouseVo.wareHouseCode = [self.txtCode getStrVal];
    self.warehouseVo.orgId = [self.lsOrg getStrVal];
    self.warehouseVo.orgName = self.lsOrg.lblVal.text;
    self.warehouseVo.address = [self.txtAddress getStrVal];
    self.warehouseVo.linkMan = [self.txtLinkMan getStrVal];
    self.warehouseVo.mobile = [self.txtMobile getStrVal];
    self.warehouseVo.phone = [self.txtTel getStrVal];
 
    self.item = self.warehouseVo;
    self.warehouseVo.operateType = (self.action==ACTION_CONSTANTS_ADD)?@"add":@"save";
}

#pragma mark - 保存仓库信息
- (void)save
{
    if (![self isValide]) {
        return;
    }
    [self transMode];
    __weak typeof(self) weakSelf = self;
    [self.stockService operateWarehouse:self.warehouseVo.operateType withWareHouse:self.warehouseVo CompletionHandler:^(id json) {
        if (weakSelf.action ==ACTION_CONSTANTS_ADD) {
            weakSelf.editHandler(nil,ACTION_CONSTANTS_ADD);
        }else{
            weakSelf.editHandler(weakSelf.item,ACTION_CONSTANTS_EDIT);
        }
        [weakSelf removeNotification];
        [XHAnimalUtil animalEdit:weakSelf.navigationController action:weakSelf.action];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


@end
