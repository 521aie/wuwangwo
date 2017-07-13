//
//  LSShopInfoSetController.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSShopInfoSetController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SettingModuleEvent.h"
#import "LSEditItemText.h"
#import "LSEditItemList.h"
#import "EditItemImage2.h"
#import "LSEditItemMemo.h"
#import "OptionPickerBox.h"
#import "AddressPickerBox.h"
#import "TimePickerBox.h"
#import "MenuList.h"
#import "SymbolNumberInputBox.h"
#import "MemoInputView.h"
#import "ColorHelper.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "DateUtils.h"
#import "JsonHelper.h"
#import "NameItemVO.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ShopVo.h"
#import "LSImageDataVo.h"
#import "LSImageVo.h"
#import "LSEditShopInfoBox.h"
#import "TZImagePickerController.h"
#import "ImageUtils.h"
#import "MicroGoodsImageVo.h"
#import "SelectImgItem.h"

@interface LSShopInfoSetController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,IEditItemImageEvent,IEditItemListEvent,IEditItemMemoEvent,OptionPickerClient,TimePickerClient,AddressPickerClient,SymbolNumberInputClient,MemoInputClient, TZImagePickerControllerDelegate> {
    NSMutableArray *filePathList;
    UIImage *goodsImage;
}
@property (nonatomic,strong) SettingService* settingService;

@property (nonatomic, strong) UIScrollView* scrollView;

/** <#注释#> */
@property (nonatomic, strong) UIView *container;

/**店家编号*/
@property (nonatomic, strong) LSEditItemText* txtShopNo;
/**店家名称*/
@property (nonatomic, strong) LSEditItemText* txtShopName;
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
/**店家logo*/
@property (nonatomic, strong) EditItemImage2* imgLogo;
/**店铺介绍*/
@property (nonatomic, strong) LSEditItemMemo *txtIntro;

/**店家模型*/
@property (nonatomic,strong) ShopVo* shop;
/**地址列表*/
@property (nonatomic,strong) NSMutableArray* addressList;
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
/** 店家图片 */
@property (nonatomic, strong) LSEditShopInfoBox *boxPicture;

@property (nonatomic, assign) BOOL isEditLock;

@property (nonatomic, strong) NSString* imgFilePathTemp;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopEntityId;

@end

@implementation LSShopInfoSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"店家信息" leftPath:Head_ICON_BACK rightPath:nil];
    [self configDatas];
    [self configViews];
    [self configContainerViews];
    [self initMainView];
    [self loadData];
    [self configHelpButton:HELP_SETTING_SHOP_INFO];
    [self registerNotification];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
- (void)configDatas {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;
    self.logoImagePickerController = [[UIImagePickerController alloc] init];
    self.logoImagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    self.logoImagePickerController.allowsEditing = YES;
    self.logoImagePickerController.delegate = self;
    filePathList = [NSMutableArray array];

}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    self.settingService = [ServiceFactory shareInstance].settingService;
    self.shop = [[ShopVo alloc] init];
        self.addressList = [[NSMutableArray alloc] init];
    self.professionList = [[NSMutableArray alloc] init];
    
    
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] init];
    self.container.frame = CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height);
    [self.scrollView addSubview:self.container];
    
}

- (void)configContainerViews {
    //店家编号
    self.txtShopNo = [LSEditItemText editItemText];
    [self.container addSubview:self.txtShopNo];
    
    //店家名称
    self.txtShopName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtShopName];
    
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
    
    //店家logo
    self.imgLogo = [EditItemImage2 editItemImage];
    //店家logo图片
    self.shopImage = [[UIImage alloc] init];
    [self.container addSubview:self.imgLogo];
    
    //店铺介绍
    self.txtIntro = [LSEditItemMemo editItemMemo];
    [self.container addSubview:self.txtIntro];
    
    //提示信息
    [LSViewFactor addClearView:self.container y:0 h:15];
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
}

//是否有修改门店权限
- (void)reload
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
    [self.imgLogo isEditable:!self.isEditLock];
    [self.txtIntro editEnable:!self.isEditLock];
    if (self.isEditLock) {
        [self.boxPicture imageBoxUneditable];
        self.boxPicture.userInteractionEnabled = NO;
    }
}




//返回前一页面|保存编辑信息
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma mark - 初始化主视图
- (void)initMainView
{
    [self.txtShopNo initLabel:@"店家编号" withHit:nil isrequest:NO type:UIKeyboardTypeASCIICapable];
    [self.txtShopNo editEnabled:NO];
    
    [self.txtShopName initLabel:@"店家名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtShopName initMaxNum:50];
    
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
    
    [self.lsStartTime initLabel:@"营业开始时间" withHit:nil delegate:self];
    
    [self.lsEndTime initLabel:@"营业结束时间" withHit:nil delegate:self];
    
    [self.imgLogo initLabel:@"店家LOGO" delegate:self title:@"店家LOGO"];
    
    [self.txtIntro initLabel:@"店铺介绍" isrequest:NO delegate:self];
    
    self.lsShopIndustry.tag = SHOP_INDUSRY;
    self.lsShopAdr.tag = SHOP_ADR;
    self.lsArea.tag = SHOP_AREA;
    self.txtDetailAdr.tag = SHOP_DETAIL_ADR;
    self.lsStartTime.tag = START_TIME;
    self.lsEndTime.tag = END_TIME;
    self.txtIntro.tag = TXT_INTRO;
}

#pragma mark - 注册UI变化通知
- (void)registerNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notification
{
    [self editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 加载数据
- (void)loadData
{
    [self registerNotification];
    __weak typeof(self) weakSelf = self;
    [_settingService selectShopInfo:[[Platform Instance] getkey:SHOP_ID] completionHandler:^(id json) {
        //接收店家模型数据
        weakSelf.shop = [ShopVo convertToShop:[json objectForKey:@"shop"]];
        //地址列表
        weakSelf.addressList = [json objectForKey:@"addressList"];
        //所属行业
        NSArray *profList = [json objectForKey:@"professionList"];
        NameItemVO *item = nil;
        for (NSDictionary *obj in profList) {
            item = [[NameItemVO alloc] initWithVal:obj[@"name"] andId:[obj[@"code"] stringValue]];
            [weakSelf.professionList addObject:item];
        }
        
        //店铺编码
        [weakSelf.txtShopNo initData:_shop.code];
//        //店铺名称
        [weakSelf.txtShopName initData:_shop.shopName];
        
        //所属行业
        if ([ObjectUtil isNotNull:_shop.profession]) {
            for (item in weakSelf.professionList) {
                if ([[item obtainItemId] isEqualToString:_shop.profession.stringValue]) {
                    [weakSelf.lsShopIndustry initData:[item obtainItemName] withVal:[item obtainItemId]];
                }}
        }else{
            [weakSelf.lsShopIndustry initData:@"" withVal:nil];
        }
        
        //拼接省市区
        NSString* addr = [GlobalRender getAddress:_addressList PId:_shop.provinceId CId:_shop.cityId DId:_shop.countyId];
        if ([NSString isNotBlank:addr]) {
            [weakSelf.lsShopAdr initData:addr withVal:addr];
        }
        
        //详细地址
        [weakSelf.txtDetailAdr initData:_shop.address];
       
        //店铺面积
        NSString* area = [_shop.area doubleValue]==0?@"":[NSString stringWithFormat:@"%.2f",[_shop.area doubleValue]];
        [weakSelf.lsArea initData:area withVal:area];
       
        //联系人
        [weakSelf.txtLinkMan initData:_shop.linkman];
        //手机号
        [weakSelf.txtPhone initData:_shop.phone1];
        //联系电话
        [weakSelf.txtMobile initData:_shop.phone2];
        //微信
        [weakSelf.txtWechat initData:_shop.weixin];
        //营业开始时间
        [weakSelf.lsStartTime initData:_shop.startTime withVal:_shop.startTime];
        //营业结束时间
        [weakSelf.lsEndTime initData:_shop.endTime withVal:_shop.endTime];
        //店铺logo
        [weakSelf.imgLogo initView:_shop.fileName path:_shop.fileName];
        //店铺介绍
        [weakSelf.txtIntro initData:_shop.introduce];
        
        if (self.shop.mainImageVoList != nil && self.shop.mainImageVoList.count > 0) {
            [self.boxPicture initImgList:self.shop.mainImageVoList];
        } else {
            [self.boxPicture initImgList:nil];
        }
        [filePathList addObjectsFromArray:[self.boxPicture getFilePathList]];
        [weakSelf reload];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj
{
    NSDate* date = nil;
    
    if (obj.tag==SHOP_INDUSRY) {
        //所属行业
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        [OptionPickerBox initData:_professionList itemId:[obj getStrVal]];
    }else if (obj.tag==SHOP_ADR) {
        
        if (_addressList.count) {
            //选择地区
            [AddressPickerBox initAddress:_addressList pId:_shop.provinceId cId:_shop.cityId dId:_shop.countyId];
            [AddressPickerBox show:obj.lblName.text client:self event:obj.tag];
        }
        
    }else if (obj.tag==START_TIME) {
        //营业开始时间
        date=[DateUtils parseDateTime6:[self.lsStartTime getStrVal]];
        [TimePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
        
    }else if (obj.tag==END_TIME) {
        //营业结束时间
        date=[DateUtils parseDateTime6:[self.lsEndTime getStrVal]];
        [TimePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
        
    }else if (obj.tag==SHOP_AREA) {
        //店铺面积
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:8 digitLimit:2];
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
        //营业开始时间
        [self.lsStartTime changeData:timeStr withVal:timeStr];
    }else if (event==END_TIME) {
        //营业结束时间
        [self.lsEndTime changeData:timeStr withVal:timeStr];
    }
    return YES;
}

//选择地址
- (BOOL)pickAddress:(NSMutableArray *)selectArr event:(NSInteger)eventType
{
    NSString* provinceName = [[selectArr objectAtIndex:0] objectForKey:@"provinceName"];
    _shop.provinceId = [[selectArr objectAtIndex:0] objectForKey:@"provinceId"];
    
    NSString* cityName = [[selectArr objectAtIndex:1] objectForKey:@"cityName"];
    _shop.cityId = [[selectArr objectAtIndex:1] objectForKey:@"cityId"];
    _shop.countyId = @"1";//此值是必传值有可能没有所以随便赋值了
    NSString* districtName = @"";
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
    }
    if (obj == self.txtIntro) {
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
    }
    if (event == TXT_INTRO) {
        [self.txtIntro changeData:content];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 图片处理
//删除图片
- (void)onDelImgClick
{
    [self.imgLogo changeImg:@"" img:nil];
}

#pragma mark - 门店logo选择
- (void)onConfirmImgClick:(NSInteger)btnIndex
{
    if (btnIndex==1) {
        //选择拍照上传
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(__bridge NSString*)kUTTypeImage]) {
            self.logoImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.logoImagePickerController animated:YES completion:nil];
        }
    }else if(btnIndex==0){
        //选择相册上传
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            self.logoImagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.logoImagePickerController animated:YES completion:nil];
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
            _fileName = [NSString stringWithFormat:@"%@/%@.png", _shop.shopId, [NSString getUniqueStrByUUID]];
            [self.imgLogo changeImg:_fileName img:_shopImage];
        }
        
    } else if (picker == self.imagePickerController) {
        
        //添加到集合中
        goodsImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        goodsImage = [ImageUtils scaleImageOfDifferentCondition:goodsImage
                                                      condition:[[Platform Instance] getkey:SHOP_MODE].intValue];
        NSString *filePath = [NSString getUniqueStrByUUID];
        self.imgFilePathTemp = [NSString stringWithFormat:@"%@.png", filePath];
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


#pragma mark - 信息验证
- (BOOL)isValide
{
    if ([NSString isBlank:[self.txtShopName getStrVal]]) {
        [AlertBox show:@"店家名称不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsShopIndustry getStrVal]]) {
        [AlertBox show:@"请选择所属行业!"];
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
        [AlertBox show:@"联系人不能为空，请重新输入!"];
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
    // 同时支持 固话、手机号码以及传真
    if ([NSString isNotBlank:[self.txtMobile getStrVal]] && !([NSString validateMobile:[self.txtMobile getStrVal]] || [NSString validateHomeMobile:[self.txtMobile getStrVal]] || [NSString isValidateFax:[self.txtMobile getStrVal]])) {
        [AlertBox show:@"联系电话格式不正确，请重新输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsStartTime getStrVal]]&&[@"00:00" isEqualToString:[self.lsStartTime getStrVal]]) {
        [AlertBox show:@"请选择营业开始时间!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsEndTime getStrVal]]&&[@"00:00" isEqualToString:[self.lsEndTime getStrVal]]) {
        [AlertBox show:@"请选择营业结束时间!"];
        return NO;
    }
//    if ([self.boxPicture getFilePathList].count < 1) {
//        [LSAlertHelper showAlert:@"请至少选择一张店家图片！"];
//        return NO;
//    }
    return YES;
}

#pragma mark - 数据转换
- (void)transMode
{
    if ([NSString isNotBlank:_shop.fileName]&&[NSString isBlank:[self.imgLogo getImageFilePath]]) {
        //删除logo
        _shop.fileOperate = [NSNumber numberWithShort:0];
    }else if([NSString isNotBlank:[self.imgLogo getImageFilePath]]&&![_shop.fileName isEqualToString:[self.imgLogo getImageFilePath]]){
        //修改logo
        _shop.fileOperate = [NSNumber numberWithShort:1];
        _shop.fileName = _fileName;
    }else{
        //没有操作过logo
        _shop.fileOperate = nil;
    }
    _shop.code = [self.txtShopNo getStrVal];
    _shop.shopName = [self.txtShopName getStrVal];
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
    _shop.flag = @"0";
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


#pragma mark - 更新店家信息
- (void)save
{
    if (![self isValide]) {
        return;
    }
    [self transMode];
//    //存放图片对象
    NSMutableArray *imageVoIconList = [NSMutableArray array];
//    //存放图片数据
    NSMutableArray *imageDataIconList = [NSMutableArray array];
    LSImageVo *imageVo = nil;
    LSImageDataVo *imageDataVo = nil;
    
    if (self.imgLogo.isChange) {
        if ([NSString isNotBlank:self.imgLogo.oldVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.imgLogo.oldVal opType:2 type:@"shop"];
            [imageVoIconList addObject:imageVo];
        }
        if ([NSString isNotBlank:self.imgLogo.currentVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.imgLogo.currentVal opType:1 type:@"shop"];
            [imageVoIconList addObject:imageVo];
            NSData *data = UIImageJPEGRepresentation(self.imgLogo.img.image, 0.1);
            imageDataVo = [LSImageDataVo imageDataVoWithData:data file:self.imgLogo.currentVal];
            [imageDataIconList addObject:imageDataVo];
        }
    }
    [BaseService upLoadImageWithimageVoList:imageVoIconList imageDataVoList:imageDataIconList];
    __weak typeof(self) weakSelf = self;
    [_settingService saveShopInfo:_shop operateType:@"edit" synIsShop:NO completionHandler:^(id json) {
        [weakSelf upLoadShopImageInfo];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


#pragma mark - 店家信息图片上传
- (void)upLoadShopImageInfo {
    self.shopEntityId = self.shop.shopEntityId;
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
        [wself removeNotification];
        [wself popViewController];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];;
    
    //上传图片
    [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];
    

}

@end
