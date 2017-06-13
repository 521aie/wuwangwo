//
//  GoodsStyleEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsStyleEditView.h"
#import "StyleVo.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "EditItemImage.h"
#import "LSEditItemList.h"
#import "LSEditItemRadio.h"
#import "EditItemRadio2.h"
#import "LSEditItemText.h"
#import "LSEditItemTitle.h"
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DateUtils.h"
#import "GoodsModuleEvent.h"
#import "SymbolNumberInputBox.h"
#import "GoodsStyleGoodsEditView.h"
#import "OptionPickerBox.h"
#import "GoodsRender.h"
#import "GoodsAttributeManageListView.h"
#import "GoodsAttributeAddListView.h"
#import "LSEditItemMemo.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "GoodsStyleListView.h"
#import "GoodsCategoryListView.h"
#import "GoodsBrandVo.h"
#import "GoodsStyleInfoView.h"
#import "GoodsStyleGoodsListView.h"
#import "StyleGoodsVo.h"
#import "SelectOrgShopListView.h"
#import "WechatGoodsManagementStyleDetailViewViewController.h"
#import "ImageUtils.h"
#import "LSGoodsUnitVo.h"
#import "UnitInfoViewController.h"
#import "Wechat_MicroStyleVo.h"
#import "NameItemVO.h"
#import "LSImagePickerController.h"
#import "LSImageVo.h"
#import "LSImageDataVo.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "OptionPickerClient.h"
#import "FooterListEvent.h"
#import "IEditItemImageEvent.h"
#import "ISampleListEvent.h"
#import "SymbolNumberInputBox.h"
#import "IEditItemMemoEvent.h"

@interface GoodsStyleEditView () <UnitInfoViewDelegate ,LSImagePickerDelegate, OptionPickerClient,IEditItemRadioEvent, IEditItemListEvent, FooterListEvent, IEditItemImageEvent, ISampleListEvent, SymbolNumberInputClient, IEditItemMemoEvent, UIActionSheetDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIView *container;
@property (nonatomic, strong)  FooterListView *footView;
@property (nonatomic, strong) GoodsService* goodsService;
@property (nonatomic) BOOL flg;
@property (nonatomic, strong) NSMutableArray* attributeValList;
@property (nonatomic, strong) NSMutableArray* categoryList;

@property (nonatomic) BOOL priceChangeFlg;
@property (nonatomic, strong) NSMutableArray *brandList;
@property (nonatomic, strong) NSString* lastVer;

/**
 1: 右上角保存按键保存 2: 点击添加、编辑商品信息保存 3: 点击微店价、图片、介绍等设置保存 4: 点击微店价格关联保存
 */
@property (nonatomic, strong) NSString *saveWay;
@property (nonatomic) BOOL isSave;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) LSImagePickerController *imagePicker;/*<图片选择器>*/
@end

@implementation GoodsStyleEditView


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDatas];
    [self configViews];
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self loaddatas];
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self loadCategoryList];
        if (self.addStyleVo != nil) {
            [self textFieldDidEndEditing:self.txtStyleNo.txtVal];
        }
    }
}

- (void)configDatas {
    self.goodsService = [ServiceFactory shareInstance].goodsService;
    if ([[Platform Instance] getShopMode] == 3) {
        self.synShopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    }
    self.goodsList = [NSMutableArray array];
    self.attributeValList = [NSMutableArray array];
    self.categoryList = [NSMutableArray array];
    self.brandList = [NSMutableArray array];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    //container
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
    
    //商品上下架
    self.rdoStatus = [EditItemRadio2 editItemRadio];
    [self.container addSubview:self.rdoStatus];
    //基本信息
    self.TitBaseInfo = [LSEditItemTitle editItemTitle];
    [self.TitBaseInfo configTitle:@"基本信息"];
    [self.container addSubview:self.TitBaseInfo];
    //款式No
    self.txtStyleNo = [LSEditItemText editItemText];
    [self.container addSubview:self.txtStyleNo];
    //款式名称
    self.txtStyleName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtStyleName];
    //商品分类
    self.lsCategory = [LSEditItemList editItemList];
    [self.container addSubview:self.lsCategory];
    //进货价
    self.lsPurPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsPurPrice];
    //吊牌价
    self.lsHangTagPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsHangTagPrice];
    //零售价
    self.lsRetailPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsRetailPrice];
    //会员价
    self.lsMemberPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsMemberPrice];
    //批发价
    self.lsWhoPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsWhoPrice];
    //款式信息同步
    self.lsStyleInfoSyn = [LSEditItemList editItemList];
    [self.container addSubview:self.lsStyleInfoSyn];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    //商品信息
    self.TitGoodsInfo = [LSEditItemTitle editItemTitle];
    [self.TitGoodsInfo configTitle:@"商品信息"];
    [self.container addSubview:self.TitGoodsInfo];
    self.lsGoodsInfo = [LSEditItemList editItemList];
    [self.container addSubview:self.lsGoodsInfo];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    //扩展信息
    self.TitExtendInfo = [LSEditItemTitle editItemTitle];
    [self.TitExtendInfo configTitle:@"扩展信息"];
    [self.container addSubview:self.TitExtendInfo];
    //单位
    self.lstUnit = [LSEditItemList editItemList];
    [self.container addSubview:self.lstUnit];
    //商品品牌
    self.lsBrand = [LSEditItemList editItemList];
    [self.container addSubview:self.lsBrand];
    //适用性别
    self.lsSex = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSex];
    //主型
    self.lsMainModel = [LSEditItemList editItemList];
    [self.container addSubview:self.lsMainModel];
    //辅型
    self.lsAuxiliaryModel = [LSEditItemList editItemList];
    [self.container addSubview:self.lsAuxiliaryModel];
    //系列
    self.lsSeries = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSeries];
    //年度
    self.lsYear = [LSEditItemList editItemList];
    [self.container addSubview:self.lsYear];
    //阶段
    self.txtPhase = [LSEditItemText editItemText];
    [self.container addSubview:self.txtPhase];
    //季节
    self.lsSeason = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSeason];
    //标签
    self.txtTag = [LSEditItemText editItemText];
    [self.container addSubview:self.txtTag];
    //面料
    self.lsFabric = [LSEditItemList editItemList];
    [self.container addSubview:self.lsFabric];
    //里料
    self.lsMaterial = [LSEditItemList editItemList];
    [self.container addSubview:self.lsMaterial];
    //商品产地
    self.txtOrigin = [LSEditItemText editItemText];
    [self.container addSubview:self.txtOrigin];
    //款式图片
    self.imgStyle = [EditItemImage editItemImage];
    [self.container addSubview:self.imgStyle];
    self.goodsImage = [[UIImage alloc] init];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    //销售设置
    self.TitSaleSetting = [LSEditItemTitle editItemTitle];
    [self.TitSaleSetting configTitle:@"销售设置"];
    [self.container addSubview:self.TitSaleSetting];
    //销售提成比例
    self.lsSaleRoyaltyRatio = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSaleRoyaltyRatio];
    //参与积分
    self.rdoIsJoinPoint = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoIsJoinPoint];
    //参与任何优惠活动
    self.rdoIsJoinActivity = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoIsJoinActivity];
    //微店设置
    self.TitMicroSetting = [LSEditItemTitle editItemTitle];
    [self.TitMicroSetting configTitle:@"微店设置"];
    [self.container addSubview:self.TitMicroSetting];
    //微店信息介绍
    self.lsMicroInfo = [LSEditItemList editItemList];
    [self.container addSubview:self.lsMicroInfo];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [btn addTarget:self action:@selector(btnDelClick) forControlEvents:UIControlEventTouchUpInside];
    self.btnDel = btn.superview;
}

#pragma mark - 加载商品分类列表只有添加商品的时候调用
- (void)loadCategoryList {
    __weak GoodsStyleEditView* weakSelf = self;
    [_goodsService selectLastCategoryInfo:@"0" completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSString *categoryIdKey = [NSString stringWithFormat:@"%@%@", [[Platform Instance] getkey:ENTITY_ID], kCategoryId];
        //商品分类Id
        NSString *categoryId = [[Platform Instance] getkey:categoryIdKey];
        NSMutableArray* list = [json objectForKey:@"categoryList"];
        self.categoryList = [[NSMutableArray alloc] init];
        [self.lsCategory initData:@"请选择" withVal:@""];
        if (list != nil && list.count > 0) {
            for (NSDictionary* dic in list) {
                CategoryVo *categoryVo = [CategoryVo convertToCategoryVo:dic];
                [self.categoryList addObject:categoryVo];
                //添加的商品分类默认是上一次保存商品的分类默认请选择
                if ([categoryId isEqualToString:categoryVo.categoryId]) {
                    [self.lsCategory initData:categoryVo.name withVal:categoryVo.categoryId];
                }
            }
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

- (void)loaddatas
{
    [self.scrollView setContentOffset:CGPointMake(0, 0)animated:NO];
    _isSave = NO;
    _flg = NO;
    _priceChangeFlg = NO;
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    if (_action == ACTION_CONSTANTS_ADD) {
        [self configTitle:@"添加款式" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
        [self clearDo];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }else{
        if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_DELETE]) {
            [self.btnDel setHidden:YES];
        }
        [self configTitle:@"款式详情" leftPath:Head_ICON_BACK rightPath:nil];
        [self selectStyleDetail];
    }
}

- (void)loaddatasFromSelect:(int) viewTag
{
    if (viewTag == GOODS_STYLE_EDIT_BRAND) {
        [self onItemListClick:self.lsBrand];
    }else if (viewTag == GOODS_STYLE_EDIT_SERIES){
        [self onItemListClick:self.lsSeries];
    }else if (viewTag == GOODS_STYLE_EDIT_SEASON){
        [self onItemListClick:self.lsSeason];
    }else if (viewTag == GOODS_STYLE_EDIT_FABRIC){
        [self onItemListClick:self.lsFabric];
    }else if (viewTag == GOODS_STYLE_EDIT_MATERIAL){
        [self onItemListClick:self.lsMaterial];
    }else if (viewTag == GOODS_STYLE_EDIT_CATEGORY){
        [self onItemListClick:self.lsCategory];
    } else if (viewTag == GOODS_STYLE_EDIT_MAINMODEL) {
        [self onItemListClick:self.lsMainModel];
    } else if (viewTag == GOODS_STYLE_EDIT_AUXILIARYMODEL) {
        [self onItemListClick:self.lsAuxiliaryModel];
    }  else if (viewTag == GOODS_STYLE_EDIT_UNIT) {
        [self onItemListClick:self.lstUnit];
    }
}

- (void)loaddatasFromAttributeAddView
{
    [self selectStyleDetail];
}

- (void)selectStyleDetail
{
    __weak GoodsStyleEditView* weakSelf = self;
    [_goodsService selectStyleDetail:_shopId styleId:_styleId distributionId:@"" sourceId:@"1" completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    _styleVo = [StyleVo convertToStyleVo:[json objectForKey:@"styleVo"]];
    [self fillModel];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)clearDo
{
    [self.rdoStatus initData:@"1"];
    self.rdoStatus.lblName.text = [self.rdoStatus getVal]?@"款式已上架":@"款式已下架";
    NSString *hit = [self.rdoStatus getVal] ? @"已上架的款式可以在各个平台显示及销售" : @"已下架的款式可以在收银设备显示，但是无法销售，在其他平台（微店等）上不显示";
    [self.rdoStatus initHit:hit];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    [self.txtStyleName initData:nil];
    
    [self.txtStyleNo initData:nil];
    [self.txtStyleNo editEnabled:YES];
    
    [self.lsPurPrice initData:nil withVal:@""];
    
    
    [self.lsHangTagPrice initData:nil withVal:@""];
    
    [self.lsPurPrice editEnable:YES];
    [self.lsHangTagPrice editEnable:YES];
    
    [self.lsRetailPrice initData:nil withVal:@""];
    
    [self.lsMemberPrice initData:nil withVal:@""];
    
    [self.lsWhoPrice initData:nil withVal:@""];
    
    if ([[Platform Instance] getShopMode]== 3 && [self.synShopId isEqualToString:[[Platform Instance] getkey:ORG_ID]]) {
        [self.lsStyleInfoSyn initData:@"同步所有" withVal:self.synShopId];
    } else {
        [self.lsStyleInfoSyn initData:self.synShopName withVal:self.synShopId];
    }
    
    [self.lsCategory initData:@"请选择" withVal:@""];
    
    [self.lsBrand initData:@"请选择" withVal:@""];
    
    [self.lstUnit initData:@"请选择" withVal:@""];
    
    [self.lsSex initData:@"请选择" withVal:@""];
    
    [self.lsMainModel initData:@"请选择" withVal:@""];
    
    [self.lsAuxiliaryModel initData:@"请选择" withVal:@""];
    
    [self.lsSeries initData:@"请选择" withVal:@""];
    
    [self.txtOrigin initData:nil];
    
    [self.lsYear initData:@"" withVal:@""];
    
    [self.lsSeason initData:@"请选择" withVal:@""];
    
    [self.txtPhase initData:nil];
    
    [self.lsFabric initData:@"请选择" withVal:@""];
    
    [self.lsMaterial initData:@"请选择" withVal:@""];
    
    [self.txtTag initData:nil];
    
    [self.imgStyle initView:nil path:nil];
    
    [self.lsSaleRoyaltyRatio initData:@"0.00" withVal:@"0.00"];
    
    [self.rdoIsJoinPoint initData:@"1"];
    
    [self.rdoIsJoinActivity initData:@"1"];
    
    if (_addStyleVo != nil) {
        [self.txtStyleName changeData:_addStyleVo.styleName];
        
        [self.txtStyleNo changeData:_addStyleVo.styleCode];
        
        [self.lsPurPrice initData:[NSString stringWithFormat:@"%.2f", [_addStyleVo.purchasePrice doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_addStyleVo.purchasePrice doubleValue]]];
        
        [self.lsHangTagPrice changeData:[NSString stringWithFormat:@"%.2f", [_addStyleVo.hangTagPrice doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_addStyleVo.hangTagPrice doubleValue]]];
        
        [self.lsRetailPrice changeData:[NSString stringWithFormat:@"%.2f", [_addStyleVo.retailPrice doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_addStyleVo.retailPrice doubleValue]]];
        
        [self.lsMemberPrice changeData:[NSString stringWithFormat:@"%.2f", [_addStyleVo.memberPrice doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_addStyleVo.memberPrice doubleValue]]];
        
        [self.lsWhoPrice changeData:[NSString stringWithFormat:@"%.2f", [_addStyleVo.wholesalePrice doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_addStyleVo.wholesalePrice doubleValue]]];
        
        if ([NSString isBlank:_addStyleVo.categoryId]) {
            [self.lsCategory initData:@"请选择" withVal:@""];
        }else{
            [self.lsCategory changeData:_addStyleVo.categoryName withVal:_addStyleVo.categoryId];
        }
        
        if ([NSString isBlank:_addStyleVo.brandId]) {
            [self.lsBrand initData:@"请选择" withVal:@""];
        }else{
            [self.lsBrand changeData:_addStyleVo.brandName withVal:_addStyleVo.brandId];
        }
        if ([NSString isBlank:_addStyleVo.unitId]) {
            [self.lstUnit initData:@"请选择" withVal:@""];
        }else{
            [self.lstUnit changeData:_addStyleVo.brandName withVal:_addStyleVo.brandId];
        }
        
        if (_addStyleVo.applySex == 0) {
            [self.lsSex initData:@"请选择" withVal:@""];
        }else{
            [self.lsSex changeData:[GoodsRender obtainSex:[NSString stringWithFormat:@"%d", _addStyleVo.applySex]] withVal:[NSString stringWithFormat:@"%d", _addStyleVo.applySex]];
        }
        
        if ([NSString isBlank:_addStyleVo.prototypeValId]) {
            [self.lsMainModel initData:@"请选择" withVal:@""];
        }else{
            [self.lsMainModel changeData:_addStyleVo.prototype withVal:_addStyleVo.prototypeValId];
        }
        
        if ([NSString isBlank:_addStyleVo.auxiliaryValId]) {
            [self.lsAuxiliaryModel initData:@"请选择" withVal:@""];
        }else{
            [self.lsAuxiliaryModel changeData:_addStyleVo.auxiliary withVal:_addStyleVo.auxiliaryValId];
        }
        
        if ([NSString isBlank:_addStyleVo.serialValId]) {
            [self.lsSeries initData:@"请选择" withVal:@""];
        }else{
            [self.lsSeries changeData:_addStyleVo.serial withVal:_addStyleVo.serialValId];
        }
        
        [self.txtOrigin changeData:_addStyleVo.origin];
        
        [self.lsYear changeData:_addStyleVo.year withVal:_addStyleVo.year];
        
        if ([NSString isBlank:_addStyleVo.seasonValId]) {
            [self.lsSeason initData:@"请选择" withVal:@""];
        }else{
            [self.lsSeason changeData:_addStyleVo.season withVal:_addStyleVo.seasonValId];
        }
        
        [self.txtPhase changeData:_addStyleVo.stage];
        
        if ([NSString isBlank:_addStyleVo.fabricValId]) {
            [self.lsFabric initData:@"请选择" withVal:@""];
        }else{
            [self.lsFabric changeData:_addStyleVo.fabric withVal:_addStyleVo.fabricValId];
        }
        
        if ([NSString isBlank:_addStyleVo.liningValId]) {
            [self.lsMaterial initData:@"请选择" withVal:@""];
        }else{
            [self.lsMaterial changeData:_addStyleVo.lining withVal:_addStyleVo.liningValId];
        }
        
        [self.txtTag changeData:_addStyleVo.tag];
        
        [self.imgStyle initView:_addStyleVo.filePath path:_addStyleVo.filePath];
        
        [self.lsSaleRoyaltyRatio changeData:[NSString stringWithFormat:@"%.2f", _addStyleVo.percentage] withVal:[NSString stringWithFormat:@"%.2f", _addStyleVo.percentage]];
        
        if (_addStyleVo.hasDegree == nil) {
            [self.rdoIsJoinPoint initData:@"1"];
        } else {
            [self.rdoIsJoinPoint changeData:[_addStyleVo.hasDegree stringValue]];
        }
        
        if (_addStyleVo.isSales == nil) {
            [self.rdoIsJoinActivity initData:@"1"];
        } else {
            [self.rdoIsJoinActivity changeData:[_addStyleVo.isSales stringValue]];
        }
    }
}

- (void)fillModel
{    if (_styleVo.upDownStatus == 1) {
    [self.rdoStatus initData:@"1"];
    self.rdoStatus.lblName.text = @"款式已上架";
    [self.rdoStatus initHit:@"已上架的款式可以在各个平台显示及销售"];
}else{
    [self.rdoStatus initData:@"2"];
    self.rdoStatus.lblName.text = @"款式已下架";
    [self.rdoStatus initHit:@"已下架的款式可以在收银设备显示，但是无法销售，在其他平台（微店等）上不显示"];
}
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    [self.txtStyleName initData:_styleVo.styleName];
    
    [self.txtStyleNo initData:_styleVo.styleCode];
    [self.txtStyleNo editEnabled:NO];
    
    [self.lsPurPrice initData:[NSString stringWithFormat:@"%.2f", [_styleVo.purchasePrice doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_styleVo.purchasePrice doubleValue]]];
    
    [self.lsHangTagPrice initData:[NSString stringWithFormat:@"%.2f", [_styleVo.hangTagPrice doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_styleVo.hangTagPrice doubleValue]]];
    if (([[Platform Instance] getShopMode] == 3 && [[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]) || [[Platform Instance] getShopMode] == 1) {
        [self.lsPurPrice editEnable:YES];
        [self.lsHangTagPrice editEnable:YES];
    } else {
        [self.lsPurPrice editEnable:NO];
        [self.lsHangTagPrice editEnable:NO];
    }
    
    [self.lsRetailPrice initData:[NSString stringWithFormat:@"%.2f", [_styleVo.retailPrice doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_styleVo.retailPrice doubleValue]] ];
    
    [self.lsMemberPrice initData:[NSString stringWithFormat:@"%.2f", [_styleVo.memberPrice doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_styleVo.memberPrice doubleValue]]];
    
    [self.lsWhoPrice initData:[NSString stringWithFormat:@"%.2f", [_styleVo.wholesalePrice doubleValue]] withVal:[NSString stringWithFormat:@"%.2f", [_styleVo.wholesalePrice doubleValue]]];
    if ([[Platform Instance] getShopMode]== 3 && [self.synShopId isEqualToString:[[Platform Instance] getkey:ORG_ID]]) {
        [self.lsStyleInfoSyn initData:@"同步所有" withVal:self.synShopId];
    } else {
        [self.lsStyleInfoSyn initData:self.synShopName withVal:self.synShopId];
    }
    
    if ([NSString isBlank:_styleVo.categoryName]) {
        [self.lsCategory initData:@"请选择" withVal:@""];
    }else{
        [self.lsCategory initData:_styleVo.categoryName withVal:_styleVo.categoryId];
    }
    
    if ([NSString isBlank:_styleVo.brandId]) {
        [self.lsBrand initData:@"请选择" withVal:@""];
    }else{
        [self.lsBrand initData:_styleVo.brandName withVal:_styleVo.brandId];
    }
    
    if ([NSString isBlank:_styleVo.unitId]) {
        [self.lstUnit initData:@"请选择" withVal:@""];
    }else{
        [self.lstUnit initData:_styleVo.unitName withVal:_styleVo.unitId];
    }
    
    if (_styleVo.applySex == 0) {
        [self.lsSex initData:@"请选择" withVal:@""];
    }else{
        [self.lsSex initData:[GoodsRender obtainSex:[NSString stringWithFormat:@"%d", _styleVo.applySex]] withVal:[NSString stringWithFormat:@"%d", _styleVo.applySex]];
    }
    
    if ([NSString isBlank:_styleVo.prototypeValId]) {
        [self.lsMainModel initData:@"请选择" withVal:@""];
    }else{
        [self.lsMainModel initData:_styleVo.prototype withVal:_styleVo.prototypeValId];
    }
    
    if ([NSString isBlank:_styleVo.auxiliaryValId]) {
        [self.lsAuxiliaryModel initData:@"请选择" withVal:@""];
    }else{
        [self.lsAuxiliaryModel initData:_styleVo.auxiliary withVal:_styleVo.auxiliaryValId];
    }
    
    if ([NSString isBlank:_styleVo.serialValId]) {
        [self.lsSeries initData:@"请选择" withVal:@""];
    }else{
        [self.lsSeries initData:_styleVo.serial withVal:_styleVo.serialValId];
    }
    
    [self.txtOrigin initData:_styleVo.origin];
    
    [self.lsYear initData:_styleVo.year withVal:_styleVo.year];
    
    if ([NSString isBlank:_styleVo.seasonValId]) {
        [self.lsSeason initData:@"请选择" withVal:@""];
    }else{
        [self.lsSeason initData:_styleVo.season withVal:_styleVo.seasonValId];
    }
    
    [self.txtPhase initData:_styleVo.stage];
    
    if ([NSString isBlank:_styleVo.fabricValId]) {
        [self.lsFabric initData:@"请选择" withVal:@""];
    }else{
        [self.lsFabric initData:_styleVo.fabric withVal:_styleVo.fabricValId];
    }
    
    if ([NSString isBlank:_styleVo.liningValId]) {
        [self.lsMaterial initData:@"请选择" withVal:@""];
    }else{
        [self.lsMaterial initData:_styleVo.lining withVal:_styleVo.liningValId];
    }
    
    [self.txtTag initData:_styleVo.tag];
    
    [self.imgStyle initView:_styleVo.filePath path:_styleVo.filePath];
    
    [self.lsSaleRoyaltyRatio initData:[NSString stringWithFormat:@"%.2f", _styleVo.percentage] withVal:[NSString stringWithFormat:@"%.2f", _styleVo.percentage]];
    
    [self.rdoIsJoinPoint initData:[_styleVo.hasDegree stringValue]];
    
    [self.rdoIsJoinActivity initData:[_styleVo.isSales stringValue]];
    
    if (([[Platform Instance] getShopMode] == 3 && ![[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]) || [[Platform Instance] getShopMode] == 2) {
        [self.txtStyleName editEnabled:NO];
        [self.lsPurPrice editEnable:NO];
        [self.lsHangTagPrice editEnable:NO];
        [self.lsCategory editEnable:NO];
        [self.lsBrand editEnable:NO];
        [self.lstUnit editEnable:NO];
        [self.lsSex editEnable:NO];
        [self.lsSeries editEnable:NO];
        [self.txtOrigin editEnabled:NO];
        [self.lsYear editEnable:NO];
        [self.lsSeason editEnable:NO];
        [self.txtPhase editEnabled:NO];
        [self.lsMaterial editEnable:NO];
        [self.lsFabric editEnable:NO];
        [self.txtTag editEnabled:NO];
        [self.imgStyle editEnabled:NO];
        [self.lsSaleRoyaltyRatio editEnable:NO];
        [self.rdoIsJoinPoint editable:NO];
        [self.rdoIsJoinActivity editable:NO];
        //        [self.lsMicroInfo editEnable:NO];
        [self.lsMainModel editEnable:NO];
        [self.lsAuxiliaryModel editEnable:NO];
        
    }
    
    if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_EDIT]) {
        [self isEdit:NO];
    }
}

- (void)isEdit:(BOOL)flg
{
    if (flg) {
        [self.rdoStatus.clickBtn setEnabled:YES];
        [self.txtStyleName editEnabled:YES];
        [self.lsPurPrice editEnable:YES];
        [self.lsHangTagPrice editEnable:YES];
        [self.lsRetailPrice editEnable:YES];
        [self.lsMemberPrice editEnable:YES];
        [self.lsWhoPrice editEnable:YES];
        [self.lsStyleInfoSyn editEnable:YES];
        [self.lsCategory editEnable:YES];
        [self.lsBrand editEnable:YES];
        [self.lstUnit editEnable:YES];
        [self.lsSex editEnable:YES];
        [self.lsMainModel editEnable:YES];
        [self.lsAuxiliaryModel editEnable:YES];
        [self.lsSeries editEnable:YES];
        [self.txtOrigin editEnabled:YES];
        [self.lsYear editEnable:YES];
        [self.lsSeason editEnable:YES];
        [self.txtPhase editEnabled:YES];
        [self.lsMaterial editEnable:YES];
        [self.lsFabric editEnable:YES];
        [self.txtTag editEnabled:YES];
        [self.imgStyle editEnabled:YES];
        [self.lsSaleRoyaltyRatio editEnable:YES];
        [self.rdoIsJoinPoint editable:YES];
        [self.rdoIsJoinActivity editable:YES];
        [self.lsMicroInfo editEnable:YES];
        [self.lsMainModel editEnable:YES];
        [self.lsAuxiliaryModel editEnable:YES];
        
    } else {
        [self.rdoStatus.clickBtn setEnabled:NO];
        [self.txtStyleName editEnabled:NO];
        [self.lsPurPrice editEnable:NO];
        [self.lsHangTagPrice editEnable:NO];
        [self.lsRetailPrice editEnable:NO];
        [self.lsMemberPrice editEnable:NO];
        [self.lsWhoPrice editEnable:NO];
        [self.lsStyleInfoSyn editEnable:NO];
        [self.lsCategory editEnable:NO];
        [self.lsBrand editEnable:NO];
        [self.lstUnit editEnable:NO];
        [self.lsSex editEnable:NO];
        [self.lsMainModel editEnable:NO];
        [self.lsAuxiliaryModel editEnable:NO];
        [self.lsSeries editEnable:NO];
        [self.txtOrigin editEnabled:NO];
        [self.lsYear editEnable:NO];
        [self.lsSeason editEnable:NO];
        [self.txtPhase editEnabled:NO];
        [self.lsMaterial editEnable:NO];
        [self.lsFabric editEnable:NO];
        [self.txtTag editEnabled:NO];
        [self.imgStyle editEnabled:NO];
        [self.lsSaleRoyaltyRatio editEnable:NO];
        [self.rdoIsJoinPoint editable:NO];
        [self.rdoIsJoinActivity editable:NO];
        [self.lsMicroInfo editEnable:NO];
        [self.lsMainModel editEnable:NO];
        [self.lsAuxiliaryModel editEnable:NO];
    }
}

- (void)initMainView
{
    [self.rdoStatus initLabel:@"" withHit:nil delegate:self];
    [self.rdoStatus.line setHidden:YES];
    self.TitBaseInfo.lblName.text = @"基本信息";
    
    [self.txtStyleName initLabel:@"款式名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtStyleName initMaxNum:50];
    
    [self.txtStyleNo initLabel:@"款号" withHit:nil isrequest:YES type:UIKeyboardTypeNumbersAndPunctuation];
    [self.txtStyleNo initMaxNum:12];
    [self.txtStyleNo.txtVal setDelegate:self];
    
    [self.lsPurPrice initLabel:@"参考进货价(元)" withHit:nil isrequest:NO delegate:self];
//    if ([[Platform Instance] lockAct:ACTION_REF_PURCHASE_PRICE]) {//没有权限时参考进货价不显示
//        [self.lsPurPrice visibal:NO];
//    }
    
    [self.lsPurPrice visibal:NO];
    
    
    [self.lsHangTagPrice initLabel:@"吊牌价(元)" withHit:nil isrequest:YES delegate:self];
    
    [self.lsRetailPrice initLabel:@"零售价(元)" withHit:nil isrequest:YES delegate:self];
    
    [self.lsMemberPrice initLabel:@"会员价(元)" withHit:nil isrequest:NO delegate:self];
    
    [self.lsWhoPrice initLabel:@"批发价(元)" withHit:nil isrequest:NO delegate:self];
    
    [self.lsStyleInfoSyn initLabel:@"款式信息同步" withHit:nil delegate:self];
    [self.lsStyleInfoSyn.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    if ([[Platform Instance] getShopMode] != 3) {
        [self.lsStyleInfoSyn visibal:NO];
    }else{
        [self.lsStyleInfoSyn visibal:YES];
    }
    
    self.TitExtendInfo.lblName.text = @"扩展信息";
    
    [self.lsCategory initLabel:@"小品类" withHit:nil delegate:self];
    [self.lstUnit initLabel:@"单位" withHit:nil delegate:self];
    [self.lsBrand initLabel:@"品牌" withHit:nil delegate:self];
    
    [self.lsSex initLabel:@"性别" withHit:nil delegate:self];
    
    [self.lsMainModel initLabel:@"主型" withHit:nil delegate:self];
    
    [self.lsAuxiliaryModel initLabel:@"辅型" withHit:nil delegate:self];
    
    [self.lsSeries initLabel:@"系列" withHit:nil delegate:self];
    
    [self.txtOrigin initLabel:@"产地" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtOrigin initMaxNum:50];
    
    [self.lsYear initLabel:@"年份" withHit:nil delegate:self];
    
    [self.lsSeason initLabel:@"季节" withHit:nil delegate:self];
    
    [self.txtPhase initLabel:@"阶段" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtPhase initMaxNum:50];
    
    [self.lsFabric initLabel:@"面料" withHit:nil delegate:self];
    
    [self.lsMaterial initLabel:@"里料"  withHit:nil delegate:self];
    
    [self.txtTag initLabel:@"标签" withHit:@"多个标签用空格隔开" isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtTag initMaxNum:50];
    
    [self.imgStyle initLabel:@"款式图片" withHit:nil delegate:self];
    self.TitGoodsInfo.lblName.text = @"商品信息";
    [self.lsGoodsInfo initLabel:@"添加、编辑商品信息" withHit:@"管理款式关联的颜色、尺码" delegate:self];
    self.lsGoodsInfo.lblVal.placeholder = @"";
    [self.lsGoodsInfo.imgMore setImage:[UIImage imageNamed:@"ico_next"]];
    self.TitSaleSetting.lblName.text = @"销售设置";
    [self.lsSaleRoyaltyRatio initLabel:@"销售提成比例(%)" withHit:nil isrequest:YES delegate:self];
    [self.rdoIsJoinPoint initLabel:@"参与积分" withHit:nil];
    [self.rdoIsJoinActivity initLabel:@"参与任何优惠活动" withHit:nil];
    self.TitMicroSetting.lblName.text = @"微店设置";
    
    [self.lsMicroInfo initLabel:@"微店价、图片、介绍等设置" withHit:nil delegate:self];
    self.lsMicroInfo.lblVal.placeholder = @"";
    [self.lsMicroInfo.imgMore setImage:[UIImage imageNamed:@"ico_next"]];
    
    if ([[Platform Instance] lockAct:ACTION_WEISHOP_GOODS] || ([[Platform Instance] getShopMode] != 3 && [[Platform Instance] getMicroShopStatus] != 2)) {
        [self.TitMicroSetting visibal:NO];
        [self.lsMicroInfo visibal:NO];
    }
    
    self.rdoStatus.tag = GOODS_STYLE_EDIT_UPDOWNSTATUS;
    self.lsPurPrice.tag = GOODS_STYLE_EDIT_PURPRICE;
    self.lsHangTagPrice.tag = GOODS_STYLE_EDIT_HANGTAGPRICE;
    self.lsRetailPrice.tag = GOODS_STYLE_EDIT_RETAILPRICE;
    self.lsMemberPrice.tag = GOODS_STYLE_EDIT_MEMBERPRICE;
    self.lsWhoPrice.tag = GOODS_STYLE_EDIT_WHOPRICE;
    self.lsStyleInfoSyn.tag = GOODS_STYLE_EDIT_STYLEINFOSYN;
    self.lsCategory.tag = GOODS_STYLE_EDIT_CATEGORY;
    self.lstUnit.tag = GOODS_STYLE_EDIT_UNIT;
    self.lsBrand.tag = GOODS_STYLE_EDIT_BRAND;
    self.lsSex.tag = GOODS_STYLE_EDIT_SEX;
    self.lsSeries.tag = GOODS_STYLE_EDIT_SERIES;
    self.lsYear.tag = GOODS_STYLE_EDIT_YEAR;
    self.lsSeason.tag = GOODS_STYLE_EDIT_SEASON;
    self.lsFabric.tag = GOODS_STYLE_EDIT_FABRIC;
    self.lsMaterial.tag = GOODS_STYLE_EDIT_MATERIAL;
    self.lsSaleRoyaltyRatio.tag = GOODS_STYLE_EDIT_SALEROYALTYRATIO;
    self.lsMicroInfo.tag = GOODS_STYLE_EDIT_MICROINFO;
    self.lsGoodsInfo.tag = GOODS_STYLE_EDIT_GOODSINFO;
    self.lsMainModel.tag = GOODS_STYLE_EDIT_MAINMODEL;
    self.lsAuxiliaryModel.tag = GOODS_STYLE_EDIT_AUXILIARYMODEL;
    self.txtStyleNo.txtVal.tag = 10000;
    
}

#pragma mark 款号check
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > 11) {
        [AlertBox show:@"字数限制在12字以内!"];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *keyword = textField.text;
    [self.txtStyleNo changeData:keyword];
    if ([NSString isNotBlank:keyword] && self.txtStyleNo.baseChangeStatus) {
        _flg = YES;
        __weak GoodsStyleEditView* weakSelf = self;
        NSString* operateType = @"";
        if (_action == ACTION_CONSTANTS_ADD) {
            operateType = @"add";
        }else{
            operateType = @"edit";
        }
        [_goodsService checkStyleCode:operateType styleId:_action == ACTION_CONSTANTS_ADD? @"":self.styleVo.styleId styleCode:keyword completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSInteger result = [[json objectForKey:@"checkResult"] integerValue];
            if (result == 1) {
                [AlertBox show:@"款号已存在，请重新输入!"];
                if(![(UITextField *)[self.view viewWithTag:10000] isFirstResponder]){
                    
                    [(UITextField *)[self.view viewWithTag:10000] becomeFirstResponder];
                    
                }
            }else{
                _flg = NO;
                [(UITextField *)[self.view viewWithTag:10000]  resignFirstResponder];
                _addStyleVo = [StyleVo convertToStyleVo:[json objectForKey:@"styleVo"]];
                if (_addStyleVo != nil) {
                    [weakSelf clearDo];
                    [UIHelper refreshUI:self.container scrollview:self.scrollView];
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else{
        [(UITextField *)[self.view viewWithTag:10000]  resignFirstResponder];
    }
    
    return YES;
}

// 隐藏键盘触发的方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length>12) {
        textField.text = [textField.text substringToIndex:12];
    }
    NSString *keyword = textField.text;
    [self.txtStyleNo changeData:keyword];
    if (textField.text.length > 12) {
        [AlertBox show:@"字数限制在12字以内!"];
        return ;
    }
    if ([NSString isNotBlank:keyword] && self.txtStyleNo.baseChangeStatus) {
        _flg = YES;
        __weak GoodsStyleEditView* weakSelf = self;
        NSString* operateType = @"";
        if (_action == ACTION_CONSTANTS_ADD) {
            operateType = @"add";
        }else{
            operateType = @"edit";
        }
        [_goodsService checkStyleCode:operateType styleId:_action == ACTION_CONSTANTS_ADD? @"":self.styleVo.styleId styleCode:keyword completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSInteger result = [[json objectForKey:@"checkResult"] integerValue];
            if (result == 1) {
                [AlertBox show:@"款号已存在，请重新输入!"];
                if(![(UITextField *)[self.view viewWithTag:10000] isFirstResponder]){
                    
                    [(UITextField *)[self.view viewWithTag:10000] becomeFirstResponder];
                    
                }
            }else{
                [self.txtStyleNo changeData:keyword];
                _flg = NO;
                _addStyleVo = [StyleVo convertToStyleVo:[json objectForKey:@"styleVo"]];
                if (_addStyleVo != nil) {
                    [weakSelf clearDo];
                    [UIHelper refreshUI:self.container scrollview:self.scrollView];
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

-(IBAction)clickBack:(id)sender
{
    [self onNavigateEvent:LSNavigationBarButtonDirectLeft];
}

-(IBAction)clickSave:(id)sender
{
    [self onNavigateEvent:LSNavigationBarButtonDirectRight];
}

#pragma mark 下拉框事件
- (void)onItemListClick:(EditItemList *)obj
{
    if(!_flg){
        if (obj.tag == GOODS_STYLE_EDIT_STYLEINFOSYN) {
            //跳转页面至选择门店
            SelectOrgShopListView* selectOrgShopListView = [[SelectOrgShopListView alloc] init];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            [self.navigationController pushViewController:selectOrgShopListView animated:NO];
            __weak GoodsStyleEditView* weakSelf = self;
            [selectOrgShopListView loadData:[weakSelf.lsStyleInfoSyn getStrVal] withModuleType:1 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popToViewController:weakSelf animated:NO];
                if (item) {
                    ShopVo* vo1 = [[ShopVo alloc] init];
                    vo1.shopName = [item obtainItemName];
                    if ([[item obtainItemId] isEqualToString:@"0"]) {
                        vo1.shopId = @"";
                        weakSelf.synShopEntityId = @"0";
                    } else {
                        vo1.shopId = [item obtainItemId];
                        weakSelf.synShopEntityId = [item obtainShopEntityId];
                    }
                    
                    [weakSelf.lsStyleInfoSyn changeData:vo1.shopName withVal:vo1.shopId];
                    [UIHelper refreshUI:weakSelf.container scrollview:weakSelf.scrollView];
                }
            }];
        }else if (obj.tag == GOODS_STYLE_EDIT_PURPRICE || obj.tag == GOODS_STYLE_EDIT_HANGTAGPRICE || obj.tag == GOODS_STYLE_EDIT_RETAILPRICE || obj.tag == GOODS_STYLE_EDIT_MEMBERPRICE || obj.tag == GOODS_STYLE_EDIT_WHOPRICE){
            [SymbolNumberInputBox initData:obj.lblVal.text];
            [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
            [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        } else if (obj.tag == GOODS_STYLE_EDIT_SALEROYALTYRATIO ){
            [SymbolNumberInputBox initData:obj.lblVal.text];
            [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
            [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
        } else if (obj.tag == GOODS_STYLE_EDIT_BRAND){
            __weak GoodsStyleEditView* weakSelf = self;
            [_goodsService selectBrandList:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                NSMutableArray* list = [json objectForKey:@"goodsBrandList"];
                _brandList = [[NSMutableArray alloc] init];
                if (list != nil && list.count > 0) {
                    for (NSDictionary* dic in list) {
                        [_brandList addObject:[GoodsBrandVo convertToGoodsBrandVo:dic]];
                    }
                }
                [OptionPickerBox initData:[GoodsRender listBrandList:_brandList]itemId:[obj getStrVal]];
                [OptionPickerBox showManager:obj.lblName.text managerName:@"品牌库管理" client:self event:obj.tag];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else if (obj.tag == GOODS_STYLE_EDIT_SEX){
            [OptionPickerBox initData:[GoodsRender listSex:NO]itemId:[obj getStrVal]];
            [OptionPickerBox showManager:obj.lblName.text managerName:@"清空性别" client:self event:obj.tag];
            [OptionPickerBox changeImgManager:@"setting_data_clear.png"];
        }else if (obj.tag == GOODS_STYLE_EDIT_YEAR){
            [SymbolNumberInputBox initData:obj.lblVal.text];
            [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
            [SymbolNumberInputBox limitInputNumber:4 digitLimit:0];
        }else if (obj.tag == GOODS_STYLE_EDIT_CATEGORY){
            __weak GoodsStyleEditView* weakSelf = self;
            [_goodsService selectLastCategoryInfo:@"0" completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                NSMutableArray* list = [json objectForKey:@"categoryList"];
                _categoryList = [[NSMutableArray alloc] init];
                if (list != nil && list.count > 0) {
                    for (NSDictionary* dic in list) {
                        [_categoryList addObject:[CategoryVo convertToCategoryVo:dic]];
                    }
                }
                [OptionPickerBox initData:[GoodsRender listCategoryList:_categoryList isShow:NO]itemId:[obj getStrVal]];
                if (![[Platform Instance] lockAct:ACTION_CATEGORY_MANAGE]) {
                    [OptionPickerBox showManager:obj.lblName.text managerName:@"品类管理" client:self event:obj.tag];
                    [OptionPickerBox changeImgManager:@"ico_manage.png"];
                } else {
                    [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
                }
                
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else if (obj.tag == GOODS_STYLE_EDIT_SEASON){
            __weak GoodsStyleEditView* weakSelf = self;
            [_goodsService selectBaseAttributeValList:@"2" completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                NSMutableArray* list = [json objectForKey:@"attributeValList"];
                _attributeValList = [[NSMutableArray alloc] init];
                if (list != nil && list.count > 0) {
                    for (NSDictionary* dic in list) {
                        [_attributeValList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                    }
                }
                [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeValList isShow:NO]itemId:[obj getStrVal]];
                [OptionPickerBox showManager:obj.lblName.text managerName:@"季节库管理" client:self event:obj.tag];
                [OptionPickerBox changeImgManager:@"ico_manage.png"];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            
        }else if (obj.tag == GOODS_STYLE_EDIT_SERIES){
            __weak GoodsStyleEditView* weakSelf = self;
            [_goodsService selectBaseAttributeValList:@"1" completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                NSMutableArray* list = [json objectForKey:@"attributeValList"];
                _attributeValList = [[NSMutableArray alloc] init];
                if (list != nil && list.count > 0) {
                    for (NSDictionary* dic in list) {
                        [_attributeValList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                    }
                }
                [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeValList isShow:NO]itemId:[obj getStrVal]];
                [OptionPickerBox showManager:obj.lblName.text managerName:@"系列库管理" client:self event:obj.tag];
                [OptionPickerBox changeImgManager:@"ico_manage.png"];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            
        }else if (obj.tag == GOODS_STYLE_EDIT_FABRIC){
            __weak GoodsStyleEditView* weakSelf = self;
            [_goodsService selectBaseAttributeValList:@"3" completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                NSMutableArray* list = [json objectForKey:@"attributeValList"];
                _attributeValList = [[NSMutableArray alloc] init];
                if (list != nil && list.count > 0) {
                    for (NSDictionary* dic in list) {
                        [_attributeValList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                    }
                }
                [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeValList isShow:NO]itemId:[obj getStrVal]];
                [OptionPickerBox showManager:obj.lblName.text managerName:@"材质库管理" client:self event:obj.tag];
                [OptionPickerBox changeImgManager:@"ico_manage.png"];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            
        }else if (obj.tag == GOODS_STYLE_EDIT_MATERIAL){
            __weak GoodsStyleEditView* weakSelf = self;
            [_goodsService selectBaseAttributeValList:@"4" completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                NSMutableArray* list = [json objectForKey:@"attributeValList"];
                _attributeValList = [[NSMutableArray alloc] init];
                if (list != nil && list.count > 0) {
                    for (NSDictionary* dic in list) {
                        [_attributeValList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                    }
                }
                [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeValList isShow:NO]itemId:[obj getStrVal]];
                [OptionPickerBox showManager:obj.lblName.text managerName:@"材质库管理" client:self event:obj.tag];
                [OptionPickerBox changeImgManager:@"ico_manage.png"];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else if (obj.tag == GOODS_STYLE_EDIT_GOODSINFO)
        {
            _saveWay = @"2";
            if (_isSave) {
                [self save];
            }else{
                __weak GoodsStyleEditView* weakSelf = self;
                [_goodsService selectStyleGoodsList:_shopId styleId:_styleId completionHandler:^(id json) {
                    if (!(weakSelf)) {
                        return ;
                    }
                    NSMutableArray* list = [StyleGoodsVo converToArr:[json objectForKey:@"styleGoodsVoList"]];
                    if (list == nil || list.count == 0) {
                        if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD]) {
                            [AlertBox show:@"该款式下暂无商品!"];
                            return ;
                        }
                        GoodsAttributeAddListView* vc = [[GoodsAttributeAddListView alloc] initWithShopId:_shopId styleId:_styleVo.styleId lastVer:[NSString stringWithFormat:@"%ld", _styleVo.lastVer] synShopId:_synShopId action:ACTION_CONSTANTS_ADD fromViewTag:GOODS_STYLE_EDIT_VIEW];
                        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                        [self.navigationController pushViewController:vc animated:NO];
                        __weak GoodsStyleEditView* weakSelf = self;
                        [vc loadDatas:^(BOOL flg, NSString* lastVer) {
                            if (flg) {
                                _lastVer = lastVer;
                                GoodsStyleGoodsListView* listView = [[GoodsStyleGoodsListView alloc] init];
                                [self performSelector:@selector(loadData:) withObject:listView afterDelay:1];
                                [weakSelf.navigationController pushViewController:listView animated:NO];
                                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                                
                            } else {
                                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                                [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                            }
                        }];
                    }else{
                        GoodsStyleGoodsListView* listView = [[GoodsStyleGoodsListView alloc] init];
                        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                        [weakSelf.navigationController pushViewController:listView animated:NO];
                        [listView loaddatas:_shopId styleId:_styleVo.styleId lastVer:[NSString stringWithFormat:@"%ld",  _styleVo.lastVer] synShopId:_synShopId styleGoodsList:list fromViewTag:GOODS_STYLE_EDIT_VIEW callBack:^(BOOL flg) {
                            [weakSelf loaddatasFromAttributeAddView];
                            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                        }];
                    }
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
            }
            
        } else if (obj.tag == GOODS_STYLE_EDIT_MICROINFO) {
            _saveWay = @"3";
            if (_isSave) {
                [self save];
                
            }else{
                WechatGoodsManagementStyleDetailViewViewController* vc = [[WechatGoodsManagementStyleDetailViewViewController alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
                vc.shopId = _shopId;
                vc.synShopEntityId = self.synShopEntityId;
                vc.styleId = _styleVo.styleId;
                vc.detai=WECHAT_STYLE_MicroInfo;
                vc.action = ACTION_CONSTANTS_EDIT;
                vc.categoryId = _styleVo.categoryId;
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [self.navigationController pushViewController:vc animated:NO];
                [self editTitle:NO act:ACTION_CONSTANTS_EDIT];
                
            }
        } else if (obj.tag == GOODS_STYLE_EDIT_MAINMODEL) {
            __weak GoodsStyleEditView* weakSelf = self;
            [_goodsService selectBaseAttributeValList:@"5" completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                NSMutableArray* list = [json objectForKey:@"attributeValList"];
                _attributeValList = [[NSMutableArray alloc] init];
                if (list != nil && list.count > 0) {
                    for (NSDictionary* dic in list) {
                        [_attributeValList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                    }
                }
                [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeValList isShow:NO]itemId:[obj getStrVal]];
                [OptionPickerBox showManager:obj.lblName.text managerName:@"主型库管理" client:self event:obj.tag];
                [OptionPickerBox changeImgManager:@"ico_manage.png"];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        } else if (obj.tag == GOODS_STYLE_EDIT_AUXILIARYMODEL) {
            __weak GoodsStyleEditView* weakSelf = self;
            [_goodsService selectBaseAttributeValList:@"6" completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                NSMutableArray* list = [json objectForKey:@"attributeValList"];
                _attributeValList = [[NSMutableArray alloc] init];
                if (list != nil && list.count > 0) {
                    for (NSDictionary* dic in list) {
                        [_attributeValList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                    }
                }
                [OptionPickerBox initData:[GoodsRender listAttributeVal:_attributeValList isShow:NO]itemId:[obj getStrVal]];
                [OptionPickerBox showManager:obj.lblName.text managerName:@"辅型库管理" client:self event:obj.tag];
                [OptionPickerBox changeImgManager:@"ico_manage.png"];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        } else if (obj.tag == GOODS_STYLE_EDIT_UNIT){
            NSString *url = @"goodsUnit/list";
            [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
                id goodsUnitVoList = json[@"goodsUnitVoList"];
                NSMutableArray *utitList = [NSMutableArray array];
                if ([ObjectUtil isNotNull:goodsUnitVoList]) {
                    for (NSDictionary *map in goodsUnitVoList) {
                        LSGoodsUnitVo *goodsUnitVo = [LSGoodsUnitVo goodsUnitVoWithMap:map];
                        NameItemVO *item = [[NameItemVO alloc] initWithVal:goodsUnitVo.unitName andId:goodsUnitVo.goodsUnitId];
                        [utitList addObject:item];
                    }
                }
                [OptionPickerBox initData:utitList itemId:[obj getStrVal]];
                [OptionPickerBox showManager:obj.lblName.text managerName:@"单位库管理" client:self event:obj.tag];
                [OptionPickerBox changeImgManager:@"ico_manage.png"];
                
                
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
        
        
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }
}

- (void)loadData:(GoodsStyleGoodsListView *)listView{
    [listView loaddatas:_shopId styleId:_styleVo.styleId lastVer:_lastVer synShopId:_synShopId styleGoodsList:nil fromViewTag:GOODS_STYLE_EDIT_VIEW callBack:^(BOOL flg) {
        [self loaddatasFromAttributeAddView];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popToViewController:self animated:NO];
    }];
}

- (void)showAddEvent:(NSString *)event
{
    GoodsAttributeAddListView* vc = [[GoodsAttributeAddListView alloc] initWithShopId:_shopId styleId:_styleVo.styleId lastVer:[NSString stringWithFormat:@"%ld", _styleVo.lastVer] synShopId:_synShopId action:ACTION_CONSTANTS_ADD fromViewTag:GOODS_STYLE_EDIT_VIEW];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
    __weak GoodsStyleEditView* weakSelf = self;
    [vc loadDatas:^(BOOL flg, NSString* lastVer) {
        if (flg) {
            GoodsStyleGoodsListView* listView = [[GoodsStyleGoodsListView alloc] init];
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            [weakSelf.navigationController pushViewController:listView animated:NO];
            [listView loaddatas:_shopId styleId:_styleVo.styleId lastVer:[NSString stringWithFormat:@"%ld",  _styleVo.lastVer] synShopId:_synShopId styleGoodsList:nil fromViewTag:GOODS_STYLE_EDIT_VIEW callBack:^(BOOL flg) {
                [self loaddatasFromAttributeAddView];
            }];
        }
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == GOODS_STYLE_EDIT_BRAND) {
        [self.lsBrand changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == GOODS_STYLE_EDIT_SEX){
        [self.lsSex changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == GOODS_STYLE_EDIT_SEASON){
        [self.lsSeason changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == GOODS_STYLE_EDIT_CATEGORY){
        [self.lsCategory changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == GOODS_STYLE_EDIT_FABRIC){
        [self.lsFabric changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == GOODS_STYLE_EDIT_MATERIAL){
        [self.lsMaterial changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == GOODS_STYLE_EDIT_SERIES){
        [self.lsSeries changeData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == GOODS_STYLE_EDIT_MAINMODEL) {
        [self.lsMainModel changeData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == GOODS_STYLE_EDIT_AUXILIARYMODEL) {
        [self.lsAuxiliaryModel changeData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == GOODS_STYLE_EDIT_UNIT) {
        [self.lstUnit changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    
    return YES;
}

- (void)managerOption:(NSInteger)eventType
{
    if (eventType == GOODS_STYLE_EDIT_BRAND || eventType == GOODS_STYLE_EDIT_SEASON || eventType == GOODS_STYLE_EDIT_FABRIC || eventType == GOODS_STYLE_EDIT_MATERIAL || eventType == GOODS_STYLE_EDIT_SERIES || eventType == GOODS_STYLE_EDIT_MAINMODEL || eventType == GOODS_STYLE_EDIT_AUXILIARYMODEL) {
        GoodsAttributeManageListView* vc = [[GoodsAttributeManageListView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
        __weak  GoodsStyleEditView* weakSelf = self;
        [vc loadDatas:(int)eventType callBack:^(int fromViewTag) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf loaddatasFromSelect:fromViewTag];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    } else if (eventType == GOODS_STYLE_EDIT_CATEGORY) {
        GoodsCategoryListView* vc = [[GoodsCategoryListView alloc] initWithTag:GOODS_STYLE_EDIT_CATEGORY];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
        __weak  GoodsStyleEditView* weakSelf = self;
        [vc loadDatasFromStyleEditView:^(int fromViewTag) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf loaddatasFromSelect:fromViewTag];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    } else if (eventType == GOODS_STYLE_EDIT_SEX){
        if (_action == ACTION_CONSTANTS_ADD) {
            [self.lsSex initData:@"请选择" withVal:@""];
        } else if (_action == ACTION_CONSTANTS_EDIT && _styleVo.applySex == 0) {
            [self.lsSex initData:@"请选择" withVal:@""];
        } else {
            [self.lsSex changeData:@"请选择" withVal:@""];
        }
    }else if (eventType == GOODS_STYLE_EDIT_UNIT){
        UnitInfoViewController *vc = [[UnitInfoViewController alloc] init];
        vc.delegate = self;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
    }
}
- (void)unitInfoViewClickDeleted:(LSGoodsUnitVo *)goodsUnit {
    if ([[self.lstUnit getStrVal] isEqualToString:goodsUnit.goodsUnitId]) {
        [self.lstUnit changeData:@"请选择" withVal:nil];
    }
}

- (void)unitInfoViewClickClosedBtn {
    [self onItemListClick:self.lstUnit];
}
#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if ([NSString isBlank:val]) {
        val = nil;
    } else {
        val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
    }
    
    if (eventType==GOODS_STYLE_EDIT_PURPRICE) {
        
        [self.lsPurPrice changeData:val withVal:val];
    }else if (eventType==GOODS_STYLE_EDIT_HANGTAGPRICE) {
        
        [self.lsHangTagPrice changeData:val withVal:val];
    }else if (eventType==GOODS_STYLE_EDIT_RETAILPRICE) {
        
        [self.lsRetailPrice changeData:val withVal:val];
        //会员价不输入时默认零售价 进货价不输入时默认零售价
        if ([NSString isBlank:[self.lsMemberPrice getStrVal]]) {
            [self.lsMemberPrice changeData:val withVal:val];
        }
        if ([NSString isBlank:[self.lsWhoPrice getStrVal]]) {
            [self.lsWhoPrice changeData:val withVal:val];
        }
        
    }else if (eventType==GOODS_STYLE_EDIT_MEMBERPRICE) {
        
        [self.lsMemberPrice changeData:val withVal:val];
    }else if (eventType==GOODS_STYLE_EDIT_WHOPRICE) {
        
        [self.lsWhoPrice changeData:val withVal:val];
    }else if (eventType==GOODS_STYLE_EDIT_SALEROYALTYRATIO) {
        if (val.doubleValue>100.00) {
            [AlertBox show:@"销售提成比例(%)不能大于100.00，请重新输入!"];
            return ;
        }else{
            if ([NSString isBlank:val]) {
                val = nil;
            } else {
                val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
            }
        }
        
        [self.lsSaleRoyaltyRatio changeData:val withVal:val];
    }else if (eventType == GOODS_STYLE_EDIT_YEAR){
        if ([NSString isBlank:val]) {
            val = nil;
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
        }
        
        [self.lsYear changeData:val withVal:val];
    }
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_GoodsStyleEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsStyleEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    if ((self.lsPurPrice.baseChangeStatus || self.lsHangTagPrice.baseChangeStatus || self.lsRetailPrice.baseChangeStatus || self.
         lsMemberPrice.baseChangeStatus || self.lsWhoPrice.baseChangeStatus) && _action == ACTION_CONSTANTS_EDIT) {
        
        _priceChangeFlg = YES;
    }else {
        
        _priceChangeFlg = NO;
    }
    
    if (self.action == ACTION_CONSTANTS_ADD) {
        
        [self editTitle:NO act:self.action];
        _isSave = YES;
    }else {
        
        [self editTitle:[UIHelper currChange:self.container] act:self.action];
        _isSave = [UIHelper currChange:self.container];
    }
}

- (void)onItemRadioClick:(LSEditItemRadio*)obj
{
    if (obj.tag == GOODS_STYLE_EDIT_UPDOWNSTATUS) {
        self.rdoStatus.lblName.text = [self.rdoStatus getVal]?@"款式已上架":@"款式已下架";
        NSString *hit = [self.rdoStatus getVal] ? @"已上架的款式可以在各个平台显示及销售" : @"已下架的款式可以在收银设备显示，但是无法销售，在其他平台（微店等）上不显示";
        [self.rdoStatus initHit:hit];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        
        [self.txtStyleNo initData:@""];
        if (_action == ACTION_CONSTANTS_ADD) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        }else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }else {
        _saveWay = @"1";
        [self save];
    }
}

- (void)save
{
    if (![self isValid]){
        return;
    }
    //存放图片对象
    NSMutableArray *imageVoList = [NSMutableArray array];
    //存放图片数据
    NSMutableArray *imageDataList = [NSMutableArray array];
    LSImageVo *imageVo = nil;
    LSImageDataVo *imageDataVo = nil;
    
    if (self.imgStyle.isChange) {
        if ([NSString isNotBlank:self.imgStyle.oldVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.imgStyle.oldVal opType:2 type:@"style"];
            [imageVoList addObject:imageVo];
        }
        if ([NSString isNotBlank:self.imgStyle.currentVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.imgStyle.currentVal opType:1 type:@"style"];
            [imageVoList addObject:imageVo];
            NSData *data = UIImageJPEGRepresentation(self.imgStyle.img.image, 0.1);
            imageDataVo = [LSImageDataVo imageDataVoWithData:data file:self.imgStyle.currentVal];
            [imageDataList addObject:imageDataVo];
        }
    }
    //上传图片
    [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];
    
    
    __weak GoodsStyleEditView* weakSelf = self;
    if (_action == ACTION_CONSTANTS_ADD) {
        
        _styleVo = [[StyleVo alloc] init];
        _styleVo.upDownStatus = [self.rdoStatus getStrVal].intValue;
        _styleVo.styleName = [self.txtStyleName getStrVal];
        _styleVo.styleCode = [self.txtStyleNo getStrVal];
        //不在上传参考进货价
//        if (![NSString isBlank:[self.lsPurPrice getStrVal]]) {
//            _styleVo.purchasePrice = [NSNumber numberWithDouble:[self.lsPurPrice getStrVal].doubleValue];
//        }
        
        _styleVo.hangTagPrice = [NSNumber numberWithDouble:[self.lsHangTagPrice getStrVal].doubleValue];
        //零售价
        _styleVo.retailPrice = [NSNumber numberWithDouble:[self.lsRetailPrice getStrVal].doubleValue];
        //会员价不输入时默认零售价
        if ([NSString isNotBlank:[self.lsMemberPrice getStrVal]]) {
            _styleVo.memberPrice = @([self.lsMemberPrice getStrVal].doubleValue);
        } else {
            _styleVo.memberPrice = _styleVo.retailPrice;
        }
        //批发价不输入时默认零售价
        if ([NSString isNotBlank:[self.lsWhoPrice getStrVal]]) {
            _styleVo.wholesalePrice = @([self.lsWhoPrice getStrVal].doubleValue);
        } else {
            _styleVo.wholesalePrice = _styleVo.retailPrice;
        }
        
        _styleVo.categoryId = [self.lsCategory getStrVal];
        if (![[self.lsCategory getDataLabel] isEqualToString:@"请选择"]) {
            _styleVo.categoryName = [self.lsCategory getDataLabel];
        }
        _styleVo.brandId = [self.lsBrand getStrVal];
        if (![[self.lsBrand getDataLabel] isEqualToString:@"请选择"]) {
            _styleVo.brandName = [self.lsBrand getDataLabel];
        }
        _styleVo.unitId = [self.lstUnit getStrVal];
        if (![[self.lstUnit getDataLabel] isEqualToString:@"请选择"]) {
            _styleVo.unitName = [self.lstUnit getDataLabel];
        }
        if (![NSString isBlank:[self.lsSex getStrVal]]) {
            _styleVo.applySex = [self.lsSex getStrVal].intValue;
        } else {
            _styleVo.applySex = 0;
        }
        
        if (![NSString isBlank:[self.lsMainModel getStrVal]]) {
            _styleVo.prototypeValId = [self.lsMainModel getStrVal];
        }
        
        if (![NSString isBlank:[self.lsAuxiliaryModel getStrVal]]) {
            _styleVo.auxiliaryValId = [self.lsAuxiliaryModel getStrVal];
        }
        
        _styleVo.serialValId = [self.lsSeries getStrVal];
        _styleVo.origin = [self.txtOrigin getStrVal];
        if (![NSString isBlank:[self.lsYear getStrVal]]) {
            _styleVo.year = [self.lsYear getStrVal];
        } else {
            _styleVo.year = @"";
        }
        
        _styleVo.seasonValId = [self.lsSeason getStrVal];
        _styleVo.stage = [self.txtPhase getStrVal];
        _styleVo.fabricValId = [self.lsFabric getStrVal];
        _styleVo.liningValId = [self.lsMaterial getStrVal];
        _styleVo.tag = [self.txtTag getStrVal];
        
        if ([[Platform Instance] getShopMode] == 3) {
            if ([NSString isBlank:[self.lsStyleInfoSyn getStrVal]]) {
                self.styleVo.synShopId = @"";
            }else {
                self.styleVo.synShopId = [self.lsStyleInfoSyn getStrVal];
            }
        }else {
            self.styleVo.synShopId = [[Platform Instance] getkey:SHOP_ID];
        }
        
        if ([NSString isNotBlank:_styleVo.fileName]&&[NSString isBlank:[self.imgStyle getImageFilePath]]) {
            
            _styleVo.fileDeleteFlg = 1;
            
        }else if([NSString isNotBlank:[self.imgStyle getImageFilePath]]&&![_styleVo.filePath isEqualToString:[self.imgStyle getImageFilePath]]){
            
            _styleVo.fileName = self.imgFilePathTemp;
        }
        _styleVo.fileName = self.imgStyle.currentVal;
        _styleVo.percentage = [self.lsSaleRoyaltyRatio getStrVal].doubleValue;
        _styleVo.hasDegree = [NSNumber numberWithInt:[self.rdoIsJoinPoint getStrVal].intValue];
        _styleVo.isSales = [NSNumber numberWithInt:[self.rdoIsJoinActivity getStrVal].intValue];
        if ([NSString isNotBlank:self.token]) {
            self.token = [[Platform Instance] getToken];
        }
        [_goodsService saveStyleDetail:[StyleVo getDictionaryData:_styleVo] shopId:self.synShopId synPriceFlg:@"0" token:self.token completionHandler:^(id json) {
            [self saveCategoryNameAndCategoryId];
            if (!(weakSelf)) {
                return ;
            }
            
            if ([_saveWay isEqualToString:@"1"])
            {
                [self.txtStyleNo initData:@""];
                if (_viewTag == GOODS_STYLE_LIST_VIEW) {
                    
                    for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[GoodsStyleListView class]]) {
                            GoodsStyleListView *listView = (GoodsStyleListView *)vc;
                            [listView loadDatasFromEditView:nil action:ACTION_CONSTANTS_ADD];
                        }
                    }
                    [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                }else if (_viewTag == GOODS_STYLE_INFO_VIEW){
                    
                    for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[GoodsStyleInfoView class]]) {
                            GoodsStyleInfoView *listView = (GoodsStyleInfoView *)vc;
                            [listView loadDatasFromEdit];
                        }
                    }
                    [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                }
            }
            else if ([_saveWay isEqualToString:@"2"])
            {
                _styleId = [json objectForKey:@"styleId"];
                _lastVer = [json objectForKey:@"lastVer"];
                GoodsAttributeAddListView* vc = [[GoodsAttributeAddListView alloc] initWithShopId:_shopId styleId:_styleId lastVer:_lastVer synShopId:_synShopId action:ACTION_CONSTANTS_ADD fromViewTag:GOODS_STYLE_EDIT_VIEW];
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [weakSelf.navigationController pushViewController:vc animated:NO];
                [vc loadDatas:^(BOOL flg, NSString *lastVer) {
                    if (flg) {
                        GoodsStyleGoodsListView* listView = [[GoodsStyleGoodsListView alloc] init];
                        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                        [weakSelf.navigationController pushViewController:listView animated:NO];
                        [listView loaddatas:_shopId styleId:_styleId lastVer:lastVer synShopId:_synShopId styleGoodsList:nil fromViewTag:GOODS_STYLE_EDIT_VIEW callBack:^(BOOL flg) {
                            _isSave = NO;
                            _action = ACTION_CONSTANTS_EDIT;
                            [weakSelf loaddatasFromAttributeAddView];
                            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                        }];
                    } else {
                        _isSave = NO;
                        _action = ACTION_CONSTANTS_EDIT;
                        [weakSelf loaddatasFromAttributeAddView];
                        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                    }
                }];
            }
            else if ([_saveWay isEqualToString:@"3"])
            {
                WechatGoodsManagementStyleDetailViewViewController* vc = [[WechatGoodsManagementStyleDetailViewViewController alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
                [vc loadDatasFromStyleEditView:^(BOOL flg) {
                    weakSelf.isSave = NO;
                    weakSelf.action = ACTION_CONSTANTS_EDIT;
                    [weakSelf loaddatasFromAttributeAddView];
                }];
                vc.shopId = _shopId;
                vc.synShopEntityId = weakSelf.synShopEntityId;
                _styleId = [json objectForKey:@"styleId"];
                _styleVo.styleId = [json objectForKey:@"styleId"];
                _styleVo.lastVer = [[json objectForKey:@"lastVer"] integerValue];
                vc.styleId = [json objectForKey:@"styleId"];
                vc.categoryId = _styleVo.categoryId;
                vc.detai=WECHAT_STYLE_MicroInfo;
                vc.action = ACTION_CONSTANTS_EDIT;
                _isSave = NO;
                [self editTitle:NO act:ACTION_CONSTANTS_EDIT];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [self.navigationController pushViewController:vc animated:NO];
            }
            
        }errorHandler:^(id json) {
            weakSelf.token = nil;
            [AlertBox show:json];
        }];
        
    }
    else
    {
        if (_priceChangeFlg) {
            UIAlertView *alertView;
            if (alertView != nil) {
                [alertView dismissWithClickedButtonIndex:0 animated:NO];
                alertView = nil;
            }
            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"款式价格发生变化，是否将修改后的价格同步到款式下的商品中?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
            [alertView show];
        }else{
            [self saveOfEdit];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _priceChangeFlg = YES;
    } else if (buttonIndex == 0) {
        _priceChangeFlg = NO;
    }
    [self saveOfEdit];
}

- (void)saveOfEdit
{
    _styleVo.upDownStatus = [self.rdoStatus getStrVal].intValue;
    if([self.rdoStatus getStrVal].intValue==0){
        _styleVo.upDownStatus=2;
    }
    _styleVo.styleName = [self.txtStyleName getStrVal];
    _styleVo.styleCode = [self.txtStyleNo getStrVal];
    //不再上传参考进货价
//    if (![NSString isBlank:[self.lsPurPrice getStrVal]]) {
//        _styleVo.purchasePrice = [NSNumber numberWithDouble:[self.lsPurPrice getStrVal].doubleValue];
//    }else {
//        _styleVo.purchasePrice = (NSNumber *)[NSNull null];
//    }
    _styleVo.hangTagPrice = [NSNumber numberWithDouble:[self.lsHangTagPrice getStrVal].doubleValue];
    
    _styleVo.retailPrice = [NSNumber numberWithDouble:[self.lsRetailPrice getStrVal].doubleValue];
    
    //会员价不输入时默认零售价
    if ([NSString isNotBlank:[self.lsMemberPrice getStrVal]]) {
        _styleVo.memberPrice = @([self.lsMemberPrice getStrVal].doubleValue);
    } else {
        _styleVo.memberPrice = _styleVo.retailPrice;
    }
    //批发价不输入时默认零售价
    if ([NSString isNotBlank:[self.lsWhoPrice getStrVal]]) {
        _styleVo.wholesalePrice = @([self.lsWhoPrice getStrVal].doubleValue);
    } else {
        _styleVo.wholesalePrice = _styleVo.retailPrice;
    }
    
    _styleVo.categoryId = [self.lsCategory getStrVal];
    if (![[self.lsCategory getDataLabel] isEqualToString:@"请选择"]) {
        _styleVo.categoryName = [self.lsCategory getDataLabel];
    }
    _styleVo.brandId = [self.lsBrand getStrVal];
    if (![[self.lsBrand getDataLabel] isEqualToString:@"请选择"]) {
        _styleVo.brandName = [self.lsBrand getDataLabel];
    }
    _styleVo.unitId = [self.lstUnit getStrVal];
    if (![[self.lstUnit getDataLabel] isEqualToString:@"请选择"]) {
        _styleVo.unitName = [self.lstUnit getDataLabel];
    }
    if (![NSString isBlank:[self.lsSex getStrVal]]) {
        _styleVo.applySex = [self.lsSex getStrVal].intValue;
    } else {
        _styleVo.applySex = 0;
    }
    
    if (![NSString isBlank:[self.lsMainModel getStrVal]]) {
        _styleVo.prototypeValId = [self.lsMainModel getStrVal];
    }
    
    if (![NSString isBlank:[self.lsAuxiliaryModel getStrVal]]) {
        _styleVo.auxiliaryValId = [self.lsAuxiliaryModel getStrVal];
    }
    
    _styleVo.serial = self.lsSeries.lblVal.text;
    _styleVo.serialValId = [self.lsSeries getStrVal];
    _styleVo.origin = [self.txtOrigin getStrVal];
    if (![NSString isBlank:[self.lsYear getStrVal]]) {
        _styleVo.year = [self.lsYear getStrVal];
    }else {
        _styleVo.year = @"";
    }
    _styleVo.season = self.lsSeason.lblVal.text;
    _styleVo.seasonValId = [self.lsSeason getStrVal];
    _styleVo.stage = [self.txtPhase getStrVal];
    _styleVo.fabric = self.lsFabric.lblVal.text;
    _styleVo.fabricValId = [self.lsFabric getStrVal];
    _styleVo.lining = self.lsMaterial.lblVal.text;
    _styleVo.liningValId = [self.lsMaterial getStrVal];
    _styleVo.tag = [self.txtTag getStrVal];
    
    if ([[Platform Instance] getShopMode] == 3) {
        if ([NSString isBlank:[self.lsStyleInfoSyn getStrVal]]) {
            self.styleVo.synShopId = @"";
        }else{
            self.styleVo.synShopId = [self.lsStyleInfoSyn getStrVal];
        }
    } else {
        self.styleVo.synShopId = [[Platform Instance] getkey:SHOP_ID];
    }
    
    if ([NSString isNotBlank:_styleVo.fileName]&&[NSString isBlank:[self.imgStyle getImageFilePath]]) {
        
        _styleVo.fileDeleteFlg = 1;
    }else if ([NSString isNotBlank:[self.imgStyle getImageFilePath]] && ![_styleVo.filePath isEqualToString:[self.imgStyle getImageFilePath]]) {
        
        _styleVo.fileName = self.imgFilePathTemp;
    }
    _styleVo.fileName = self.imgStyle.currentVal;
    _styleVo.percentage = [self.lsSaleRoyaltyRatio getStrVal].doubleValue;
    _styleVo.hasDegree = [NSNumber numberWithInt:[self.rdoIsJoinPoint getStrVal].intValue];
    _styleVo.isSales = [NSNumber numberWithInt:[self.rdoIsJoinActivity getStrVal].intValue];
    
    __weak GoodsStyleEditView *weakSelf = self;
    [_goodsService saveStyleDetail:[StyleVo getDictionaryData:_styleVo] shopId:self.synShopId synPriceFlg:_priceChangeFlg? @"1":@"0" token:nil completionHandler:^(id json) {
        [self saveCategoryNameAndCategoryId];
        if (!(weakSelf)) {
            return ;
        }
        
        if ([_saveWay isEqualToString:@"1"])
        {
            [self.txtStyleNo initData:@""];
            
            if (_viewTag == GOODS_STYLE_LIST_VIEW) {
                if ([ObjectUtil isNotNull:[json objectForKey:@"filePath"]]) {
                    _styleVo.filePath = [json objectForKey:@"filePath"];
                }else {
                    _styleVo.filePath = @"";
                }
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[GoodsStyleListView class]]) {
                        GoodsStyleListView *listView = (GoodsStyleListView *)vc;
                        [listView loadDatasFromEditView:_styleVo action:ACTION_CONSTANTS_EDIT];
                    }
                }
                
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [weakSelf.navigationController popViewControllerAnimated:NO];
                
                
            }else {
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [weakSelf.navigationController popViewControllerAnimated:NO];
            }
        }
        else if ([_saveWay isEqualToString:@"2"])
        {
            _lastVer = [json objectForKey:@"lastVer"];
            [_goodsService selectStyleGoodsList:_shopId styleId:_styleId completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                NSMutableArray* list = [StyleGoodsVo converToArr:[json objectForKey:@"styleGoodsVoList"]];
                if (list == nil || list.count == 0) {
                    
                    GoodsAttributeAddListView* vc = [[GoodsAttributeAddListView alloc] initWithShopId:_shopId styleId:_styleVo.styleId lastVer:_lastVer synShopId:_synShopId action:ACTION_CONSTANTS_ADD fromViewTag:GOODS_STYLE_EDIT_VIEW];
                    [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                    [weakSelf.navigationController pushViewController:vc animated:NO];
                    [vc loadDatas:^(BOOL flg, NSString* lastVer) {
                        if (flg) {
                            _lastVer = lastVer;
                            GoodsStyleGoodsListView* listView = [[GoodsStyleGoodsListView alloc] init];
                            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                            [weakSelf.navigationController pushViewController:listView animated:NO];
                            [listView loaddatas:_shopId styleId:_styleVo.styleId lastVer:_lastVer synShopId:_synShopId styleGoodsList:nil fromViewTag:GOODS_STYLE_EDIT_VIEW callBack:^(BOOL flg) {
                                [weakSelf loaddatasFromAttributeAddView];
                                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                                [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                            }];
                        }else {
                            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                        }
                    }];
                }else {
                    GoodsStyleGoodsListView* listView = [[GoodsStyleGoodsListView alloc] init];
                    [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                    [weakSelf.navigationController pushViewController:listView animated:NO];
                    [listView loaddatas:_shopId styleId:_styleVo.styleId lastVer:_lastVer synShopId:_synShopId styleGoodsList:list fromViewTag:GOODS_STYLE_EDIT_VIEW callBack:^(BOOL flg) {
                        [weakSelf loaddatasFromAttributeAddView];
                        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                    }];
                }
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
        else if ([_saveWay isEqualToString:@"3"])
        {
            WechatGoodsManagementStyleDetailViewViewController* vc = [[WechatGoodsManagementStyleDetailViewViewController alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
            vc.shopId = _shopId;
            vc.synShopEntityId = weakSelf.synShopEntityId;
            vc.styleId = [json objectForKey:@"styleId"];
            vc.action = ACTION_CONSTANTS_EDIT;
            vc.categoryId = _styleVo.categoryId;
            __weak GoodsStyleEditView *weakSelf = self;
            [vc loadDatasFromStyleEditView:^(BOOL flg) {
                [weakSelf selectStyleDetail];
            }];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

-(BOOL) isValid
{
    if ([NSString isBlank:[self.txtStyleNo getStrVal]]) {
        [AlertBox show:@"款号不能为空，请输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtStyleName getStrVal]]) {
        [AlertBox show:@"款式名称不能为空，请输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsHangTagPrice getStrVal]]) {
        [AlertBox show:@"吊牌价不能为空，请输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsRetailPrice getStrVal]]) {
        [AlertBox show:@"零售价不能为空，请输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsSaleRoyaltyRatio getStrVal]]) {
        [AlertBox show:@"销售提成比例(%)不能为空，请输入!"];
        return NO;
    }
    
    return YES;
}


- (void)initHead
{
    [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:Head_ICON_OK];
}

-(void)btnDelClick
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？", _styleVo.styleName]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        __weak GoodsStyleEditView* weakSelf = self;
        if (self.action == ACTION_CONSTANTS_EDIT) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            [list addObject:_styleVo.styleId];
            [_goodsService deleteStyle:_shopId styleIdList:list completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                [self delFinish];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
}

- (void)delFinish
{
    if (_viewTag == GOODS_STYLE_LIST_VIEW) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[GoodsStyleListView class]]) {
                GoodsStyleListView *goodsVc = (GoodsStyleListView *)vc;
                [goodsVc loadDatasFromEditView:_styleVo action:ACTION_CONSTANTS_DEL];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
    }else if (_viewTag == GOODS_STYLE_INFO_VIEW){
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[GoodsStyleInfoView class]]) {
                GoodsStyleInfoView *goodsVc = (GoodsStyleInfoView *)vc;
                [goodsVc loadDatasFromEdit];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
    }
}


#pragma mark - 图片选择处理: 从相册、相机

-(void)onConfirmImgClick:(NSInteger)btnIndex
{
    if (btnIndex == 1) {
        
        [self showImagePickerController:UIImagePickerControllerSourceTypeCamera];
    } else if(btnIndex == 0) {
        
        [self showImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

// LSImagePickerController, 选择处理照片
- (void)showImagePickerController:(UIImagePickerControllerSourceType)type {
    
    _imagePicker = [LSImagePickerController showImagePickerWith:type presenter:self];
    _imagePicker.cropSize = CGSizeMake(128, 128);
}

// LSImagePickerDelegate
- (void)imagePicker:(LSImagePickerController *)controller pickerImage:(UIImage *)image {
    
    _goodsImage = [ImageUtils compressImage:image experWidth:500.0f];
    NSString *styleId = _styleVo.styleId;
    if ([NSString isBlank:styleId]) {//上传图片路径 如果是编辑则取goodsId 如果是添加则随机上传
        styleId = [NSString getUniqueStrByUUID];
    }
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", styleId, [NSString getUniqueStrByUUID]];
    self.imgFilePathTemp = filePath;
    [self uploadImgFinsh];
    _imagePicker = nil;
}

- (void)imagePickerDidCancel:(LSImageMessageType)message {
    
    if (message == LSImageMessageNoSupportCamera) {
        [AlertBox show:@"相机好像不能用哦!"];
    }else if (message == LSImageMessageNoSupportPhotoLibrary) {
        [AlertBox show:@"相册好像不能访问哦!"];
    }
    _imagePicker = nil;
}


- (void)onDelImgClick
{
    // 设定图片为nil
    _goodsImage = nil;
    
    // 设定文件名为nil
    self.imgFilePathTemp = nil;
    
    // 调用改变图片方法
    [self.imgStyle changeImg:self.imgFilePathTemp img:_goodsImage];
}

- (void)uploadImgFinsh
{
    [self.imgStyle changeImg:self.imgFilePathTemp img:_goodsImage];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
#pragma mark - 保存商品分类名称和Id到本地 为了下次添加商品时默认选择上次的分类
- (void)saveCategoryNameAndCategoryId {
    //商品分类Id
    NSString *categoryId = [self.lsCategory getStrVal];
    //商品分类有值 商品分类不是必填的
    if ([NSString isNotBlank:categoryId]) {
        NSString *categoryIdKey = [NSString stringWithFormat:@"%@%@", [[Platform Instance] getkey:ENTITY_ID], kCategoryId];
        [[Platform Instance] saveKeyWithVal:categoryIdKey withVal:categoryId];
    }
}


@end
