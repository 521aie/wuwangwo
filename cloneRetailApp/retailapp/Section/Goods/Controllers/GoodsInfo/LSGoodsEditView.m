//
//  LSGoodsEditView.m
//  retailapp
//
//  Created by wuwangwo on 2017/3/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_PRICE_MODE 1000

#import "LSGoodsEditView.h"
#import "GoodsVo.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "EditItemImage.h"
#import "LSEditItemList.h"
#import "LSEditItemRadio.h"
#import "EditItemRadio2.h"
#import "LSEditItemText.h"
#import "EditItemText2.h"
#import "LSEditItemTitle.h"
#import "GoodsModuleEvent.h"
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AlertBox.h"
#import "Platform.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "SelectOrgShopListView.h"
#import "ShopVo.h"
#import "GoodsBrandVo.h"
#import "OptionPickerBox.h"
#import "GoodsRender.h"
#import "Platform.h"
#import "ColorHelper.h"
#import "LSGoodsListViewController.h"
#import "LSGoodsInfoSelectViewController.h"
#import "GoodsAttributeManageListView.h"
#import "GoodsCategoryListView.h"
#import "ScanViewController.h"
#import "ImageUtils.h"
#import "LSGoodsUnitVo.h"
#import "NameItemVO.h"
#import "UnitInfoViewController.h"
#import "WechatGoodsDetailsView.h"
#import "LSImageVo.h"
#import "LSImageDataVo.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "OptionPickerClient.h"
#import "FooterListEvent.h"
#import "IEditItemImageEvent.h"
#import "SymbolNumberInputBox.h"
#import "IEditItemMemoEvent.h"
#import "ISearchBarEvent.h"

@interface LSGoodsEditView ()<OptionPickerClient,IEditItemRadioEvent, IEditItemListEvent, FooterListEvent, IEditItemImageEvent, SymbolNumberInputClient, IEditItemMemoEvent, ISearchBarEvent, EditItemText2Delegate, LSScanViewDelegate, UnitInfoViewDelegate, EditItemTextDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImage *goodsImage;
@property (nonatomic, strong) UIScrollView *scrollView;
//商品上下架
@property (nonatomic, strong) EditItemRadio2 *rdoStatus;
//基本信息
@property (nonatomic, strong) LSEditItemTitle *TitBaseInfo;
//商品条码
@property (nonatomic, strong) EditItemText2 * txtBarcode;
//商品代码
@property (nonatomic, strong) LSEditItemText *txtInnerCode;
//商品名称
@property (nonatomic, strong) LSEditItemText *txtGoodsName;
//散装称重商品
@property (nonatomic, strong) LSEditItemRadio *rdoIsInBulkGoods;
//计价方式
@property (nonatomic, strong) LSEditItemList *lstPriceModel;
//进货价
@property (nonatomic, strong) LSEditItemList *lsPurPrice;
//零售价
@property (nonatomic, strong) LSEditItemList *lsRetailPrice;
//会员价
@property (nonatomic, strong) LSEditItemList *lsMemberPrice;
//批发价
@property (nonatomic, strong) LSEditItemList *lsWhoPrice;
//初始库存数
@property (nonatomic, strong) LSEditItemList *lstNowStore;
//初始单位成本价(元)
@property (nonatomic, strong) LSEditItemList *lsRawUnitCostPrice;
//同步门店
@property (nonatomic, strong) LSEditItemList *lsSynShop;
//扩展信息
@property (nonatomic, strong) LSEditItemTitle *TitExtendInfo;
//商品简码
@property (nonatomic, strong) LSEditItemText *txtShortCode;
//商品拼音码
@property (nonatomic, strong) LSEditItemText *txtSpell;

//单位
@property (nonatomic, strong) LSEditItemList *lstUtit;
//商品规格
@property (nonatomic, strong) LSEditItemText *txtSpecification;

//商品产地
@property (nonatomic, strong) LSEditItemText *txtOrigin;
//保质期
@property (nonatomic, strong) LSEditItemList *lsPeriod;
//商品图片
@property (nonatomic, strong) EditItemImage *imgGoods;
//销售设置
@property (nonatomic, strong) LSEditItemTitle *TitSaleSetting;
//销售提成比例
@property (nonatomic, strong) LSEditItemList *lsSaleRoyaltyRatio;
//参与积分
@property (nonatomic, strong) LSEditItemRadio *rdoIsJoinPoint;
//参与任何优惠活动
@property (nonatomic, strong) LSEditItemRadio *rdoIsJoinActivity;
//微店设置
@property (nonatomic, strong) LSEditItemTitle *TitMicroSetting;
//微店信息介绍
@property (nonatomic, strong) LSEditItemList *lsMicroInfo;
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIButton *btnOper;
@property (nonatomic, strong) NSString* imgFilePathTemp;
@property (nonatomic, strong) NSMutableArray* categoryList;
@property (nonatomic, strong) NSMutableArray* brandList;

@property (nonatomic,copy) GoodsEditBack goodsEditBack;
@property (nonatomic, strong) GoodsService* goodsService;

// 1表示为最下方按钮保存，0表示为右上方按钮保存
@property (nonatomic) short clickType;
//同步到的机构或者门店的shopEntityId
@property (nonatomic, strong) NSString *synShopEntityId;
@end

@implementation LSGoodsEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDatas];
    [self configTitle:@"商品详情" leftPath:Head_ICON_BACK rightPath:nil];
    [self setupcontainer];
    [self initNotifaction];
    [self initMainView];
    [self loaddatas];
    [self configHelpButton:HELP_GOODS_DETAIL];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)configDatas {
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;
    self.goodsService = [[GoodsService alloc] init];
    if ([[Platform Instance] getShopMode] == 3) {
        self.synShopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    }
    self.categoryList = [[NSMutableArray alloc] init];
    self.brandList = [[NSMutableArray alloc] init];
}

- (void)setupcontainer {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, self.view.ls_width, self.view.ls_height - kNavH)];
    self.container.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.rdoStatus = [EditItemRadio2 editItemRadio];
    [self.container addSubview:self.rdoStatus];
    
    self.TitBaseInfo = [LSEditItemTitle editItemTitle];
    [self.TitBaseInfo configTitle:@"基本信息"];
    [self.container addSubview:self.TitBaseInfo];
    
    self.txtBarcode = [EditItemText2 editItemText];
    [self.container addSubview:self.txtBarcode];
    
    self.txtInnerCode = [LSEditItemText editItemText];
    [self.container addSubview:self.txtInnerCode];
    
    self.txtGoodsName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtGoodsName];
    
    self.rdoIsInBulkGoods = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoIsInBulkGoods];
    
    self.lstPriceModel = [LSEditItemList editItemList];
    [self.container addSubview:self.lstPriceModel];
    

    self.lsPurPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsPurPrice];
    
    self.lsRetailPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsRetailPrice];
    
    self.lsMemberPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsMemberPrice];
    
    self.lsWhoPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsWhoPrice];
    
    self.lstNowStore = [LSEditItemList editItemList];
    [self.container addSubview:self.lstNowStore];
    
    self.lsRawUnitCostPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsRawUnitCostPrice];
    
    self.lsSynShop = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSynShop];
    
    self.TitExtendInfo = [LSEditItemTitle editItemTitle];
    [self configTitle:@"扩展信息"];
    [self.container addSubview:self.TitExtendInfo];
    
    self.txtShortCode = [LSEditItemText editItemText];
    [self.container addSubview:self.txtShortCode];
    
    self.txtSpell = [LSEditItemText editItemText];
    [self.container addSubview:self.txtSpell];
    
    self.lsCategory = [LSEditItemList editItemList];
    [self.container addSubview:self.lsCategory];
    
    self.lstUtit = [LSEditItemList editItemList];
    [self.container addSubview:self.lstUtit];
    
    self.txtSpecification = [LSEditItemText editItemText];
    [self.container addSubview:self.txtSpecification];
    
    self.lsBrand = [LSEditItemList editItemList];
    [self.container addSubview:self.lsBrand];
    
    self.txtOrigin = [LSEditItemText editItemText];
    [self.container addSubview:self.txtOrigin];
    
    self.lsPeriod = [LSEditItemList editItemList];
    [self.container addSubview:self.lsPeriod];
    
    self.imgGoods = [EditItemImage editItemImage];
    [self.container addSubview:self.imgGoods];
    
    self.TitSaleSetting = [LSEditItemTitle editItemTitle];
    [self.TitSaleSetting configTitle:@"销售设置"];
    [self.container addSubview:self.TitSaleSetting];
    
    self.lsSaleRoyaltyRatio = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSaleRoyaltyRatio];
    
    self.rdoIsJoinPoint = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoIsJoinPoint];
    
    self.rdoIsJoinActivity = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoIsJoinActivity];
    
    self.TitMicroSetting = [LSEditItemTitle editItemTitle];
    [self configTitle:@"微店设置"];
    [self.container addSubview:self.TitMicroSetting];
    
    self.lsMicroInfo = [LSEditItemList editItemList];
    [self.container addSubview:self.lsMicroInfo];
    
    //xib y = 8
    self.btnOper = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnOper.frame = CGRectMake(10, 0, self.container.ls_width-20, 44);
    [self.btnOper addTarget:self action:@selector(btnDelClick) forControlEvents:UIControlEventTouchUpInside];
    self.btnOper.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.container addSubview:self.btnOper];
}

#pragma mark - 加载商品分类列表只有添加商品的时候调用
- (void)loadCategoryList {
    
    __weak typeof(self) weakSelf = self;
    [_goodsService selectLastCategoryInfo:@"0" completionHandler:^(id json) {

        NSString *categoryIdKey = [NSString stringWithFormat:@"%@%@", [[Platform Instance] getkey:ENTITY_ID], kCategoryId];
        //商品分类Id
        NSString *categoryId = [[Platform Instance] getkey:categoryIdKey];
        NSMutableArray* list = [json objectForKey:@"categoryList"];
        weakSelf.categoryList = [[NSMutableArray alloc] init];
        [weakSelf.lsCategory initData:@"请选择" withVal:nil];
        if (list != nil && list.count > 0) {
            for (NSDictionary* dic in list) {
                CategoryVo *categoryVo = [CategoryVo convertToCategoryVo:dic];
                [weakSelf.categoryList addObject:categoryVo];
                //添加的商品分类默认是上一次保存商品的分类默认请选择
                if ([categoryId isEqualToString:categoryVo.categoryId]) {
                    [weakSelf.lsCategory initData:categoryVo.name withVal:categoryVo.categoryId];
                }
            }
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)loaddatas:(NSString*) shopId shopName:(NSString*) shopName callBack:(GoodsEditBack)callBack
{
    self.goodsEditBack = callBack;
    self.synShopId = shopId;
    self.synShopName = shopName;
}

- (void)loaddatas
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    if (self.action == ACTION_CONSTANTS_ADD) {
         [self configTitle:@"添加商品" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
//        self.titleBox.imgMore.hidden = NO;
        
        [self.btnOper setTitle:@"保存并继续添加" forState:UIControlStateNormal];
        self.btnOper.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.btnOper setBackgroundImage:[UIImage imageNamed:@"btn_full_g.png"] forState:UIControlStateNormal];
        [self clearDo];
        
        if (_viewTag == GOODS_BATCH_CHOICE_VIEW1) {
            [self.btnOper setHidden:YES];
        }
        
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }else{
        [self.lstNowStore initLabel:@"当前库存数" withHit:nil delegate:self];
        [self.lsRawUnitCostPrice visibal:NO];
        // 判断是否有编辑权限
        if ([[Platform Instance] lockAct:ACTION_GOODS_DELETE]) {
            [self.btnOper setHidden:YES];
        }
        __weak typeof(self) weakSelf = self;
        [_goodsService selectGoodsDetail:self.shopId goodsId:self.goodsId completionHandler:^(id json) {
  
            [weakSelf responseSuccess:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)responseSuccess:(id)json
{
    self.goodsVo = [GoodsVo convertToGoodsVo:[json objectForKey:@"goodsVo"]];
    
//    self.titleBox.lblRight.hidden = YES;
    //    self.titleBox.imgMore.hidden = YES;
//    self.titleBox.lblTitle.text = @"商品详情";
    [self configTitle:@"商品详情" leftPath:Head_ICON_BACK rightPath:nil];
    
    [self.btnOper setTitle:@"删除" forState:UIControlStateNormal];
    self.btnOper.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.btnOper setBackgroundImage:[UIImage imageNamed:@"btn_full_r"] forState:UIControlStateNormal];
    [self fillModel];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)isEdit:(BOOL)flg
{
    if (flg) {
        [self.rdoStatus.clickBtn setEnabled:YES];
        [self.txtBarcode editEnabled:YES];
        [self.txtInnerCode editEnabled:YES];
        [self.txtGoodsName editEnabled:YES];
        [self.rdoIsInBulkGoods editable:YES];
        [self.lstPriceModel editEnable:YES];
        [self.lsPurPrice editEnable:YES];
        [self.lsRetailPrice editEnable:YES];
        [self.lsMemberPrice editEnable:YES];
        [self.lsWhoPrice editEnable:YES];
        [self.lstNowStore editEnable:YES];
        [self.lsSynShop editEnable:YES];
        [self.txtShortCode editEnabled:YES];
        [self.txtSpell editEnabled:YES];
        [self.lsCategory editEnable:YES];
        [self.txtSpecification editEnabled:YES];
        [self.lsBrand editEnable:YES];
        [self.txtOrigin editEnabled:YES];
        [self.lsPeriod editEnable:YES];
        [self.imgGoods editEnabled:YES];
        [self.lsSaleRoyaltyRatio editEnable:YES];
        [self.rdoIsJoinPoint editable:YES];
        [self.rdoIsJoinActivity editable:YES];
        [self.lstUtit editEnable:YES];
    } else {
        [self.rdoStatus.clickBtn setEnabled:NO];
        [self.txtBarcode editEnabled:NO];
        [self.txtInnerCode editEnabled:NO];
        [self.txtGoodsName editEnabled:NO];
        [self.rdoIsInBulkGoods editable:NO];
        [self.lstPriceModel editEnable:NO];
        [self.lsPurPrice editEnable:NO];
        [self.lsRetailPrice editEnable:NO];
        [self.lsMemberPrice editEnable:NO];
        [self.lsWhoPrice editEnable:NO];
        [self.lstNowStore editEnable:NO];
        [self.lsSynShop editEnable:NO];
        [self.txtShortCode editEnabled:NO];
        [self.txtSpell editEnabled:NO];
        [self.lsCategory editEnable:NO];
        [self.txtSpecification editEnabled:NO];
        [self.lsBrand editEnable:NO];
        [self.txtOrigin editEnabled:NO];
        [self.lsPeriod editEnable:NO];
        [self.imgGoods editEnabled:NO];
        [self.lsSaleRoyaltyRatio editEnable:NO];
        [self.rdoIsJoinPoint editable:NO];
        [self.rdoIsJoinActivity editable:NO];
        [self.lsMicroInfo editEnable:NO];
        [self.lstUtit editEnable:NO];
    }
}

#pragma mark 添加页面初始化
- (void)clearDo
{
    [self.rdoStatus initData:@"1"];
    self.rdoStatus.lblName.text = @"商品已上架";
    [self.rdoStatus initHit:@"已上架的商品可以在各个平台显示及销售"];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    [self.txtInnerCode visibal:NO];
    [self.lstNowStore initData:nil withVal:nil];
    [self.lsRawUnitCostPrice initData:nil withVal:nil];
    
    [self.txtSpell visibal:NO];
    
    if ([[Platform Instance] getShopMode]== 3 && [self.synShopId isEqualToString:[[Platform Instance] getkey:ORG_ID]]) {
        [self.lsSynShop initData:@"同步所有" withVal:self.synShopId];
    } else {
        [self.lsSynShop initData:self.synShopName withVal:self.synShopId];
    }
    [self.txtBarcode initData:nil];
    
    [self.txtGoodsName initData:nil];
    //添加时散称称重商品开关关闭
    [self.rdoIsInBulkGoods initData:@"0"];
    //散称称重商品开关关闭时计价方式不显示
    [self.lstPriceModel initData:@"计重" withVal:@"1"];
    [self.lstPriceModel visibal:NO];
    
    [self.lsPurPrice initData:nil withVal:nil];
    
    [self.lsRetailPrice initData:nil withVal:nil];
    
    [self.lsMemberPrice initData:nil withVal:nil];
    
    [self.lsWhoPrice initData:nil withVal:nil];
    
    [self.txtShortCode initData:nil];
    [self.lstUtit initData:@"请选择" withVal:@""];
    
    [self.txtSpecification initData:nil];
    
    [self.lsBrand initData:@"请选择" withVal:@""];
    
    [self.txtOrigin initData:nil];
    
    [self.lsPeriod initData:nil withVal:nil];
    
    [self.imgGoods initView:nil path:nil];
    
    [self.lsSaleRoyaltyRatio initData:@"0.00" withVal:@"0.00"];
    
    [self.rdoIsJoinPoint initData:@"1"];
    
    [self.rdoIsJoinActivity initData:@"1"];
    
    if (self.addGoodsVo != nil) {
        [self.txtBarcode changeData:self.addGoodsVo.barCode];
        [self.txtGoodsName changeData:self.addGoodsVo.goodsName];
        
        if (self.addGoodsVo.type == 4) {
            [self.rdoIsInBulkGoods changeData:@"1"];
            [self.lstPriceModel visibal:YES];
        } else {
            //添加时散称称重商品开关关闭
            [self.rdoIsInBulkGoods initData:@"0"];
            //散称称重商品开关关闭时计价方式不显示
            [self.lstPriceModel visibal:NO];
        }
        
        [self.lsPurPrice initData:nil withVal:nil];
        
        [self.lsRetailPrice initData:nil withVal:nil];
        
        [self.lsMemberPrice initData:nil withVal:nil];
        
        [self.lsWhoPrice initData:nil withVal:nil];
        
        [self.txtShortCode changeData:self.addGoodsVo.shortCode];
        if ([[self.rdoIsInBulkGoods getStrVal] isEqualToString:@"1"]) {
            self.txtShortCode.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"必填" attributes:@{NSForegroundColorAttributeName: [UIColor redColor] }];
            [self.lstPriceModel visibal:YES];
        }
        
        if ([NSString isBlank:self.addGoodsVo.categoryName]) {
            [self loadCategoryList];
        }else{
            [self.lsCategory changeData:self.addGoodsVo.categoryName withVal:self.addGoodsVo.categoryId];
        }
        
        [self.txtSpecification changeData:self.addGoodsVo.specification];
        
        if ([NSString isBlank:self.addGoodsVo.brandId]) {
            [self.lsBrand initData:@"请选择" withVal:nil];
        }else{
            [self.lsBrand changeData:self.addGoodsVo.brandName withVal:self.addGoodsVo.brandId];
        }
        
        if ([NSString isBlank:self.addGoodsVo.unitName]) {
            [self.lstUtit initData:@"请选择" withVal:nil];
        }else{
            [self.lstUtit changeData:self.addGoodsVo.unitName withVal:self.addGoodsVo.unitName];
        }
        
        [self.txtOrigin changeData:self.addGoodsVo.origin];
        
        [self.lsPeriod changeData:[self.addGoodsVo.period stringValue] withVal:[self.addGoodsVo.period stringValue]];
        
        [self.imgGoods initView:self.addGoodsVo.filePath path:self.addGoodsVo.filePath];
        
        [self.lsSaleRoyaltyRatio changeData:[NSString stringWithFormat:@"%.2f", self.addGoodsVo.percentage] withVal:[NSString stringWithFormat:@"%.2f", self.addGoodsVo.percentage]];
        if (self.addGoodsVo.hasDegree == nil) {
            [self.rdoIsJoinPoint changeData:@"1"];
        } else {
            [self.rdoIsJoinPoint changeData:[self.addGoodsVo.hasDegree stringValue]];
        }
        
        if (self.addGoodsVo.isSales == nil) {
            [self.rdoIsJoinActivity changeData:@"1"];
        } else {
            [self.rdoIsJoinActivity changeData:[self.addGoodsVo.isSales stringValue]];
        }
    } else {
        [self loadCategoryList];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)fillModel {
    
    if (self.goodsVo.upDownStatus == 1) {
        [self.rdoStatus initData:@"1"];
        self.rdoStatus.lblName.text = @"商品已上架";
        [self.rdoStatus initHit:@"已上架的商品可以在各个平台显示及销售"];
    } else {
        [self.rdoStatus initData:@"2"];
        self.rdoStatus.lblName.text = @"商品已下架";
        [self.rdoStatus initHit: @"已下架的商品可以在收银设备显示，但是无法销售，在其他平台（微店等）上不显示"];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    [self.txtBarcode initData:self.goodsVo.barCode];
    
    [self.txtInnerCode initData:self.goodsVo.innerCode];
    [self.txtInnerCode visibal:YES];
    [self.txtInnerCode editEnabled:NO];
    
    [self.txtGoodsName initData:self.goodsVo.goodsName];
    if ([[Platform Instance] getShopMode] == 1 || ([[Platform Instance] getShopMode] == 3 && [[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"])) {
        [self.txtGoodsName editEnabled:YES];
    }else{
        [self.txtGoodsName editEnabled:NO];
    }
    
    if (self.goodsVo.type == 4) {
        [self.rdoIsInBulkGoods initData:@"1"];
        
        [self.lstPriceModel visibal:YES];
    }else{
        [self.rdoIsInBulkGoods initData:@"0"];
        [self.lstPriceModel initData:@"计重" withVal:@"1"];
        [self.lstPriceModel visibal:NO];
    }
    
    [self.lsPurPrice initData:[NSString stringWithFormat:@"%.2f", self.goodsVo.purchasePrice] withVal:[NSString stringWithFormat:@"%.2f", self.goodsVo.purchasePrice]];
    
    [self.lsRetailPrice initData:[NSString stringWithFormat:@"%.2f", self.goodsVo.retailPrice] withVal:[NSString stringWithFormat:@"%.2f", self.goodsVo.retailPrice]];
    [self.lsMemberPrice initData:[NSString stringWithFormat:@"%.2f", self.goodsVo.memberPrice] withVal:[NSString stringWithFormat:@"%.2f", self.goodsVo.memberPrice]];
    [self.lsWhoPrice initData:[NSString stringWithFormat:@"%.2f", self.goodsVo.wholesalePrice] withVal:[NSString stringWithFormat:@"%.2f", self.goodsVo.wholesalePrice]];
    
    NSString *number = self.goodsVo.number.stringValue;
    
    if ([number containsString:@"."]) {
        [self.lstNowStore initData:[NSString stringWithFormat:@"%.3f", self.goodsVo.number.doubleValue] withVal:[NSString stringWithFormat:@"%.3f", self.goodsVo.number.doubleValue ]];
    } else {
        [self.lstNowStore initData:[NSString stringWithFormat:@"%d", self.goodsVo.number.intValue] withVal:[NSString stringWithFormat:@"%d", self.goodsVo.number.intValue ]];
    }
    
    [self.lstNowStore editEnable:NO];
    
    [self.txtShortCode initData:self.goodsVo.shortCode];
    
    if ([[self.rdoIsInBulkGoods getStrVal] isEqualToString:@"1"]) {
        self.txtShortCode.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"必须输入5位数字" attributes:@{NSForegroundColorAttributeName: [UIColor redColor] }];
        [self.lstPriceModel visibal:YES];
    }
    [self.txtSpell initData:self.goodsVo.spell];
    [self.txtSpell editEnabled:NO];
    [self.txtSpell visibal:YES];
    if ([[Platform Instance] getShopMode]== 3 && [self.synShopId isEqualToString:[[Platform Instance] getkey:ORG_ID]]) {
        [self.lsSynShop initData:@"同步所有" withVal:self.synShopId];
    } else {
        [self.lsSynShop initData:self.synShopName withVal:self.synShopId];
    }
    
    if ([NSString isBlank:self.goodsVo.categoryName] || [self.goodsVo.categoryId isEqualToString:@"-1"]) {
        [self.lsCategory initData:@"请选择" withVal:nil];
    }else{
        [self.lsCategory initData:self.goodsVo.categoryName withVal:self.goodsVo.categoryId];
    }
    [self.txtSpecification initData:self.goodsVo.specification];
    if ([NSString isBlank:self.goodsVo.brandId]) {
        [self.lsBrand initData:@"请选择" withVal:nil];
    }else{
        [self.lsBrand initData:self.goodsVo.brandName withVal:self.goodsVo.brandId];
    }
    
    if ([NSString isBlank:self.goodsVo.unitName]) {
        [self.lstUtit initData:@"请选择" withVal:nil];
    }else{
        [self.lstUtit initData:self.goodsVo.unitName withVal:self.goodsVo.unitId];
    }
    
    [self.txtOrigin initData:self.goodsVo.origin];
    [self.lsPeriod initData:[self.goodsVo.period stringValue] withVal:[self.goodsVo.period stringValue]];
    [self.imgGoods initView:self.goodsVo.filePath path:self.goodsVo.filePath];
    [self.lsSaleRoyaltyRatio initData:[NSString stringWithFormat:@"%.2f", self.goodsVo.percentage] withVal:[NSString stringWithFormat:@"%.2f", self.goodsVo.percentage]];
    [self.rdoIsJoinPoint initData:[self.goodsVo.hasDegree stringValue]];
    [self.rdoIsJoinActivity initData:[self.goodsVo.isSales stringValue]];
    if (self.goodsVo.priceType == 2) {//有可能是null
        [self.lstPriceModel initData:@"计件" withVal:@"2"];
    } else {
        [self.lstPriceModel initData:@"计重" withVal:@"1"];
    }
    
    if (([[Platform Instance] getShopMode] == 3 && ![[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]) || [[Platform Instance] getShopMode] == 2) {
        [self.txtGoodsName editEnabled:NO];
        [self.txtBarcode editEnabled:NO];
        [self.txtInnerCode editEnabled:NO];
        [self.rdoIsInBulkGoods editable:NO];
        [self.lstPriceModel editEnable:NO];
        [self.txtShortCode editEnabled:NO];
        [self.txtSpell editEnabled:NO];
        [self.lsCategory editEnable:NO];
        [self.txtSpecification editEnabled:NO];
        [self.lsBrand editEnable:NO];
        [self.txtOrigin editEnabled:NO];
        [self.lsPeriod editEnable:NO];
        [self.imgGoods editEnabled:NO];
        [self.lsSaleRoyaltyRatio editEnable:NO];
        [self.rdoIsJoinPoint editable:NO];
        [self.rdoIsJoinActivity editable:NO];
        //        [self.lsMicroInfo editEnable:NO];
        [self.lstUtit editEnable:NO];
    }
    
    if ([[Platform Instance] lockAct:ACTION_GOODS_EDIT]) {
        [self isEdit:NO];
    }
}

- (void)initMainView {
    
    [self.rdoStatus initLabel:@"" withHit:nil delegate:self];
    [self.rdoStatus.line setHidden:YES];
    self.TitBaseInfo.lblName.text = @"基本信息";
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self.txtBarcode initLabel:@"条形码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault withType:nil showTag:0 delegate:self];
    } else {
        [self.txtBarcode initLabel:@"条形码" withHit:@"未输入时系统默认生成以200开头的13位码" isrequest:NO type:UIKeyboardTypeDefault withType:nil showTag:0 delegate:self];
    }
    [self.txtBarcode.btnButton setImage:[UIImage imageNamed:@"goods_scan"] forState:UIControlStateNormal];
    [self.txtBarcode initPosition:1];
    self.txtBarcode.btnButton.imageView.bounds = CGRectMake(0, 0, 24, 24);
    self.txtBarcode.btnButton.imageEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    [self.txtBarcode initMaxNum:18];
    self.txtBarcode.btnButton.backgroundColor = [UIColor clearColor];
    [self.txtInnerCode initLabel:@"店内码" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtInnerCode initMaxNum:18];
    [self.txtGoodsName initLabel:@"名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtGoodsName initMaxNum:50];
    NSString *hit = nil;
    if (self.action == ACTION_CONSTANTS_ADD) {
        hit = @"散称商品的条形码默认与简码相同";
    }
    [self.rdoIsInBulkGoods initLabel:@"散装称重商品" withHit:hit delegate:self];
    //只有散装称重商品打开才显示计价方式
    [self.lstPriceModel initLabel:@"▪︎ 计价方式" withHit:nil delegate:self];
    [self.lsPurPrice initLabel:@"参考进货价(元)" withHit:nil isrequest:NO delegate:self];
//    if ([[Platform Instance] lockAct:ACTION_REF_PURCHASE_PRICE]) {//没有参考进货价权限时参考进货价不显示
//        [self.lsPurPrice visibal:NO];
//    }
     [self.lsPurPrice visibal:NO];
    [self.lsRetailPrice initLabel:@"零售价(元)" withHit:nil isrequest:YES delegate:self];
    [self.lsMemberPrice initLabel:@"会员价(元)" withHit:nil isrequest:NO delegate:self];
    [self.lsWhoPrice initLabel:@"批发价(元)" withHit:nil isrequest:NO delegate:self];
    
    if (self.action == ACTION_CONSTANTS_ADD) {
        // 商超单店、商超连锁-门店 添加状态时显示为：
        [self.lstNowStore initLabel:@"初始库存数" withHit:nil delegate:self];
    } else {
        [self.lstNowStore initLabel:@"当前库存数" withHit:nil delegate:self];
    }
    [self.lsRawUnitCostPrice initLabel:@"初始单位成本价(元)" withHit:nil delegate:self];
    [self.lsSynShop initLabel:@"商品同步" withHit:nil delegate:self];
    [self.lsSynShop.imgMore setImage:[UIImage imageNamed:@"ico_next"]];
    
    // 商超连锁不显示“初始库存数” 和 “初始单位成本价(元)”
    BOOL isShow = ![[Platform Instance] lockAct:ACTION_STORE_COST_PRICE_SET];
    if ([[Platform Instance] getShopMode] != 3) {
        [self.lsSynShop visibal:NO];
        [self.lstNowStore visibal:YES];
        if (self.action == ACTION_CONSTANTS_ADD) {
            [self.lstNowStore visibal:isShow];
            [self.lsRawUnitCostPrice visibal:isShow];
        } else {
            [self.lsRawUnitCostPrice visibal:NO];
        }
    } else {
        [self.lsSynShop visibal:YES];
        [self.lstNowStore visibal:NO];
        [self.lsRawUnitCostPrice visibal:NO];
    }

    self.TitExtendInfo.lblName.text = @"扩展信息";
    [self.txtShortCode initLabel:@"简码" withHit:nil isrequest:NO type:UIKeyboardTypeAlphabet];
    if (self.action == ACTION_CONSTANTS_ADD) {
        self.txtShortCode.delegate = self;
    }
    
    [self.txtShortCode initMaxNum:8];
    [self.lstUtit initLabel:@"单位" withHit:nil delegate:self];
    [self.txtSpell initLabel:@"拼音码" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.lsCategory initLabel:@"分类" withHit:nil delegate:self];
    [self.txtSpecification initLabel:@"规格" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtSpecification initMaxNum:50];
    [self.lsBrand initLabel:@"品牌" withHit:nil delegate:self];
    [self.txtOrigin initLabel:@"产地" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtOrigin initMaxNum:50];
    [self.lsPeriod initLabel:@"保质期(天)" withHit:nil isrequest:NO delegate:self];
    [self.imgGoods initLabel:@"商品图片" withHit:nil delegate:self];
    
    self.TitSaleSetting.lblName.text = @"销售设置";
    [self.lsSaleRoyaltyRatio initLabel:@"销售提成比例(%)" withHit:nil isrequest:YES delegate:self];
    [self.rdoIsJoinPoint initLabel:@"参与积分" withHit:nil];
    [self.rdoIsJoinActivity initLabel:@"参与任何优惠活动" withHit:nil];
    self.TitMicroSetting.lblName.text = @"微店设置";
    
    [self.lsMicroInfo initLabel:@"微店价、图片、介绍等设置" withHit:nil delegate:self];
    self.lsMicroInfo.imgMore.image = [UIImage imageNamed:@"ico_next"];
    self.lsMicroInfo.lblVal.placeholder = @"";
    [self.TitMicroSetting visibal:NO];
    [self.lsMicroInfo visibal:NO];
    
    //  机构不显示，门店和单店用户且有"微店-微店商品信息权限"来显示
    // 连锁总部登录有"微店-微店商品信息权限"来显示
    BOOL showWechatSet = NO;
    if (([[Platform Instance] getMicroShopStatus] == 2 && [[Platform Instance] getShopMode] != 3) && ![[Platform Instance] lockAct:ACTION_WEISHOP_GOODS]) {
        showWechatSet = YES;
    } else if ([[Platform Instance] isTopOrg] && ![[Platform Instance] lockAct:ACTION_WEISHOP_GOODS]) {
        showWechatSet = YES;
    }
    [self.TitMicroSetting visibal:showWechatSet];
    [self.lsMicroInfo visibal:showWechatSet];
    self.rdoStatus.tag = GOODS_EDIT_UPDOWNSTATUS;
    self.rdoIsInBulkGoods.tag = GOODS_EDIT_INBULKGOODS;
    self.lsMicroInfo.tag = GOODS_EDIT_MICROINFO;
    self.lsSynShop.tag = GOODS_EDIT_SYNSHOP;
    self.lsBrand.tag = GOODS_EDIT_BRAND;
    self.lsCategory.tag = GOODS_EDIT_CATEGORY;
    self.lsPurPrice.tag = GOODS_EDIT_PURPRICE;
    self.lsRetailPrice.tag = GOODS_EDIT_RETAILPRICE;
    self.lsMemberPrice.tag = GOODS_EDIT_MEMBERPRICE;
    self.lsWhoPrice.tag = GOODS_EDIT_WHOPRICE;
    self.lsSaleRoyaltyRatio.tag = GOODS_EDIT_RATIO;
    self.lsPeriod.tag = GOODS_EDIT_PERIOD;
    self.lstNowStore.tag = GOODS_EDIT_NOWSTORE;
    self.lsRawUnitCostPrice.tag = GOODS_EDIT_RAWUNITPRINCE;
    self.lstUtit.tag = GOODS_EDIT_UTIT;
    self.lstPriceModel.tag = TAG_LST_PRICE_MODE;
}

- (void)editItemText:(LSEditItemText *)editItemText textFieldDidEndEditing:(UITextField *)textField {
    if ([self.rdoIsInBulkGoods getVal]) {
        if (editItemText == self.txtShortCode) {
            if ([NSString isBlank:[self.txtBarcode getStrVal]]) {
                [self.txtBarcode initData:textField.text];
            }
            
        }
    }
}

//条形码点击扫一扫
- (void)showButtonTag:(NSInteger)tag {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_GoodsEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_ADD) {
         [self editTitle:[UIHelper currChange:self.container] act:self.action];
    } else {
         [self editTitle:[UIHelper currChange:self.container] act:self.action];
    }
}

#pragma mark - 条形码扫描
- (IBAction)clickScanBtn:(id)sender
{
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    if (self.action == ACTION_CONSTANTS_EDIT) {//编辑页面扫码不调用接口只读取条形码
        [self.txtBarcode changeData:scanString];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString* shopId = nil;
    if ([[Platform Instance] getShopMode] == 3) {
        shopId = [[Platform Instance] getkey:ORG_ID];
    } else {
        shopId = [[Platform Instance] getkey:SHOP_ID];
    }
    [_goodsService selectGoodsList:@"1" shopId:shopId searchCode:@"" barCode:scanString categoryId:@"" createTime:@"" validTypeList:nil completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf.txtGoodsName initData:nil];
        [weakSelf.txtBarcode initData:nil];
        NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[json objectForKey:@"goodsVoList"]]) {
            for (NSDictionary* dic in [json objectForKey:@"goodsVoList"]) {
                [goodsArray addObject:[GoodsVo convertToGoodsVo:dic]];
            }
        }
        self.searchStatus = [json objectForKey:@"searchStatus"];
        if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
            if (goodsArray.count > 0) {
                GoodsVo* vo = [goodsArray objectAtIndex:0];
                [weakSelf.goodsService selectGoodsDetail:shopId goodsId:vo.goodsId completionHandler:^(id json) {
    
                    weakSelf.addGoodsVo = [GoodsVo convertToGoodsVo:[json objectForKey:@"goodsVo"]];
                    [weakSelf clearDo];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
            } else {
                [weakSelf.txtBarcode changeData:scanString];
            }
        } else if ([[json objectForKey:@"searchStatus"] integerValue] == 0 ) {
            weakSelf.addGoodsVo = nil;
            [weakSelf clearDo];
            [weakSelf.txtBarcode changeData:scanString];
        } else {
            //            GoodsVo* vo = [goodsArray objectAtIndex:0];
            //            [_goodsService selectGoodsBaseInfo:vo.goodsId completionHandler:^(id json) {
            //                if (!(weakSelf)) {
            //                    return ;
            //                }
            //
            //                GoodsVo* tempVo = [GoodsVo convertToGoodsVo:[json objectForKey:@"goodsVo"]];
            //                if (tempVo != nil) {
            //                    _addGoodsVo = tempVo;
            //                }
            //                [weakSelf clearDo];
            //            } errorHandler:^(id json) {
            //                [AlertBox show:json];
            //            }];
            GoodsVo* vo = [goodsArray objectAtIndex:0];
            weakSelf.addGoodsVo = vo;
            [weakSelf clearDo];
        }
        [UIHelper refreshUI:weakSelf.container];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj.tag == GOODS_EDIT_MICROINFO) {
        self.viewTag = (int)obj.tag;
        [self onNavigateEvent:LSNavigationBarButtonDirectRight];
    } else if (obj.tag == GOODS_EDIT_SYNSHOP){
        //跳转页面至选择门店
        SelectOrgShopListView* selectOrgShopListView = [[SelectOrgShopListView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:selectOrgShopListView animated:NO];
        __weak typeof(self) wself = self;
        [selectOrgShopListView loadData:[wself.lsSynShop getStrVal] withModuleType:1 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
            [wself popViewController];
            if (item) {
                NSString *itemId = nil;
                if ([[item obtainItemId] isEqualToString:@"0"]) {
                    wself.synShopEntityId = @"0";
                    itemId = @"";
                } else {
                    itemId = [item obtainItemId];
                    wself.synShopEntityId = [item obtainShopEntityId];
                }
                [wself.lsSynShop changeData:[item obtainItemName] withVal:itemId];
                [UIHelper refreshUI:wself.container];
            }
        }];
    } else if (obj.tag == GOODS_EDIT_CATEGORY){
         __weak typeof(self) weakSelf = self;
        [_goodsService selectLastCategoryInfo:@"0" completionHandler:^(id json) {

            NSMutableArray* list = [json objectForKey:@"categoryList"];
            weakSelf.categoryList = [[NSMutableArray alloc] init];
            if (list != nil && list.count > 0) {
                for (NSDictionary* dic in list) {
                    [weakSelf.categoryList addObject:[CategoryVo convertToCategoryVo:dic]];
                }
            }
            [OptionPickerBox initData:[GoodsRender listCategoryList:weakSelf.categoryList isShow:NO] itemId:[obj getStrVal]];
            if (![[Platform Instance] lockAct:ACTION_CATEGORY_MANAGE]) {
                [OptionPickerBox showManager:obj.lblName.text managerName:@"分类管理" client:weakSelf event:obj.tag];
                [OptionPickerBox changeImgManager:@"ico_manage.png"];
            } else {
                [OptionPickerBox show:obj.lblName.text client:weakSelf event:obj.tag];
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else if (obj.tag == GOODS_EDIT_BRAND){
         __weak typeof(self) weakSelf = self;
        [_goodsService selectBrandList:^(id json) {

            NSMutableArray* list = [json objectForKey:@"goodsBrandList"];
            weakSelf.brandList = [[NSMutableArray alloc] init];
            if (list != nil && list.count > 0) {
                for (NSDictionary* dic in list) {
                    [weakSelf.brandList addObject:[GoodsBrandVo convertToGoodsBrandVo:dic]];
                }
            }
            [OptionPickerBox initData:[GoodsRender listBrandList:weakSelf.brandList]itemId:[obj getStrVal]];
            [OptionPickerBox showManager:obj.lblName.text managerName:@"品牌库管理" client:weakSelf event:obj.tag];
            [OptionPickerBox changeImgManager:@"ico_manage.png"];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else if (obj.tag == GOODS_EDIT_PURPRICE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    } else if (obj.tag == GOODS_EDIT_RETAILPRICE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    } else if (obj.tag == GOODS_EDIT_MEMBERPRICE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    } else if (obj.tag == GOODS_EDIT_WHOPRICE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    } else if (obj.tag == GOODS_EDIT_RATIO){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
    } else if (obj.tag == GOODS_EDIT_PERIOD){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
    } else if (obj.tag == GOODS_EDIT_NOWSTORE){
        //库存数
        [SymbolNumberInputBox initData:obj.lblVal.text];
        if ([self.rdoIsInBulkGoods getVal]) {//散称称重商品
            [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
            [SymbolNumberInputBox limitInputNumber:6 digitLimit:3];
        } else {
            [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
            [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        }
    } else if (obj.tag == GOODS_EDIT_UTIT){
        __weak typeof(self) weakSelf = self;
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
            [OptionPickerBox showManager:obj.lblName.text managerName:@"单位库管理" client:weakSelf event:obj.tag];
            [OptionPickerBox changeImgManager:@"ico_manage.png"];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else if (obj.tag == GOODS_EDIT_RAWUNITPRINCE) {
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    } else if (obj == self.lstPriceModel) {//计价方式
        NSMutableArray *list = [NSMutableArray array];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:@"计重" andId:@"1"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"计件" andId:@"2"];
        [list addObject:item];
        [OptionPickerBox initData:list itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == GOODS_EDIT_CATEGORY) {
        [self.lsCategory changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == GOODS_EDIT_BRAND){
        [self.lsBrand changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == GOODS_EDIT_UTIT){
        [self.lstUtit changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == TAG_LST_PRICE_MODE){//计价方式
        [self.lstPriceModel changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType==GOODS_EDIT_RETAILPRICE) {
        if ([NSString isBlank:val]) {
            val = nil;
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        [self.lsRetailPrice changeData:val withVal:val];
        //会员价不输入时默认零售价 参考进货价不输入时默认零售价
        if ([NSString isBlank:[self.lsMemberPrice getStrVal]]) {
            [self.lsMemberPrice changeData:val withVal:val];
        }
        if ([NSString isBlank:[self.lsWhoPrice getStrVal]]) {
            [self.lsWhoPrice changeData:val withVal:val];
        }
    }
    
    if (eventType==GOODS_EDIT_PURPRICE) {
        if ([NSString isBlank:val]) {
            val = nil;
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        [self.lsPurPrice changeData:val withVal:val];
        
    }else if (eventType==GOODS_EDIT_MEMBERPRICE) {
        if ([NSString isBlank:val]) {
            val = nil;
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        [self.lsMemberPrice changeData:val withVal:val];
        
    }else if (eventType==GOODS_EDIT_WHOPRICE) {
        if ([NSString isBlank:val]) {
            val = nil;
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        [self.lsWhoPrice changeData:val withVal:val];
        
    }else if (eventType==GOODS_EDIT_RATIO) {
        
        if (val.doubleValue>100.00) {
            
            [AlertBox show:@"销售提成比例(%)不能大于100.00，请重新输入!"];
            
        }else{
            if ([NSString isBlank:val]) {
                val = nil;
            } else {
                val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
            }
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        
        [self.lsSaleRoyaltyRatio changeData:val withVal:val];
    } else if (eventType == GOODS_EDIT_PERIOD) {
        
        if ([NSString isBlank:val]) {
            val = nil;
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
        }
        
        [self.lsPeriod changeData:val withVal:val];
    } else if (eventType == GOODS_EDIT_RAWUNITPRINCE) {
        [self.lsRawUnitCostPrice changeData:val withVal:val];
    } else if (eventType == GOODS_EDIT_NOWSTORE){
        if ([NSString isNotBlank:val]) {
            [self.lsRawUnitCostPrice initLabel:@"初始单位成本价(元)" withHit:nil isrequest:YES delegate:self];
        } else {
            [self.lsRawUnitCostPrice initLabel:@"初始单位成本价(元)" withHit:nil isrequest:NO delegate:self];
        }
        if ([NSString isBlank:val]) {//初始库存数清空时是可不填不是0
            [self.lstNowStore changeData:nil withVal:nil];
        } else {
            if ([self.rdoIsInBulkGoods getVal]) {//散称称重商品
                [self.lstNowStore changeData:[NSString stringWithFormat:@"%.3f", val.doubleValue] withVal:[NSString stringWithFormat:@"%.3f", val.doubleValue]];
            } else {
                [self.lstNowStore changeData:[NSString stringWithFormat:@"%d", val.intValue] withVal:[NSString stringWithFormat:@"%d", val.intValue]];
            }
        }
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)managerOption:(NSInteger)eventType
{
    if (eventType == GOODS_EDIT_CATEGORY) {
        GoodsCategoryListView* vc = [[GoodsCategoryListView alloc] initWithTag:GOODS_EDIT_CATEGORY];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
        __weak typeof(self) weakSelf = self;
        [vc loadDatasFromStyleEditView:^(int fromViewTag) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf onItemListClick:weakSelf.lsCategory];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    }else if (eventType == GOODS_EDIT_BRAND){
        //品牌管理
        GoodsAttributeManageListView* vc = [[GoodsAttributeManageListView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
        __weak typeof(self) weakSelf = self;
        [vc loadDatas:(int)eventType callBack:^(int fromViewTag) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf onItemListClick:weakSelf.lsBrand];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    } else if (eventType == GOODS_EDIT_UTIT){
        UnitInfoViewController *vc = [[UnitInfoViewController alloc] init];
        vc.delegate = self;
        [self pushViewController:vc];
    }
}

- (void)unitInfoViewClickDeleted:(LSGoodsUnitVo *)goodsUnit {
    if ([[self.lstUtit getStrVal] isEqualToString:goodsUnit.goodsUnitId]) {
        [self.lstUtit changeData:@"请选择" withVal:nil];
    }
}

- (void)unitInfoViewClickClosedBtn {
    [self onItemListClick:self.lstUtit];
}

#pragma mark - IEditItemRadioEvent 协议
// “关闭”、“开启” 按钮控制商品的上下架
- (void)onItemRadioClick:(LSEditItemRadio *)obj
{
    BOOL result = [[obj getStrVal] isEqualToString:@"1"];
    if (obj.tag == GOODS_EDIT_UPDOWNSTATUS) {
        self.rdoStatus.lblName.text = [self.rdoStatus getVal]?@"商品已上架":@"商品已下架";
        NSString *hit = [self.rdoStatus getVal] ? @"已上架的商品可以在各个平台显示及销售" : @"已下架的商品可以在收银设备显示，但是无法销售，在其他平台（微店等）上不显示";
        [self.rdoStatus initHit:hit];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } else if (obj.tag == GOODS_EDIT_INBULKGOODS) {//散装称重商品
        if (result) {
            self.txtShortCode.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"必须输入5位数字" attributes:@{NSForegroundColorAttributeName: [UIColor redColor] }];
        } else {
            self.txtShortCode.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"可不填" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] }];
        }
        [self.lstPriceModel visibal:result];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }
}

#pragma mark 导航栏
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        
        if (self.viewTag == GOODS_BATCH_CHOICE_VIEW1) {
            _goodsEditBack(NO);
        }
        
        if (self.action == ACTION_CONSTANTS_ADD) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LSGoodsListViewController class]]) {
                    LSGoodsListViewController *listView = (LSGoodsListViewController *)vc;
                    [listView.tableView headerBeginRefreshing];
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        }else {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LSGoodsInfoSelectViewController class]]) {
                    LSGoodsInfoSelectViewController *listView = (LSGoodsInfoSelectViewController *)vc;
                    [listView selectGoodsCount];
                }
            }
            
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        
        if (![self isValid]){
            return;
        }
        if ([self.rdoIsInBulkGoods getVal]) {
            //1.普通商品、2.拆分商品、3.组装商品、4.称重商品、5.原料商品、6:加工商品
            if (self.goodsVo.type == 2) {
                [AlertBox show:@"该商品是拆分商品，不能设置为散装称重商品。"];
                return;
            } else if (self.goodsVo.type == 3) {
                [AlertBox show:@"该商品是组装商品，不能设置为散装称重商品。"];
                return;
            } else if (self.goodsVo.type == 6) {
                [AlertBox show:@"该商品是加工商品，不能设置为散装称重商品。"];
                return;
            }
        }
        
        if (self.txtBarcode.isChange && [NSString isNotBlank:[self.txtBarcode getStrVal]]) {
            [self checkGoods];
        } else {
            [self save];
        }
    }
}

- (BOOL)isValid
{
    if ([NSString isBlank:[self.txtGoodsName getStrVal]]) {
        [AlertBox show:@"商品名称不能为空，请输入!"];
        return NO;
    }
    
    if (self.action == ACTION_CONSTANTS_EDIT && [NSString isBlank:[self.txtBarcode getStrVal]]) {
        [AlertBox show:@"条形码不能为空，请输入!"];
        return NO;
    }
    /*
     商超版商品添加时，输入的条形码有以下限制，请大家了解下：//编辑时条形码没有有修改的情况下也刻意保存
     1、条形码不能以200开头(因为条形码添加不输入时默认生成200开通的)
     2、当条形码输入13位时不能以21~29开头
     */
    NSString *txtBarCode = [self.txtBarcode getStrVal];
    if ((self.action == ACTION_CONSTANTS_ADD &&[NSString isNotBlank:txtBarCode]) || [self.txtBarcode isChange]) {
        if (txtBarCode.length >= 3 && [[txtBarCode substringToIndex:3] isEqualToString:@"200"]) {
            [AlertBox show:@"以200开头的条形码由系统自动生成，不能手动添加！"];
            return NO;
        }
        //        if (((txtBarCode.length == 13 || txtBarCode.length == 18) && [[txtBarCode substringToIndex:1] isEqualToString:@"2"]) &&( ![[txtBarCode substringToIndex:2] isEqualToString:@"20"])) {
        //            [AlertBox show:@"以21~29开头的13位或18位条形码用于收银机识别条码秤打印的条形码，不能作为商品的条形码添加！"];
        //            return NO;
        //        }
        
    }
    
    if ([NSString isBlank:[self.lsRetailPrice getStrVal]]) {
        [AlertBox show:@"零售价不能为空，请输入!"];
        return NO;
    }
    
    if ([[self.rdoIsInBulkGoods getStrVal] isEqualToString:@"1"] && [NSString isBlank:[self.txtShortCode getStrVal]]) {
        [AlertBox show:@"散装称重商品简码不能为空，请输入!"];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.txtShortCode getStrVal]] && [NSString isNotNumAndLetter:[self.txtShortCode getStrVal]]) {
        [AlertBox show:@"商品简码必须为英数字，请重新输入!"];
        return NO;
    }
    
    if ([[self.rdoIsInBulkGoods getStrVal] isEqualToString:@"1"] && [NSString isNotBlank:[self.txtShortCode getStrVal]] && !([NSString isValidNumber:[self.txtShortCode getStrVal]] && [self.txtShortCode getStrVal].length == 5)) {
        [AlertBox show:@"散装商品简码必须为5位数字，请重新输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsSaleRoyaltyRatio getStrVal]]) {
        [AlertBox show:@"销售提成比例(%)不能为空，请输入!"];
        return NO;
    }
    
    if (self.action == ACTION_CONSTANTS_ADD &&![self.rdoIsInBulkGoods getVal] && [[self.lstNowStore getStrVal] containsString:@"."]) {
        [AlertBox show:@"非散装称重商品的库存数只能输入整数！"];
        return NO;
    }
    
    return YES;
}

- (void)checkGoods
{
     __weak typeof(self) weakSelf = self;
    NSString* goodsId = nil;
    if (_action == ACTION_CONSTANTS_EDIT) {
        goodsId = _goodsVo.goodsId;
    } else if (self.action == ACTION_CONSTANTS_ADD) {
        if (_addGoodsVo != nil) {
            goodsId = _addGoodsVo.goodsId;
        }
    }
    //此处对条码去前后空格
    [_goodsService checkGoods:goodsId barcode:[[self.txtBarcode getStrVal] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] name:[self.txtGoodsName getStrVal] completionHandler:^(id json) {
        
        NSInteger result = [[json objectForKey:@"result"] integerValue];
        if (result == 0) {
            [weakSelf save];
        } else if (result == 1) {
            [AlertBox show:@"相同条形码的商品名称不能重复！"];
        } else if (result == 2) {
            static UIAlertView *alertView;
            if (alertView != nil) {
                [alertView dismissWithClickedButtonIndex:0 animated:NO];
                alertView = nil;
            }
            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入的条形码已经存在，是否继续添加一码多品的商品?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认" , nil];
            [alertView show];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self save];
    }
}

#pragma mark 保存
- (void)save
{
    __weak typeof(self) wself = self;
    
    if (self.imgGoods.isChange) {
        //存放图片对象
        NSMutableArray *imageVoList = [NSMutableArray array];
        //存放图片数据
        NSMutableArray *imageDataList = [NSMutableArray array];
        LSImageVo *imageVo = nil;
        LSImageDataVo *imageDataVo = nil;
        if ([NSString isNotBlank:self.imgGoods.oldVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.imgGoods.oldVal opType:2 type:@"goods"];
            [imageVoList addObject:imageVo];
        }
        if ([NSString isNotBlank:self.imgGoods.currentVal]) {
            imageVo = [LSImageVo imageVoWithFileName:self.imgGoods.currentVal opType:1 type:@"goods"];
            [imageVoList addObject:imageVo];
            NSData *data = UIImageJPEGRepresentation(self.imgGoods.img.image, 0.1);
            imageDataVo = [LSImageDataVo imageDataVoWithData:data file:self.imgGoods.currentVal];
            [imageDataList addObject:imageDataVo];
        }
        //上传图片
        [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];
    }
    
    if (self.action == ACTION_CONSTANTS_ADD) {
        if ([NSString isNotBlank:[self.lstNowStore getStrVal]] && [NSString isBlank:[self.lsRawUnitCostPrice getStrVal]]) {
            [AlertBox show:@"初始单位成本价(元)不能为空，请输入!"];
            return;
        }
        
        [self addData];
        [_goodsService saveGoodsDetail:[GoodsVo getDictionaryData:self.goodsVo] operateType:@"add" searchStatus:self.searchStatus completionHandler:^(id json) {
            [self saveCategoryNameAndCategoryId];
            if (_clickType == 1) {
                [wself clearDo];
                [wself.scrollView setContentOffset:CGPointMake(0, 0)animated:NO];
                _clickType = 0;
            } else {
                if (self.viewTag == GOODS_INFO_SELECT_VIEW) {
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LSGoodsInfoSelectViewController class]]) {
                            LSGoodsInfoSelectViewController *listView = (LSGoodsInfoSelectViewController *)vc;
                            [listView selectGoodsCount];
                        }
                    }
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                    [self.navigationController popViewControllerAnimated:NO];
                }else if (self.viewTag == GOODS_LIST_VIEW){
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LSGoodsListViewController class]]) {
                            LSGoodsListViewController *listView = (LSGoodsListViewController *)vc;
                            [listView loadDatasFromEdit:nil action:ACTION_CONSTANTS_ADD];
                        }
                    }
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                    [self.navigationController popViewControllerAnimated:NO];
                } else if (self.viewTag == GOODS_BATCH_CHOICE_VIEW1) {
                    _goodsEditBack(YES);
                } else if (self.viewTag == GOODS_EDIT_MICROINFO) {
                    wself.goodsId = json[@"goodsId"];
                    wself.action = ACTION_CONSTANTS_EDIT;
                    [wself loaddatas];
                    wself.viewTag = GOODS_LIST_VIEW;
                    WechatGoodsDetailsView *vc = [[WechatGoodsDetailsView alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsDetailsView"] bundle:nil];
                    vc.goodsId = json[@"goodsId"];
                    vc.shopId = wself.shopId;
                    vc.synShopEntityId = wself.synShopEntityId;
                    vc.action = ACTION_CONSTANTS_EDIT;
                    [wself.navigationController pushViewController:vc animated:NO];
                    [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                
                     [wself editTitle:NO act:wself.action];
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LSGoodsInfoSelectViewController class]]) {
                            LSGoodsInfoSelectViewController *listView = (LSGoodsInfoSelectViewController *)vc;
                            [listView selectGoodsCount];
                        }
                    }
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LSGoodsListViewController class]]) {
                            LSGoodsListViewController *listView = (LSGoodsListViewController *)vc;
                            [listView loadDatasFromEdit:nil action:ACTION_CONSTANTS_ADD];
                        }
                    }
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else {
        if (self.goodsVo.type == 1 || self.goodsVo.type == 4) {
            if ([self.rdoIsInBulkGoods getVal]) {
                self.goodsVo.type = 4;
            } else if (![self.rdoIsInBulkGoods getVal]) {
                self.goodsVo.type = 1;
            }
        }
        int upDownStatus = [self.rdoStatus getStrVal].intValue == 1 ? 1 : 2;
        self.goodsVo.upDownStatus = upDownStatus;
        //此处对条码去前后空格
        self.goodsVo.barCode = [[self.txtBarcode getStrVal] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.goodsVo.innerCode = [self.txtInnerCode getStrVal];
        self.goodsVo.goodsName = [self.txtGoodsName getStrVal];
        //不在上传参考进货价
//        if (![NSString isBlank:[self.lsPurPrice getStrVal]]) {
//            self.goodsVo.purchasePrice = [self.lsPurPrice getStrVal].doubleValue;
//        }
        self.goodsVo.retailPrice = [self.lsRetailPrice getStrVal].doubleValue;
        //会员价不输入时默认零售价
        if ([NSString isNotBlank:[self.lsMemberPrice getStrVal]]) {
            self.goodsVo.memberPrice = [self.lsMemberPrice getStrVal].doubleValue;
        } else {
            self.goodsVo.memberPrice = self.goodsVo.retailPrice;
        }
        //批发价不输入时默认零售价
        if ([NSString isNotBlank:[self.lsWhoPrice getStrVal]]) {
            self.goodsVo.wholesalePrice = [self.lsWhoPrice getStrVal].doubleValue;
        } else {
            self.goodsVo.wholesalePrice = self.goodsVo.retailPrice;
        }
        if ([[Platform Instance] getShopMode] == 3) {
            if ([[self.lsSynShop getStrVal] isEqualToString:@"0"]) {
                self.goodsVo.synShopId = @"";
            }else{
                self.goodsVo.synShopId = [self.lsSynShop getStrVal];
            }
        }
        //计价方式
        self.goodsVo.priceType = [[self.lstPriceModel getStrVal] integerValue];
        self.goodsVo.shortCode = [self.txtShortCode getStrVal];
        if (![NSString isBlank:[self.lsCategory getStrVal]] && [[self.lsCategory getStrVal] isEqualToString:@"-1"]) {
            self.goodsVo.categoryId = @"";
        }else{
            self.goodsVo.categoryId = [self.lsCategory getStrVal];
            if (![[self.lsCategory getDataLabel] isEqualToString:@"请选择"]) {
                self.goodsVo.categoryName = [self.lsCategory getDataLabel];
            }
        }
        if (![[self.lstUtit getDataLabel] isEqualToString:@"请选择"]) {
            self.goodsVo.unitName = [self.lstUtit getDataLabel];
        }
        self.goodsVo.unitId = [self.lstUtit getStrVal];
        self.goodsVo.specification = [self.txtSpecification getStrVal];
        self.goodsVo.brandId = [self.lsBrand getStrVal];
        if (![[self.lsBrand getDataLabel] isEqualToString:@"请选择"]) {
            self.goodsVo.brandName = [self.lsBrand getDataLabel];
        }
        
        self.goodsVo.origin = [self.txtOrigin getStrVal];
        if (![NSString isBlank:[self.lsPeriod getStrVal]]) {
            self.goodsVo.period = [NSNumber numberWithInt:[self.lsPeriod getStrVal].intValue];
        } else {
            self.goodsVo.period = nil;
        }
        if (![NSString isBlank:[self.lsSaleRoyaltyRatio getStrVal]]) {
            self.goodsVo.percentage = [self.lsSaleRoyaltyRatio getStrVal].doubleValue;
        }
        self.goodsVo.isSales = [NSNumber numberWithInt:[self.rdoIsJoinActivity getStrVal].intValue];
        self.goodsVo.hasDegree = [NSNumber numberWithInt:[self.rdoIsJoinPoint getStrVal].intValue];
        
        if ([NSString isBlank:self.goodsVo.fileName]&&[NSString isBlank:[self.imgGoods getImageFilePath]]) {
            self.goodsVo.fileDeleteFlg = @"1";//删除
            self.goodsVo.filePath = nil;
        } else if([NSString isNotBlank:[self.imgGoods getImageFilePath]] &&
                  ![self.goodsVo.fileName isEqualToString:[self.imgGoods getImageFilePath]]) {
            self.goodsVo.fileDeleteFlg = @"0";//替换
            self.goodsVo.fileName = self.imgFilePathTemp;
        }

        
        [_goodsService saveGoodsDetail:[GoodsVo getDictionaryData:self.goodsVo] operateType:@"edit" searchStatus:self.searchStatus completionHandler:^(id json) {
            [self saveCategoryNameAndCategoryId];
            if (self.viewTag == GOODS_LIST_VIEW) {
                for (UIViewController *vc in wself.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LSGoodsListViewController class]]) {
                        wself.goodsVo.image = wself.imgGoods.img.image;
                        LSGoodsListViewController *listView = (LSGoodsListViewController *)vc;
                        [listView loadDatasFromEdit:wself.goodsVo action:ACTION_CONSTANTS_EDIT];
                    }
                }
                [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [wself.navigationController popViewControllerAnimated:NO];
            }else if (wself.viewTag == GOODS_INFO_SELECT_VIEW){
                [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [wself.navigationController popViewControllerAnimated:NO];
            } else if (self.viewTag == GOODS_EDIT_MICROINFO) {
                wself.viewTag = GOODS_LIST_VIEW;
                [wself loaddatas];
                WechatGoodsDetailsView *vc = [[WechatGoodsDetailsView alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsDetailsView"] bundle:nil];
                vc.goodsId = wself.goodsId;
                vc.synShopEntityId = wself.synShopEntityId;
                vc.shopId = wself.shopId;
                vc.action = ACTION_CONSTANTS_EDIT;
                [wself.navigationController pushViewController:vc animated:NO];
                [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
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

// 添加商品信息，生成新的商品信息对象
- (void)addData {
    
    self.goodsVo = [[GoodsVo alloc] init];
    //计价方式
    self.goodsVo.priceType = [[self.lstPriceModel getStrVal] integerValue];
    int upDownStatus = [self.rdoStatus getStrVal].intValue == 1 ? 1 : 2;
    self.goodsVo.upDownStatus = upDownStatus;
    //此处对条码去前后空格
    self.goodsVo.barCode = [[self.txtBarcode getStrVal] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.goodsVo.goodsName = [self.txtGoodsName getStrVal];
    if ([NSString isNotBlank:self.lstNowStore.lblVal.text]) {
        self.goodsVo.nowStore = [NSNumber numberWithDouble:self.lstNowStore.lblVal.text.doubleValue];
    } else {
        // “初始库存数” 、“初始单位成本价”若不填，默认为0
        self.goodsVo.nowStore = nil;
    }
    
    if ([NSString isNotBlank:self.lsRawUnitCostPrice.lblVal.text]) {
       
        self.goodsVo.powerPrice = @([[self.lsRawUnitCostPrice getDataLabel] doubleValue]);
    } else {
        // “初始库存数” 、“初始单位成本价”若不填，默认为0
        self.goodsVo.powerPrice = nil;
    }
    
    if ([[self.rdoIsInBulkGoods getStrVal] isEqualToString:@"0"]) {
        self.goodsVo.type = 1;
    } else {
        self.goodsVo.type = 4;
    }
    //不再上传参考进货价
//    if (![NSString isBlank:[self.lsPurPrice getStrVal]]) {
//        self.goodsVo.purchasePrice = [self.lsPurPrice getStrVal].doubleValue;
//    }
    //添加商品、商品详情页面，输入零售价后焦点离开，如果会员价、批发价未输入则默认将零售价设置到会员价、批发价中；
    //保存数据时，如果会员价、批发价未输入，默认将零售价设置到会员价和批发价中进行保存。
    
    //零售价
    self.goodsVo.retailPrice = [self.lsRetailPrice getStrVal].doubleValue;
    
    //会员价不输入时默认零售价
    if ([NSString isNotBlank:[self.lsMemberPrice getStrVal]]) {
        self.goodsVo.memberPrice = [self.lsMemberPrice getStrVal].doubleValue;
    } else {
        self.goodsVo.memberPrice = self.goodsVo.retailPrice;
    }
    //批发价不输入时默认零售价
    if ([NSString isNotBlank:[self.lsWhoPrice getStrVal]]) {
        self.goodsVo.wholesalePrice = [self.lsWhoPrice getStrVal].doubleValue;
    } else {
        self.goodsVo.wholesalePrice = self.goodsVo.retailPrice;
    }
    if ([[Platform Instance] getShopMode] == 3) {
        if ([[self.lsSynShop getStrVal] isEqualToString:@"0"]) {
            self.goodsVo.synShopId = @"";
        }else{
            self.goodsVo.synShopId = [self.lsSynShop getStrVal];
        }
    }
    self.goodsVo.shortCode = [self.txtShortCode getStrVal];
    self.goodsVo.categoryId = [self.lsCategory getStrVal];
    if (![[self.lsCategory getDataLabel] isEqualToString:@"请选择"]) {
        self.goodsVo.categoryName = [self.lsCategory getDataLabel];
    }
    if (![[self.lstUtit getDataLabel] isEqualToString:@"请选择"]) {
        self.goodsVo.unitName = [self.lstUtit getDataLabel];
    }
    self.goodsVo.unitId = [self.lstUtit getStrVal];
    
    
    self.goodsVo.specification = [self.txtSpecification getStrVal];
    self.goodsVo.brandId = [self.lsBrand getStrVal];
    if (![[self.lsBrand getDataLabel] isEqualToString:@"请选择"]) {
        self.goodsVo.brandName = [self.lsBrand getDataLabel];
    }
    self.goodsVo.origin = [self.txtOrigin getStrVal];
    if (![NSString isBlank:[self.lsPeriod getStrVal]]) {
        self.goodsVo.period = [NSNumber numberWithInt:[self.lsPeriod getStrVal].intValue];;
    } else {
        self.goodsVo.period = nil;
    }
    
    if (![NSString isBlank:[self.lsSaleRoyaltyRatio getStrVal]]) {
        self.goodsVo.percentage = [self.lsSaleRoyaltyRatio getStrVal].doubleValue;
    }
    
    self.goodsVo.isSales = [NSNumber numberWithInt:[self.rdoIsJoinActivity getStrVal].intValue];
    self.goodsVo.hasDegree = [NSNumber numberWithInt:[self.rdoIsJoinPoint getStrVal].intValue];
    
    if ([NSString isNotBlank:self.goodsVo.fileName]&&[NSString isBlank:[self.imgGoods getImageFilePath]]) {
        
        self.goodsVo.fileDeleteFlg = @"0";
        
    } else if ([NSString isNotBlank:[self.imgGoods getImageFilePath]] &&
               ![self.goodsVo.fileName isEqualToString:[self.imgGoods getImageFilePath]]) {
        
        self.goodsVo.fileDeleteFlg = @"1";
        self.goodsVo.fileName = self.imgFilePathTemp;
    }
}


- (void)btnDelClick {
    
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",self.goodsVo.goodsName]];
    } else {
        
        if (![self isValid]) { return; }
        self.addGoodsVo = nil;
        [self checkGoods];
        _clickType = 1;
    }
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0) {
        if (self.action == ACTION_CONSTANTS_EDIT) {
            if ([NSString isBlank:_goodsVo.goodsId]) { return; }
            NSMutableArray* goodsIdList = [[NSMutableArray alloc] init];
            [goodsIdList addObject:self.goodsVo.goodsId];
             __weak typeof(self) weakSelf = self;
            [_goodsService deleteGoods:goodsIdList shopId:self.shopId completionHandler:^(id json) {
                [weakSelf delFinish];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
}

- (void)saveFinish {
    [self loaddatas];
}

- (void)delFinish {
    
    if (self.viewTag == GOODS_INFO_SELECT_VIEW) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LSGoodsInfoSelectViewController class]]) {
                LSGoodsInfoSelectViewController *listView = (LSGoodsInfoSelectViewController *)vc;
                [listView selectGoodsCount];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else if (self.viewTag == GOODS_LIST_VIEW) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LSGoodsListViewController class]]) {
                LSGoodsListViewController *listView = (LSGoodsListViewController *)vc;
                [listView loadDatasFromEdit:self.goodsVo action:ACTION_CONSTANTS_DEL];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)onConfirmImgClick:(NSInteger)btnIndex {
    
    if (btnIndex==1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
    } else if(btnIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [self dismissViewControllerAnimated:YES completion:nil];
    //添加到集合中
    self.goodsImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *goodsId = _goodsVo.goodsId;
    if ([NSString isBlank:goodsId]) {//上传图片路径 如果是编辑则取goodsId 如果是添加则随机上传
        goodsId = [NSString getUniqueStrByUUID];
    }
    NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", goodsId, [NSString getUniqueStrByUUID]];
    self.imgFilePathTemp = filePath;
    [self uploadImgFinsh];
}

- (void)onDelImgClick
{
    // 设定图片为nil
    self.goodsImage = nil;
    // 设定文件名为nil
    self.imgFilePathTemp = nil;
    self.goodsVo.fileName = nil;
    [self.imgGoods changeImg:self.imgFilePathTemp img:self.goodsImage];
    // 调用改变图片方法
}

- (void)uploadImgFinsh
{
    [self.imgGoods changeImg:self.imgFilePathTemp img:self.goodsImage];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

@end
