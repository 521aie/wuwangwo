//
//  LSChainShopInfoController.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSChainShopInfoController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SettingModuleEvent.h"
#import "LSEditItemText.h"
#import "LSEditItemList.h"
#import "EditItemImage2.h"
#import "LSEditItemMemo.h"
#import "LSEditItemRadio.h"
#import "HeaderGridItem.h"
#import "OptionPickerBox.h"
#import "AddressPickerBox.h"
#import "TimePickerBox.h"
#import "NameItemVO.h"
#import "MenuList.h"
#import "SymbolNumberInputBox.h"
#import "MemoInputView.h"
#import "ColorHelper.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "DateUtils.h"
#import "JsonHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ShopVo.h"
#import "LSImageDataVo.h"
#import "LSImageVo.h"
#import "PurchaseSupplyVo.h"
#import "SelectAssignSupplierListView.h"
#import "SelectOrgShopListView.h"
#import "SelectOrgListView.h"
#import "SVProgressHUD.h"
#import "LSEditShopInfoBox.h"
#import "MicroGoodsImageVo.h"
#import "SelectImgItem.h"
#import "ImageUtils.h"
#import "TZImagePickerController.h"
@interface LSChainShopInfoController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,IEditItemImageEvent,IEditItemListEvent,IEditItemRadioEvent,IEditItemMemoEvent,OptionPickerClient,TimePickerClient,AddressPickerClient,SymbolNumberInputClient,MemoInputClient,HeaderGridItemDelegate, TZImagePickerControllerDelegate> {
    NSMutableArray *filePathList;
    UIImage *goodsImage;
}
@property (nonatomic,strong) SettingService* settingService;

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* container;

/**门店编号*/
@property (nonatomic, strong) LSEditItemText* txtShopNo;
/**门店名称*/
@property (nonatomic, strong) LSEditItemText* txtShopName;
/**上级机构*/
@property (nonatomic,strong) LSEditItemList* lsSuperOrg;
/**所属行业*/
@property (nonatomic, strong) LSEditItemList* lsShopIndustry;
/**所在地区*/
@property (nonatomic, strong) LSEditItemList* lsShopAdr;
/**详细地址*/
@property (nonatomic, strong) LSEditItemMemo* txtDetailAdr;
/**店铺面积*/
@property (nonatomic, strong) LSEditItemList* lsArea;
/**联系人*/
@property (nonatomic, strong) LSEditItemText* txtLinkMan;
/**手机号码*/
@property (nonatomic, strong) LSEditItemText* txtPhone;
/**联系电话*/
@property (nonatomic, strong) LSEditItemText* txtMobile;
/**微信*/
@property (nonatomic, strong) LSEditItemText* txtWechat;
/**营业开始时间*/
@property (nonatomic, strong) LSEditItemList* lsStartTime;
/**营业结束时间*/
@property (nonatomic, strong) LSEditItemList* lsEndTime;
//向指定公司采购
@property (nonatomic,strong) LSEditItemRadio* rdoSupply;
//添加供应商
@property (nonatomic,strong) UIView* supplyDiv;
@property (nonatomic,strong) LSEditItemRadio* rdoIsCopy;
@property (nonatomic,strong) LSEditItemList* lsChainShop;
@property (nonatomic,strong) UIView* delView;
/**店家logo*/
@property (nonatomic, strong) EditItemImage2* imgLogo;
/**店铺介绍*/
@property (nonatomic, strong) LSEditItemMemo *txtIntro;

/**店家模型*/
@property (nonatomic,strong) ShopVo* shop;
/**地址列表*/
@property (nonatomic,strong) NSArray* addressList;
/**所属行业*/
@property (nonatomic,strong) NSMutableArray* professionList;
/**图片选择器*/
@property (nonatomic,strong) UIImagePickerController *imagePickerController;
/**图片选择器*/
@property (nonatomic,strong) UIImagePickerController *logoImagePickerController;
/**店家logo图片*/
@property (nonatomic,strong) UIImage* shopImage;
/**店家logo图片名称*/
@property (nonatomic,copy) NSString* fileName;
//是否有修改门店权限
@property (nonatomic, assign) BOOL isEditLock;

//true-Shop  false-Organization
@property (nonatomic,assign) BOOL synIsShop;
//是否有删除门店权限
@property (nonatomic,assign) BOOL isShopDelLock;
@property (nonatomic, strong) HeaderGridItem* gridItem;
@property (nonatomic, strong) NSMutableArray *supplyList;
@property (nonatomic, strong) NSMutableArray *delSupplyList;
@property (nonatomic, strong) id<INameCode> item;
@property (nonatomic,strong) NSMutableDictionary *param;

@property (nonatomic, strong) NSString* imgFilePathTemp;
/** 店家图片 */
@property (nonatomic, strong) LSEditShopInfoBox *boxPicture;

@end

@implementation LSChainShopInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self initNavigate];
    [self initMainView];
    if (!self.isLogin) {
        [self reload];
    }
    [self initData];
    [self configHelpButton:HELP_SETTING_SHOP_INFO];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    self.settingService = [ServiceFactory shareInstance].settingService;
    self.shop = [[ShopVo alloc] init];
    self.addressList = [[NSArray alloc] init];
    self.professionList = [[NSMutableArray alloc] init];
    self.supplyList = [[NSMutableArray alloc] init];
    self.delSupplyList = [[NSMutableArray alloc] init];
    self.param = [[NSMutableDictionary alloc] init];
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;
    
    self.logoImagePickerController = [[UIImagePickerController alloc] init];
    self.logoImagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    self.logoImagePickerController.allowsEditing = YES;
    self.logoImagePickerController.delegate = self;
    
    //标题
   
    
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH,SCREEN_W , SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    //container
    self.container = [[UIView alloc] init];
    self.container.frame = CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height);
    [self.scrollView addSubview:self.container];
}


- (void)configContainerViews {
    //门店编号
    self.txtShopNo = [LSEditItemText editItemText];
    [self.container addSubview:self.txtShopNo];
    
    //门店名称
    self.txtShopName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtShopName];
    
    //上级机构
    self.lsSuperOrg = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSuperOrg];
    
    //所属行业
    self.lsShopIndustry = [LSEditItemList editItemList];
    [self.container addSubview:self.lsShopIndustry];
    
    //所在地区
    self.lsShopAdr =[LSEditItemList editItemList];
    [self.container addSubview:self.lsShopAdr];
    
    //详细地址
    self.txtDetailAdr = [LSEditItemMemo editItemMemo];
    [self.container addSubview:self.txtDetailAdr];
    
    //店铺面积
    self.lsArea = [LSEditItemList editItemList];
    [self.container addSubview:self.lsArea];
    
    //联系人
    self.txtLinkMan = [LSEditItemText editItemText];
    [self.container addSubview:self.txtLinkMan];
    
    //手机号码
    self.txtPhone = [LSEditItemText editItemText];
    [self.container addSubview:self.txtPhone];
    
    //联系电话
    self.txtMobile = [LSEditItemText editItemText];
    [self.container addSubview:self.txtMobile];
    
    //微信
    self.txtWechat = [LSEditItemText editItemText];
    [self.container addSubview:self.txtWechat];
    
    //营业开始时间
    self.lsStartTime = [LSEditItemList editItemList];
    [self.container addSubview:self.lsStartTime];
    
    //营业结束时间
    self.lsEndTime = [LSEditItemList editItemList];
    [self.container addSubview:self.lsEndTime];
    
    //向指定公司采购
    self.rdoSupply = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoSupply];
    
    //添加供应商
    self.supplyDiv = [[UIView alloc] init];
    self.gridItem = [HeaderGridItem loadFromNib];
    //    [self.supplyDiv addSubview:self.gridItem];
    [self.container addSubview:self.gridItem];
    
    //复制其他门店商品数据
    self.rdoIsCopy = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoIsCopy];
    
    //机构/门店
    self.lsChainShop = [LSEditItemList editItemList];
    [self.container addSubview:self.lsChainShop];
    
    //店家logo
    self.imgLogo = [EditItemImage2 editItemImage];
    //店家logo图片
    self.shopImage = [[UIImage alloc] init];
    [self.container addSubview:self.imgLogo];
    
    //店铺介绍
//<<<<<<< HEAD
//    self.txtIntro = [EditItemMemo editItemMemo];
//    [self.container addSubview:self.txtIntro];    
//=======
    self.txtIntro = [LSEditItemMemo editItemMemo];
    [self.container addSubview:self.txtIntro];
    
    //提示信息
    [LSViewFactor addClearView:self.container y:0 h:10];
    NSString *remaindTxt = @"提示：店铺介绍将展现在微店分享的链接中，生动的店铺介绍有助于让顾客一秒就记住您的店铺哦~~";
    [LSViewFactor addExplainText:self.container text:remaindTxt y:0];
    
    //横线
    [LSViewFactor addLine:self.container y:0];
    
    //店家图片
    self.boxPicture = [LSEditShopInfoBox editShopInfpBox];
    [self.container addSubview:self.boxPicture];
    [self.boxPicture initImgList:nil];
    [self.boxPicture initLabel:@"店家图片" delegate:self];
    self.boxPicture.hidden = YES;
    
    //删除
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    self.delView = btn.superview;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 门店删除权限
- (void)reload
{
    self.isShopDelLock = [[Platform Instance] lockAct:ACTION_SHOP_DELETE];
}

#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"门店信息" leftPath:Head_ICON_BACK rightPath:nil];
}

//页面返回|数据保存
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        if (_isLogin) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }else{
            [XHAnimalUtil animalEdit:self.navigationController action:_action];
        }
        if (self.handlerChainInfo) {
            self.handlerChainInfo(nil,_action);
        }
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma mark - 初始化主视图
- (void)initMainView
{
    [self.txtShopNo initLabel:@"门店编号" withHit:nil isrequest:YES type:UIKeyboardTypeASCIICapable];
    [self.txtShopNo initMaxNum:16];
    
    [self.txtShopName initLabel:@"门店名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtShopName initMaxNum:50];
    
    [self.lsSuperOrg initLabel:@"上级机构" withHit:nil delegate:self];
    [self.lsSuperOrg.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    [self.lsShopIndustry initLabel:@"所属行业" withHit:nil isrequest:YES delegate:self];
    
    [self.lsShopAdr initLabel:@"所在地区" withHit:nil isrequest:YES delegate:self];
    
    [self.txtDetailAdr initLabel:@"详细地址" isrequest:YES delegate:self];
    
    [self.lsArea initLabel:@"店铺面积(m²)" withHit:nil delegate:self];
    
    [self.txtLinkMan initLabel:@"联系人" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtLinkMan initMaxNum:50];
    
    [self.txtPhone initLabel:@"手机号码" withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtPhone initMaxNum:11];
    
    [self.txtMobile initLabel:@"联系电话" withHit:nil isrequest:NO type:UIKeyboardTypeNumbersAndPunctuation];
    [self.txtMobile initMaxNum:13];
    
    [self.txtWechat initLabel:@"微信" withHit:nil isrequest:NO type:UIKeyboardTypeASCIICapable];
    [self.txtWechat initMaxNum:50];
    
    [self.lsStartTime initLabel:@"营业开始时间" withHit:nil delegate:self];
    
    [self.lsEndTime initLabel:@"营业结束时间" withHit:nil delegate:self];
    
    [self.rdoSupply initLabel:@"向指定公司采购" withHit:nil delegate:self];
    
    [self.gridItem initDelegate:self withAddName:@"添加供应商..."];
    self.supplyDiv.hidden = YES;
    
    [self.rdoIsCopy initLabel:@"复制其他门店商品数据" withHit:nil delegate:self];
    
    [self.lsChainShop initLabel:@"▪︎ 机构/门店" withHit:nil delegate:self];
    [self.lsChainShop.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    [self.imgLogo initLabel:@"门店LOGO" delegate:self title:@"门店LOGO"];
    
    [self.txtIntro initLabel:@"店铺介绍" isrequest:NO delegate:self];
    
    self.lsSuperOrg.tag = SHOP_SUPER;
    self.lsShopIndustry.tag = SHOP_INDUSRY;
    self.lsShopAdr.tag = SHOP_ADR;
    self.txtDetailAdr.tag = SHOP_DETAIL_ADR;
    self.lsArea.tag = SHOP_AREA;
    self.lsStartTime.tag = START_TIME;
    self.lsEndTime.tag = END_TIME;
    self.rdoSupply.tag = ASSIN_SUPPLY;
    self.rdoIsCopy.tag = DATA_COPY;
    self.lsChainShop.tag = SHOP_CHAIN;
    self.txtIntro.tag = TXT_INTRO;
}

//是否有修改门店权限
- (void)editShop
{
    self.isEditLock = [[Platform Instance] lockAct:ACTION_SHOP_EDIT];
    [self.txtShopName editEnabled:!self.isEditLock];
    [self.lsShopIndustry editEnable:!self.isEditLock];
    [self.lsShopAdr editEnable:!self.isEditLock];
    [self.txtDetailAdr editEnable:!self.isEditLock];
    [self.lsArea editEnable:!self.isEditLock];
    [self.txtLinkMan editEnabled:!self.isEditLock];
    [self.txtPhone editEnabled:!self.isEditLock];
    [self.txtMobile editEnabled:!self.isEditLock];
    [self.txtWechat editEnabled:!self.isEditLock];
    [self.lsStartTime editEnable:!self.isEditLock];
    [self.lsEndTime editEnable:!self.isEditLock];
    [self.rdoIsCopy editable:!self.isEditLock];
    [self.imgLogo isEditable:!self.isEditLock];
    [self.lsChainShop editEnable:!self.isEditLock];
    [self.rdoSupply editable:!self.isEditLock];
    [self.txtIntro editEnable:!self.isEditLock];
    if (self.isEditLock) {
        [self.boxPicture imageBoxUneditable];
        self.boxPicture.userInteractionEnabled = NO;
    }
}

#pragma mark -注册UI变化通知
- (void)registerNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notification
{
    [self changeUINavigate];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 页面回调
- (void)changChainInfo:(HandlerChainInfo)handler
{
    self.handlerChainInfo = handler;
}

#pragma mark - 编辑|添加
- (void)initData
{
    [self registerNotification];
    [self showView:_isLogin];
    if (_action==ACTION_CONSTANTS_ADD) {
        [self configTitle:@"添加门店" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
        [self loadData];
        [self clearDo];
    }else{
        [self configTitle:@"门店信息" leftPath:Head_ICON_BACK rightPath:nil];
        [self selectShopInfo:_shopId];
    }
}

//显示页面元素
- (void)showView:(BOOL)show
{
    self.delView.hidden = (_action==ACTION_CONSTANTS_ADD||show||self.isShopDelLock);
    [self.rdoIsCopy visibal:!show];
    [self.lsChainShop visibal:NO];
    [self.lsSuperOrg editEnable:_action==ACTION_CONSTANTS_ADD];
    [self.txtShopNo  editEnabled:(_action==ACTION_CONSTANTS_ADD)];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

//添加时设置默认值
- (void)clearDo
{
    self.shop = [[ShopVo alloc] init];
    
    self.shop.brandId = [[Platform Instance] getkey:BRAND_ID];
    self.fileName = [[Platform Instance] getFileName];
    
    [self.txtShopNo initData:nil];
    [self.txtShopName initData:nil];
    [self.lsSuperOrg initData:self.superOrgName withVal:self.superOrgId];
    [self.lsShopIndustry initData:@"" withVal:nil];
    self.addressList = [[Platform Instance] getAddressList];
    [self.txtDetailAdr initData:nil];
    [self.lsArea initData:@"" withVal:nil];
    [self.txtLinkMan initData:nil];
    [self.txtPhone initData:nil];
    [self.txtMobile initData:nil];
    [self.txtWechat initData:nil];
    [self.lsStartTime initData:@"00:00" withVal:@"00:00"];
    [self.lsEndTime initData:@"00:00" withVal:@"00:00"];
    [self.rdoSupply initData:@"0"];
    self.gridItem.hidden = YES;
    [self.rdoIsCopy initData:@"0"];
    [self.lsChainShop initData:@"请选择" withVal:nil];
    [self.imgLogo initView:self.fileName path:self.fileName];
    [self.txtIntro initData:nil];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"shop/getProfessionList";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSArray *profList = json[@"professionList"];
        NameItemVO *item = nil;
        for (NSDictionary *obj in profList) {
            item = [[NameItemVO alloc] initWithVal:obj[@"name"] andId:[obj[@"code"] stringValue]];
            [weakSelf.professionList addObject:item];
            
            //所属行业
            if ([ObjectUtil isNotNull:_shop.profession]) {
                for (item in weakSelf.professionList) {
                    if ([[item obtainItemId] isEqualToString:_shop.profession.stringValue]) {
                        [weakSelf.lsShopIndustry initData:[item obtainItemName] withVal:[item obtainItemId]];
                    }
                }
            }else{
                [weakSelf.lsShopIndustry initData:@"" withVal:nil];
            }
            
            [weakSelf.gridItem loadData:weakSelf.supplyList withIsEdit:!weakSelf.isEditLock];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

#pragma mark - 查询门店信息
- (void)selectShopInfo:(NSString*)shopId
{
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self registerNotification];
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:self.shopEntityId forKey:@"shopEntityId"];
    NSString* url = @"shop/detailById";
    __weak typeof(self) weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        _shop = [ShopVo convertToShop:[json objectForKey:@"shop"]];
        _addressList = [json objectForKey:@"addressList"];
        NSArray *profList = [json objectForKey:@"professionList"];
        NameItemVO *item = nil;
        for (NSDictionary *obj in profList) {
            item = [[NameItemVO alloc] initWithVal:obj[@"name"] andId:[obj[@"code"] stringValue]];
            [weakSelf.professionList addObject:item];
        }
        
        [weakSelf.txtShopNo initData:_shop.code];
        [weakSelf.txtShopName initData:_shop.shopName];
        [weakSelf.lsSuperOrg initData:_shop.orgName withVal:_shop.orgId];

        //所属行业
        if ([ObjectUtil isNotNull:_shop.profession]) {
            for (item in weakSelf.professionList) {
                if ([[item obtainItemId] isEqualToString:_shop.profession.stringValue]) {
                    [weakSelf.lsShopIndustry initData:[item obtainItemName] withVal:[item obtainItemId]];
                }
            }
        }else{
            [weakSelf.lsShopIndustry initData:@"" withVal:nil];
        }
        
        NSString* addr = [GlobalRender getAddress:_addressList PId:_shop.provinceId CId:_shop.cityId DId:_shop.countyId];
        [weakSelf.lsShopAdr initData:addr withVal:addr];
        
        [weakSelf.txtDetailAdr initData:_shop.address];
        
        NSString* area = [_shop.area doubleValue]==0?@"":[NSString stringWithFormat:@"%.2f",[_shop.area doubleValue]];
        [weakSelf.lsArea initData:area withVal:area];
        
        [weakSelf.txtLinkMan initData:_shop.linkman];
        [weakSelf.txtPhone initData:_shop.phone1];
        [weakSelf.txtMobile initData:_shop.phone2];
        [weakSelf.txtWechat initData:_shop.weixin];
        [weakSelf.lsStartTime initData:_shop.startTime withVal:_shop.startTime];
        [weakSelf.lsEndTime initData:_shop.endTime withVal:_shop.endTime];
        NSString *flg = [@"1" isEqualToString:_shop.appointCompany]?@"1":@"0";
        [weakSelf.rdoSupply initData:flg];
        weakSelf.supplyDiv.hidden = ![weakSelf.rdoSupply getVal];
        weakSelf.gridItem.hidden = ![weakSelf.rdoSupply getVal];
        [weakSelf.rdoIsCopy initData:_shop.flag];
        [weakSelf.lsChainShop visibal:[_shop.flag isEqualToString:@"1"]];
        [weakSelf.lsChainShop initData:@"请选择" withVal:@""];
        [weakSelf editShop];
        [weakSelf.imgLogo initView:_shop.fileName path:_shop.fileName];
        [weakSelf.txtIntro initData:_shop.introduce];
        
        if (self.shop.mainImageVoList != nil && self.shop.mainImageVoList.count > 0) {
            [self.boxPicture initImgList:self.shop.mainImageVoList];
        } else {
            [self.boxPicture initImgList:nil];
        }
        [filePathList addObjectsFromArray:[self.boxPicture getFilePathList]];
        
        weakSelf.supplyList = _shop.purchaseSupplyVoList;
        [weakSelf.gridItem loadData:weakSelf.supplyList withIsEdit:!weakSelf.isEditLock];
        [UIHelper refreshUI:weakSelf.container scrollview:weakSelf.scrollView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(EditItemList *)obj
{
    NSDate* date = nil;
    if (obj.tag==SHOP_SUPER) {
        //选择机构
        SelectOrgListView* selectOrgListView = [[SelectOrgListView alloc] init];
        __weak typeof(self) weakSelf = self;
        [selectOrgListView loadData:[obj getStrVal] callBack:^(id<ITreeItem> item) {
            if (item) {
                if (![[item obtainItemId] isEqualToString:[obj getStrVal]]) {
                    //更改上级机构，清空指定供应商
                    [weakSelf.supplyList removeAllObjects];
                    [weakSelf.gridItem loadData:weakSelf.supplyList withIsEdit:YES];
                    [UIHelper refreshUI:weakSelf.container scrollview:weakSelf.scrollView];
                }
                [weakSelf.lsSuperOrg changeData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            [weakSelf.navigationController popToViewController:weakSelf animated:YES];
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:selectOrgListView animated:NO];
        selectOrgListView = nil;
    }else  if (obj.tag==SHOP_INDUSRY) {
        //所属行业
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        [OptionPickerBox initData:_professionList itemId:[obj getStrVal]];
    }else if (obj.tag==SHOP_ADR) {
        //选择地区
        [AddressPickerBox initAddress:_addressList pId:_shop.provinceId cId:_shop.cityId dId:_shop.countyId];
        [AddressPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag==SHOP_AREA) {
        //面积
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:8 digitLimit:2];
    }else if (obj.tag==START_TIME) {
        //营业开始时间
        date=[DateUtils parseDateTime6:[self.lsStartTime getStrVal]];
        [TimePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }else if (obj.tag==END_TIME) {
        //营业结束时间
        date=[DateUtils parseDateTime6:[self.lsEndTime getStrVal]];
        [TimePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }else if (obj.tag==SHOP_CHAIN) {
        //跳转页面至选择机构/门店
        SelectOrgShopListView* selectOrgShopListView = [[SelectOrgShopListView alloc] init];
        __weak typeof (self) weakSelf = self;
        [selectOrgShopListView loadData:[obj getStrVal] withModuleType:3 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
            if (item) {
                weakSelf.synIsShop = ([item obtainItemType]==2);
                [weakSelf.lsChainShop changeData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }];
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:selectOrgShopListView animated:NO];
        selectOrgShopListView = nil;
    }
}

//所属行业
-(BOOL)pickOption:(id)selectObj event:(NSInteger)eventType{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == SHOP_INDUSRY) {
        [self.lsShopIndustry changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

//选择日期时间
- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event
{
    NSString* timeStr=[DateUtils formateChineseTime:date];
    
    if (event==START_TIME) {
        [self.lsStartTime changeData:timeStr withVal:timeStr];
    }else if (event==END_TIME) {
        [self.lsEndTime changeData:timeStr withVal:timeStr];
    }
    return YES;
}

//选择地址
- (BOOL)pickAddress:(NSMutableArray *)selectArr event:(NSInteger)eventType
{
    //省
    NSString* provinceName = [[selectArr objectAtIndex:0] objectForKey:@"provinceName"];
    _shop.provinceId = [[selectArr objectAtIndex:0] objectForKey:@"provinceId"];
    //市
    NSString* cityName = [[selectArr objectAtIndex:1] objectForKey:@"cityName"];
    _shop.cityId = [[selectArr objectAtIndex:1] objectForKey:@"cityId"];
    //区
    NSString* districtName = @"";
    _shop.countyId = @"1";//此值是必传值有可能没有所以随便赋值了
    if (selectArr.count==3) {
        districtName = [[selectArr objectAtIndex:2] objectForKey:@"districtName"];
        _shop.countyId = [[selectArr objectAtIndex:2] objectForKey:@"districtId"];
    }
    
    NSString* address = nil;
    if ([_shop.provinceId isEqualToString:@"33"]||[_shop.provinceId isEqualToString:@"34"]) {
        address = [NSString stringWithFormat:@"%@",provinceName];
    }else{
        address = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,districtName];
    }
    
    [self.lsShopAdr changeData:address withVal:address];
    return YES;
}

//数字输入
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if ([val doubleValue]==0) {
        [AlertBox show:@"输入的店铺面积必需大于0!"];
        return;
    }
    NSString* value = [NSString stringWithFormat:@"%8.2f",[val doubleValue]];
    [self.lsArea changeData:value withVal:value];
}

//详细地址&店铺介绍
-(void) onItemMemoListClick:(LSEditItemMemo*)obj {
    if (obj == self.txtDetailAdr) {
        int tag = (int)obj.tag;
        MemoInputView *vc = [[MemoInputView alloc] init];
        [vc limitShow:tag delegate:self title:self.txtDetailAdr.lblName.text val:[self.txtDetailAdr getStrVal] limit:100];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    }else if (obj == self.txtIntro) {
        int tag = (int)obj.tag;
        MemoInputView *vc = [[MemoInputView alloc] init];
        [vc limitShow:tag delegate:self title:self.txtIntro.lblName.text val:[self.txtIntro getStrVal] limit:255];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    }
}

-(void) finishInput:(int)event content:(NSString*)content {
    if (event == SHOP_DETAIL_ADR) {
        [self.txtDetailAdr changeData:content];
    }else if (event == TXT_INTRO) {
        [self.txtIntro changeData:content];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 数据拷贝页面显示
- (void)onItemRadioClick:(LSEditItemRadio *)obj
{
    if (obj.tag==DATA_COPY) {
        [self.lsChainShop visibal:[obj getVal]];
    }else if (obj.tag==ASSIN_SUPPLY) {
        self.supplyDiv.hidden = ![obj getVal];
        self.gridItem.hidden = ![obj getVal];;
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
//删除图片
- (void)onDelImgClick
{
    [self.imgLogo changeImg:@"" img:nil];
}

#pragma mark - 门店logo选择
- (void)onConfirmImgClick:(NSInteger)btnIndex
{
    if (btnIndex==1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(__bridge NSString*)kUTTypeImage]) {
            _logoImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_logoImagePickerController animated:YES completion:nil];
        }
    }else if(btnIndex==0){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            _logoImagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_logoImagePickerController animated:YES completion:nil];
        }
    }
}

#pragma mark - 门店logo 店家图片选择
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (picker == self.logoImagePickerController) {
        _shopImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (_shopImage!=nil) {
            NSString *filePath = _shop.shopId;
            if ([NSString isBlank:filePath]) {
                filePath = [NSString getUniqueStrByUUID];
            }
            _fileName = [NSString stringWithFormat:@"%@/%@.png", filePath, [NSString getUniqueStrByUUID]];
            [self.imgLogo changeImg:_fileName img:_shopImage];
        }
        
    } else if (picker == self.imagePickerController) {
        
        //添加到集合中
        goodsImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        goodsImage = [ImageUtils scaleImageOfDifferentCondition:goodsImage
                                                      condition:[[Platform Instance] getkey:SHOP_MODE].intValue];
        NSString *filePath = [NSString stringWithFormat:@"%@.png", [NSString getUniqueStrByUUID]];
        self.imgFilePathTemp = filePath;
        [self uploadImgFinsh];
        
    }
}

- (void)uploadImgFinsh {
    [self.boxPicture changeImg:self.imgFilePathTemp img:goodsImage];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)updateViewSize {
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)onDelImgClickWithPath:(NSString *)path {
    [self.boxPicture removeFilePath:path];
}

#pragma mark - 店家信息图片选择
- (void)onConfirmImgClickWithTag:(NSInteger)btnIndex tag:(NSInteger)tag {
    if (btnIndex == 1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"]; return;
        }
        
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
    } else if(btnIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5-[self.boxPicture getFilePathList].count delegate:self];
        
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
            
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}
#pragma mark - 店家信息图片选择
// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets {
    
    for (UIImage *img in photos) {
        goodsImage = [ImageUtils cropWeChatPhoto:img dispalyWidth:450.0f];
        NSString* filePath = [NSString getUniqueStrByUUID];
        self.imgFilePathTemp = [NSString stringWithFormat:@"%@.png", filePath];
        [self uploadImgFinsh];
    }
}

#pragma mark - 数据验证
- (BOOL)isValid
{
    if ([NSString isBlank:[self.txtShopNo getStrVal]]) {
        [AlertBox show:@"门店编号不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtShopName getStrVal]]) {
        [AlertBox show:@"门店名称不能为空，请输入!"];
        return NO;
    }
    if (self.action == ACTION_CONSTANTS_ADD) {
        if ([NSString isInvalidatedOrgNum:[self.txtShopNo getStrVal]]) {
            [AlertBox show:@"门店编号必须包含字母，请重新输入!"];
            return NO;
        }
    }
    if ([NSString isNotNumAndLetter:[self.txtShopNo getStrVal]]) {
        [AlertBox show:@"门店编号格式不正确，请重新输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsSuperOrg getStrVal]]) {
        [AlertBox show:@"请选择上级机构!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsShopIndustry getStrVal]]) {
        [AlertBox show:@"请选择所属行业!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsShopAdr getStrVal]]) {
        [AlertBox show:@"请选择门店所在地区!"];
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
    if ([NSString isNotBlank:[self.txtMobile getStrVal]] && !([NSString validateMobile:[self.txtMobile getStrVal]] || [NSString validateHomeMobile:[self.txtMobile getStrVal]] || [NSString isValidateFax:[self.txtMobile getStrVal]])) {
        [AlertBox show:@"联系电话格式不正确，请重新输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsStartTime getStrVal]]) {
        [AlertBox show:@"请选择营业开始时间!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsEndTime getStrVal]]) {
        [AlertBox show:@"请选择营业结束时间!"];
        return NO;
    }
    if ([self.rdoSupply getVal]&&self.supplyList.count==0) {
        [AlertBox show:@"请添加指定采购的公司!"];
        return NO;
    }
    
//    if ([self.boxPicture getFilePathList].count < 1) {
//        [LSAlertHelper showAlert:@"请至少选择一张店家图片！"];
//        return NO;
//    }

    return YES;
}

#pragma mark - 数据模型赋值
- (void)transMode
{
    if ([NSString isNotBlank:_shop.fileName]&&[NSString isBlank:[self.imgLogo getImageFilePath]]) {
        _shop.fileOperate = [NSNumber numberWithShort:0];
    }else if([NSString isNotBlank:[self.imgLogo getImageFilePath]]&&![_shop.fileName isEqualToString:[self.imgLogo getImageFilePath]]){
        _shop.fileOperate = [NSNumber numberWithShort:1];
        _shop.fileName = _fileName;
    }else{
        _shop.fileOperate =nil;
    }
    _shop.code = [self.txtShopNo getStrVal];
    _shop.shopName = [self.txtShopName getStrVal];
    if (!_isLogin) {
        _shop.orgId = [self.lsSuperOrg getStrVal];
        _shop.orgName = self.lsSuperOrg.lblVal.text;
    }
    _shop.orgId = [self.lsSuperOrg getStrVal];
    _shop.orgName = self.lsSuperOrg.lblName.text;
    _shop.profession = @([[self.lsShopIndustry getStrVal] integerValue]);
    _shop.address = [self.txtDetailAdr getStrVal];
    _shop.area = [NSString isBlank:[self.lsArea getStrVal]]?nil:[NSNumber numberWithDouble:[[self.lsArea getStrVal] doubleValue]];
    _shop.linkman = [self.txtLinkMan getStrVal];
    _shop.phone1 = [self.txtPhone getStrVal];
    _shop.phone2 = [self.txtMobile getStrVal];
    _shop.weixin = [self.txtWechat getStrVal];
    _shop.startTime = [self.lsStartTime getStrVal];
    _shop.endTime = [self.lsEndTime getStrVal];
    _shop.introduce = [self.txtIntro getStrVal];
    NSMutableArray *arr = [[NSMutableArray array] init];
    if (self.delSupplyList.count>0) {
        for (PurchaseSupplyVo *delVo in self.delSupplyList) {
            delVo.operateType = @"del";
            [arr addObject:delVo];
        }
    }
    [arr addObjectsFromArray:self.supplyList];
    _shop.purchaseSupplyVoList = arr;
    _shop.appointCompany = [self.rdoSupply getVal]?@"1":@"2";
    if (!_isLogin) {
        _shop.flag = [self.rdoIsCopy getStrVal];
        if ([self.rdoIsCopy getVal]) {
            _shop.dataFromShopId = [self.lsChainShop getStrVal];
        }
    }
}

#pragma mark - 更新
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
    //上传图片
    [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];
    
    _shop.fileName = self.imgLogo.currentVal;
    NSString* operateType = _action==ACTION_CONSTANTS_ADD?@"add":@"edit";
    __weak typeof(self) weakSelf = self;
    [_settingService saveShopInfo:_shop operateType:operateType synIsShop:self.synIsShop completionHandler:^(id json) {
        weakSelf.shopEntityId = json[@"shopEntityId"];
        [weakSelf upLoadShopImageInfo];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
#pragma mark - 删除
- (void)btnClick:(id)sender
{
    
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",_shop.shopName] event:100];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //确认删除
        if (actionSheet.tag==100) {
            //获取分账实体Id
            __block NSString *url =  @"h5ShopPay/getByEntityId";
            __block NSMutableDictionary *param = [NSMutableDictionary dictionary];
            if ([NSString isNotBlank:self.shop.shopEntityId]) {
                [param setValue:self.shop.shopEntityId forKey:@"entityId"];
            }
            __weak typeof(self) wself  = self;
            [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
                NSString *shopEntiyId = json[@"shopEntityId"];
                if ([NSString isNotBlank:shopEntiyId]) {
                    //获取当月的电子收款未到账总额
                    [param removeAllObjects];
                    [param setValue:shopEntiyId forKey:@"entity_id"];
                    NSString *dateStr = [DateUtils formateDate5:[NSDate date]];
                    [param setValue:dateStr forKey:@"year_month"];
                    [param setValue:@"-1" forKey:@"pay_type"];
                    url = @"bill/v1/total_by_month";
                    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
                        //获取上月的电子收款未到账总额
                        NSDictionary *dict = [json objectForKey:@"data"];
                        double unAcount = [dict[@"noShareTotalFee"] doubleValue];
                        if (unAcount > 0.0) {
                            //删除门店时，如果被删除的门店近2个月（本月和上月）电子支付未到账金额>0，删除时弹出提示信息“该门店存在电子支付未到账金额**元，如删除门店该笔金额将无法打入指定账户，确认要删除门店吗？
                            [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"该门店存在电子支付未到账金额%.2f元，如删除门店该笔金额将无法打入指定账户，确认要删除门店吗？", unAcount] event:1000];
                        } else {
                            [wself deleteShop];
                        }
                    } errorHandler:^(id json) {
                        [AlertBox show:json];
                    }];
                } else {
                    [self deleteShop];
                }
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            
        }else if (actionSheet.tag == 1000){
            [self deleteShop];
        } else {
            PurchaseSupplyVo *purchaseSupplyVo = (PurchaseSupplyVo *)self.item;
            if (![@"add" isEqualToString:purchaseSupplyVo.operateType]) {
                [self.delSupplyList addObject:self.item];
            }
            [self.supplyList removeObject:self.item];
            [self.gridItem loadData:self.supplyList withIsEdit:YES];
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
            [self changeUINavigate];
        }
    }
}

#pragma mark - 删除门店接口
- (void)deleteShop {
    __weak typeof(self) weakSelf = self;
    NSString *url = @"shop/delete";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:self.shop.shopId forKey:@"shopId"];
    [param setValue:self.shop.entityId forKey:@"shopEntityId"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if (weakSelf.handlerChainInfo) {
            weakSelf.handlerChainInfo(weakSelf.shop,ACTION_CONSTANTS_DEL);
        }
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 获取一个月前的日期
//查询分账需要查这月和上月的
- (NSString *)getLastMonth {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate * lastDate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    //转化为字符串
    NSString * startDate = [dateFormatter stringFromDate:lastDate];
    return startDate;
}

#pragma mark - 店家信息图片上传
- (void)upLoadShopImageInfo {
    //获得原始路径
    NSMutableArray *oldPathList = [NSMutableArray array];
    for (MicroGoodsImageVo *microGoodsImageVo in self.shop.mainImageVoList) {
        [oldPathList addObject:microGoodsImageVo.fileName];
    }
    NSMutableArray *mainImageVoList = [NSMutableArray array];
    //存放图片对象
    NSMutableArray *imageVoList = [NSMutableArray array];
    //存放图片数据
    NSMutableArray *imageDataList = [NSMutableArray array];
    
    if ([self.boxPicture getFilePathList] != nil && [self.boxPicture getFilePathList].count > 0&&[self.boxPicture getFilePathList].count <= 5) {
        int idx = 0;
        for (NSString *filePath in [self.boxPicture getFilePathList]) {
            MicroGoodsImageVo *vo = [[MicroGoodsImageVo alloc] init];
            vo.opType = 0;
            vo.fileName = [NSString stringWithFormat:@"%@/%@", self.shopEntityId, [NSString getImageLastPath:filePath]];
            [mainImageVoList addObject:[MicroGoodsImageVo getDictionaryData:vo]];
            SelectImgItem *selectImgItem = [[self.boxPicture getImageItemList] objectAtIndex:idx];
            NSString *lastFilePath = [NSString getImageLastPath:selectImgItem.path];
            selectImgItem.oldPath = [NSString stringWithFormat:@"%@/%@", self.shopEntityId, lastFilePath];
            NSString *oldPath = selectImgItem.oldPath;
            if (![oldPath isEqualToString:selectImgItem.path]) {
                NSDictionary*dic=[self.boxPicture fileImageMap];
                UIImage*PNG=[dic objectForKey:filePath];
                //添加图片
                if (PNG != nil) {
                    NSData *data = [ImageUtils dataOfImageAfterCompression:PNG];
                    LSImageDataVo *imageDataVo = [LSImageDataVo imageDataVoWithData:data file:vo.fileName];
                    [imageDataList addObject:imageDataVo];
                    LSImageVo *imageVo = [LSImageVo imageVoWithFileName:vo.fileName opType:1 type:@"shop_img"];
                    [imageVoList addObject:imageVo];
                }
            }
            idx ++;
        }
    }
    NSArray *tempList = [NSArray arrayWithArray:imageVoList];
    BOOL isContain = NO;
    for (MicroGoodsImageVo *microGoodsImageVo in self.shop.mainImageVoList) {
        for (LSImageVo *imageVo in tempList) {
            if ([[imageVo obtainFileName] isEqualToString:microGoodsImageVo.fileName]) {
                isContain = YES;
                break;
                
            }
        }
        if (isContain) {
            LSImageVo *imageVo = [LSImageVo imageVoWithFileName:microGoodsImageVo.fileName opType:2 type:@"shop_img"];
            [imageVoList addObject:imageVo];

        }
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.shopEntityId forKey:@"shopEntityId"];
    [param setValue:mainImageVoList forKey:@"mainImageVoList"];
    NSString *url = @"shop/saveShopImg";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if (_isLogin) {
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }else{
            //非门店登录 添加编辑
            [XHAnimalUtil animalEdit:wself.navigationController action:_action];
        }
        if (wself.handlerChainInfo) {
            wself.handlerChainInfo(wself.shop,wself.action);
        }
        [wself.navigationController popViewControllerAnimated:NO];

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];;
    
    //上传图片
    [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];
    
    
}


@end
