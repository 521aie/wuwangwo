//
//  GoodsMicroEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatGoodsDetailsView.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "FooterListView.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "EditItemRadio2.h"
#import "EditItemText.h"
#import "ItemTitle.h"
#import "EditImageBox.h"
#import "MicroGoodsVo.h"
#import "GoodsModuleEvent.h"
#import "UIView+Sizes.h"
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AlertBox.h"
#import "GoodsPicturesView.h"
#import "OptionPickerBox.h"
#import "GoodsRender.h"
#import "INameItem.h"
#import "AlertBox.h"
#import "Platform.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "MicroGoodsImageVo.h"
#import "SymbolNumberInputBox.h"
#import "ColorHelper.h"
#import "EditItemMemo.h"
//#import "MemoInputBox.h"
#import "MemoInputView.h"
#import "ImageUtils.h"
#import "LSImageDataVo.h"
#import "LSImageVo.h"
#import "SelectImgItem.h"
#import "ObjectUtil.h"
#import "LSWechatGoodListViewController.h"
#import "LSWechatGoodManageViewController.h"
#import "NameItemVO.h"
#import "TZImagePickerController.h"
#import "NavigateTitle2.h"
#import "FooterListEvent.h"


//微店商品详情编辑页面设置
#define STYLE_MICRO_EDIT_ISSALE 1
//#define STYLE_MICRO_EDIT_ISUPDOWNSTATUS 2 // 微店上下架
#define STYLE_MICRO_EDIT_PICTUREINFO 3
#define STYLE_MICRO_EDIT_SALESSTRATEGY 5
#define STYLE_MICRO_EDIT_PRIORITY 6
#define STYLE_MICRO_EDIT_DISCOUNT 7
#define STYLE_MICRO_EDIT_CUSTOMWAY 8
#define STYLE_MICRO_MEMO_DETAILS 10

@interface WechatGoodsDetailsView ()<AlertBoxClient, INavigateEvent, OptionPickerClient,IEditItemRadioEvent, IEditItemListEvent, FooterListEvent, IEditItemImageEvent, SymbolNumberInputClient, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,IEditItemMemoEvent,MemoInputClient, TZImagePickerControllerDelegate>{
    UICollectionView *_collectionView;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    CGFloat _itemWH;
    CGFloat _margin;
    NSMutableArray *filePathList;
    UIImage *goodsImage;
    UIImagePickerController *imagePickerController;
}
@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, weak) IBOutlet FooterListView *footView;
//是否在微店销售
@property (nonatomic, strong) IBOutlet EditItemRadio2 *rdoIsSale;
//基本信息
@property (nonatomic, strong) IBOutlet ItemTitle *TitBaseInfo;
//商品品牌
//优先度
@property (nonatomic, strong) IBOutlet EditItemList *lsPriority;
//商品条码
@property (nonatomic, strong) IBOutlet EditItemText *txtBarcode;
//商品名称
@property (weak, nonatomic) IBOutlet EditItemMemo *txtGoodsName;

//零售价
@property (nonatomic, strong) IBOutlet EditItemText *txtRetailPrice;
//微店售价策略
@property (nonatomic, strong) IBOutlet EditItemList *lsSalesStrategy;
//折扣
@property (nonatomic, strong) IBOutlet EditItemList *lsDiscount;
//微店价
@property (nonatomic, strong) IBOutlet EditItemList *lsWeixinPrice;
//扩展信息
@property (nonatomic, strong) IBOutlet ItemTitle *TitExtendInfo;
//详情介绍
@property (weak, nonatomic) IBOutlet EditItemMemo *txtDetails;

//图文详情
@property (nonatomic, strong) IBOutlet ItemTitle *TitPictureInfo;
//图文详情
@property (nonatomic, strong) IBOutlet EditItemList *lsPictureInfo;
//图片
@property (nonatomic, strong) IBOutlet EditImageBox *boxPicture;
/**
 *  微店售价策略数据源
 */
@property (nonatomic, strong) NSMutableArray *microSaleStrategyList;
@property (nonatomic, strong) NSString* imgFilePathTemp;
@property (nonatomic, assign) int viewTag;
@property (nonatomic, strong) NSMutableArray* categoryList;
@property (nonatomic, strong) NSMutableArray* brandList;
@property (nonatomic, strong) MicroGoodsVo *microGoodsVo;

@property (nonatomic, strong) WechatService *wechatService;
@property (nonatomic, strong) GoodsService *goodsService;/*<商品信息管理相关的请求封装>*/
@property (nonatomic, strong) GoodsPicturesView *goodsPictureView;
/**关联图片和数据*/
@property (nonatomic, copy) NSString *unid;
/** <#注释#> */
@property (nonatomic, copy) NSString *token;
/**
 *  YES 在微店销售
 *  NO 不在微店销售
 */
@property (nonatomic) BOOL flg;
@property (nonatomic) BOOL isSave;
/** <商品在店铺的上下架状态>
 *  1 上架 2 下架
 */
@property (nonatomic, assign) NSInteger goodsUpDownStatus;
@end
@implementation WechatGoodsDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    filePathList = [NSMutableArray array];

    self.wechatService = [ServiceFactory shareInstance].wechatService;
    self.goodsService = [ServiceFactory shareInstance].goodsService;
    [self initNotifaction];
    [self initNavigate];
    [self initMainView];
    [self getGoodDetailInfo];
    [self.footView initDelegate:self btnArrs:@[]];
    [UIHelper clearColor:self.container];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [self loadData];
}


#pragma mark - 初始化标题栏
- (void)initNavigate {
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"微店商品详情" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

#pragma mark - 导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_RIGHT) {
        [self save];
    } else {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - 初始化数据
- (void)initMainView {
    
    [self.rdoIsSale initLabel:@"在微店销售" withHit:@"在微店显示" delegate:self];
    self.TitBaseInfo.lblName.text = @"基本信息";
    
    [self.txtBarcode initLabel:@"商品条码" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtBarcode.txtVal.textColor = [UIColor grayColor];
    [self.txtBarcode editEnabled:NO];
    
    [self.txtGoodsName initLabel:@"商品名称" isrequest:NO delegate:self];
    [self.txtGoodsName editEnable:NO];
    
    [self.txtRetailPrice initLabel:@"零售价(元)" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtRetailPrice editEnabled:NO];
    self.txtRetailPrice.txtVal.textColor = [UIColor grayColor];
    [self.lsPriority initLabel:@"优先度" withHit:@"提示：优先度数值越小，在微店中显示越靠前" isrequest:YES delegate:self];
    [self.lsPriority visibal:YES];
    [self.lsSalesStrategy initLabel:@"微店售价策略" withHit:nil delegate:self];
    [self.lsDiscount initLabel:@"• 折扣率(%)" withHit:nil isrequest:YES delegate:self];
    [self.lsWeixinPrice initLabel:@"• 微店售价(元)" withHit:nil isrequest:NO delegate:self];
    
    self.TitExtendInfo.lblName.text = @"扩展信息";
    //商品名称和详情介绍不需要编辑，因此不需要开启代理方法，若要开启代理方法（需要进行编辑），则设置delegate：self即可
    [self.txtDetails initLabel:@"详情介绍" isrequest:NO delegate:self];
    [self.boxPicture initLabel:@"商品图片" delegate:self];
    [self.boxPicture initImgList:nil];
    self.TitPictureInfo.lblName.text = @"图文详情";
    [self.lsPictureInfo initLabel:@"图文详情" withHit:nil delegate:self];
    self.lsPictureInfo.lblVal.placeholder = @"";
    [self.lsPictureInfo.imgMore setImage:[UIImage imageNamed:@"ico_next"]];

    self.rdoIsSale.tag = STYLE_MICRO_EDIT_ISSALE;
    self.lsPictureInfo.tag = STYLE_MICRO_EDIT_PICTUREINFO;
    self.lsSalesStrategy.tag = STYLE_MICRO_EDIT_SALESSTRATEGY;
    self.lsPriority.tag = STYLE_MICRO_EDIT_PRIORITY;
    self.lsDiscount.tag = STYLE_MICRO_EDIT_DISCOUNT;
    self.lsWeixinPrice.tag = GOODS_MICRO_EDIT_WEIXINPRICE;
    self.txtDetails.tag = STYLE_MICRO_MEMO_DETAILS;
}

#pragma mark - 获取微店商品详情
- (void)loadData {
    NSString *url = @"microGoods/goodsDetail";
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:self.shopId forKey:@"shopId"];
    [param setValue:self.goodsId forKey:@"goodsId"];
    __weak WechatGoodsDetailsView *weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        weakSelf.microGoodsVo = [MicroGoodsVo convertToMicroGoodsVo:[json objectForKey:@"microGoodsVo"]];
        [weakSelf fillModel];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


#pragma mark - 网络数据显示
- (void)fillModel {
   
    self.unid = self.microGoodsVo.goodsId;
    //微店价格、折扣显示
    if (self.microGoodsVo.salesStrategy == 1) {
        [self.lsDiscount visibal:NO];
        [self.lsWeixinPrice visibal:NO];
    } else if (self.microGoodsVo.salesStrategy == 2) {
        [self.lsDiscount visibal:YES];
        [self.lsWeixinPrice visibal:YES];
    } else if (self.microGoodsVo.salesStrategy == 3) {
        [self.lsDiscount visibal:NO];
        [self.lsWeixinPrice visibal:YES];
    } else {
        [self.lsDiscount visibal:NO];
        [self.lsWeixinPrice visibal:NO];
    }
    
    //是否在微店中销售
    if ([self.microGoodsVo.isSale isEqualToString:@"2"]) {
        _flg = YES;
        [self.rdoIsSale initData:@"1"];
        self.rdoIsSale.lblName.text = @"在微店中销售";
        [self.rdoIsSale initHit:@"在微店中显示"];
        [self showMicroInfo:YES];
    } else {
        _flg = NO;
        [self.rdoIsSale initData:@"0"];
        self.rdoIsSale.lblName.text = @"未在微店中销售";
        [self.rdoIsSale initHit:@"未在微店中显示 "];
        [self showMicroInfo:NO];
    }
    
    if ([ObjectUtil isNotNull:self.microGoodsVo.priority]) {
        [self.lsPriority initData:[NSString stringWithFormat:@"%ld",self.microGoodsVo.priority.integerValue] withVal:[NSString stringWithFormat:@"%ld",self.microGoodsVo.priority.integerValue]];
    } else {
        [self.lsPriority initData:@"99" withVal:@"99"];
    }
    
    [self.txtBarcode initData:self.microGoodsVo.barcode];
    [self.txtGoodsName initData:self.microGoodsVo.goodsName];
    [self.txtRetailPrice initData:[NSString stringWithFormat:@"%.2f", self.microGoodsVo.retailPrice]];
    //第一次商品变成微店商品时微店售价策略是没有的需要取默认值实体店零售价
    self.microGoodsVo.salesStrategy = self.microGoodsVo.salesStrategy == 0 ? 1 : self.microGoodsVo.salesStrategy;
    NSString *salesStrategyId = [NSString stringWithFormat:@"%d", self.microGoodsVo.salesStrategy];
    [self.lsSalesStrategy initData:[self microSaleStrategyName:salesStrategyId] withVal:salesStrategyId];
    [self.lsDiscount initData:[NSString stringWithFormat:@"%.2f", self.microGoodsVo.weixinDiscount] withVal:[NSString stringWithFormat:@"%.2f", self.microGoodsVo.weixinDiscount]];
    [self.lsWeixinPrice initData:[NSString stringWithFormat:@"%.2f", self.microGoodsVo.weixinPrice] withVal:[NSString stringWithFormat:@"%.2f", self.microGoodsVo.weixinPrice]];
    if (self.microGoodsVo.mainImageVoList != nil && self.microGoodsVo.mainImageVoList.count > 0) {
        [self.boxPicture initImgList:self.microGoodsVo.mainImageVoList];
    } else {
        [self.boxPicture initImgList:nil];
    }
    [filePathList addObjectsFromArray:[self.boxPicture getFilePathList]];
    [self.txtDetails initData:self.microGoodsVo.details];
    
    // 默认开微店修改：
    if (_action == ACTION_CONSTANTS_EDIT && (!([[Platform Instance] isTopOrg] || [[Platform Instance] getShopMode] == 1))) {
        [self.boxPicture imageBoxUneditable];
        self.boxPicture.userInteractionEnabled = NO;
        [self.txtDetails editEnable:NO];
    }
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

// “在微店中销售” 开关变化后调用
- (void)showMicroInfo:(BOOL)flg {
    
    if (flg) {
        //在微店中销售
        [self.TitBaseInfo visibal:YES];
        [self.lsPriority visibal:YES];
        [self.txtBarcode visibal:YES];
        [self.txtRetailPrice visibal:YES];
        [self.lsSalesStrategy visibal:YES];
        if (self.microGoodsVo.salesStrategy == 1) {
            [self.lsDiscount visibal:NO];
            [self.lsWeixinPrice visibal:NO];
        } else if (self.microGoodsVo.salesStrategy == 2) {
            [self.lsDiscount visibal:YES];
            [self.lsWeixinPrice visibal:YES];
        } else if (self.microGoodsVo.salesStrategy == 3) {
            [self.lsDiscount visibal:NO];
            [self.lsWeixinPrice visibal:YES];
        } else {
            [self.lsDiscount visibal:NO];
            [self.lsWeixinPrice visibal:NO];
        }
        [self.TitExtendInfo visibal:YES];
        [self.txtDetails visibal:YES];
        [self.boxPicture setHidden:NO];
        [self.TitPictureInfo visibal:YES];
        [self.lsPictureInfo visibal:YES];
        [self.txtGoodsName visibal:YES];
    } else {
        //未在微店中销售
        [self.TitBaseInfo visibal:NO];
        [self.lsPriority visibal:NO];
        [self.txtBarcode visibal:NO];
        [self.txtRetailPrice visibal:NO];
        [self.lsSalesStrategy visibal:NO];
        [self.lsDiscount visibal:NO];
        [self.lsWeixinPrice visibal:NO];
        [self.TitExtendInfo visibal:NO];
        [self.txtDetails visibal:NO];
        [self.boxPicture setHidden:YES];
        [self.TitPictureInfo visibal:NO];
        [self.lsPictureInfo visibal:NO];
        [self.txtGoodsName visibal:NO];
    }
}

#pragma mark - 代理事件
-(void)onItemListClick:(EditItemList *)obj {
    
    if (obj.tag == STYLE_MICRO_EDIT_PICTUREINFO) {
     
        GoodsPicturesView *goodsPicturesView = [[GoodsPicturesView alloc]initWithNibName:[SystemUtil getXibName:@"GoodsPicturesView"] bundle:nil];
        goodsPicturesView.action = ACTION_CONSTANTS_EDIT;
        goodsPicturesView.microGoodsVo = [Wechat_MircoGoodsVo convertToMicroGoodsVo:[self.microGoodsVo toDictionary]];
        goodsPicturesView.shopId = self.shopId;
        goodsPicturesView.goodsId = self.goodsId;
        [self.navigationController pushViewController:goodsPicturesView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
  
    } else if (obj.tag == STYLE_MICRO_EDIT_SALESSTRATEGY) {
    
        [OptionPickerBox initData:self.microSaleStrategyList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    
    } else if (obj.tag == STYLE_MICRO_EDIT_PRIORITY) {
        
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:2 digitLimit:0];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
    
    } else if (obj.tag == STYLE_MICRO_EDIT_DISCOUNT) {
      
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
    
    } else if (obj == self.lsWeixinPrice) {
        
        //微店售价
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
    }
}

- (void)managerOption:(NSInteger)eventType {
    
    if (eventType == STYLE_MICRO_EDIT_SALESSTRATEGY) {
        [self.lsSalesStrategy initData:@"请选择" withVal:@""];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == STYLE_MICRO_EDIT_SALESSTRATEGY) {
        [self.lsSalesStrategy changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemId] isEqualToString:@"1"]) {
            [self.lsDiscount visibal:NO];
            [self.lsWeixinPrice visibal:NO];
        } else if ([[item obtainItemId] isEqualToString:@"2"]) {
            [self.lsDiscount visibal:YES];
            [self.lsWeixinPrice visibal:YES];
            [self.lsDiscount initData:nil withVal:nil];
//            [self.lsDiscount changeData:@"0.00" withVal:@""];
            [self.lsWeixinPrice changeData:@"0.00" withVal:@""];
        } else if ([[item obtainItemId] isEqualToString:@"3"]) {
            [self.lsDiscount visibal:NO];
            [self.lsWeixinPrice visibal:YES];
            [self.lsWeixinPrice changeData:[self.txtRetailPrice getStrVal] withVal:[self.txtRetailPrice getStrVal]];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
    if (val.doubleValue >= 999999.99) {
        val = @"999999.99";
    } else {
        val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
    }
    
    if (eventType == GOODS_MICRO_EDIT_WEIXINPRICE) {
        
//        if (val.doubleValue > self.microGoodsVo.retailPrice) {
//            val = [NSString stringWithFormat:@"%.2f",self.microGoodsVo.retailPrice];
//        }
        [self.lsWeixinPrice changeData:val withVal:val];
        [self.lsDiscount changeData:[NSString stringWithFormat:@"%.2f", [self.lsWeixinPrice getStrVal].doubleValue/self.microGoodsVo.retailPrice*100] withVal:[NSString stringWithFormat:@"%.2f", [self.lsWeixinPrice getStrVal].doubleValue/self.microGoodsVo.retailPrice*100]];
    }
    
    if (eventType == STYLE_MICRO_EDIT_PRIORITY) {
        
        if (val.intValue > 99) {
            val = @"99";
        } else {
            val = [NSString stringWithFormat:@"%d",val.intValue];
        }
        [self.lsPriority changeData:val withVal:val];
    } else if (eventType == STYLE_MICRO_EDIT_DISCOUNT) {

        if (val.doubleValue > 100.00) {
            val = @"100.00";
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        [self.lsDiscount changeData:val withVal:val];
        [self.lsWeixinPrice changeData:[NSString stringWithFormat:@"%.2f", self.microGoodsVo.retailPrice*val.doubleValue/100.00] withVal:[NSString stringWithFormat:@"%.2f", self.microGoodsVo.retailPrice*val.doubleValue/100.00]];
    }
    
}

//param mark add to solve input below
- (void)onItemMemoListClick:(EditItemMemo *)obj {
    
    if (obj.tag == STYLE_MICRO_MEMO_DETAILS) {
        
        MemoInputView *inputView = [[MemoInputView alloc] init];
        [inputView limitShow:obj.tag delegate:self title:@"详情介绍" val:[self.txtDetails getStrVal] limit:255];
        [self.navigationController pushViewController:inputView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    }
}

//完成Memo输入.
- (void)finishInput:(int)event content:(NSString *)content {
    
    if (event == STYLE_MICRO_MEMO_DETAILS ) {
        [self.txtDetails changeData:content];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


- (void)onItemRadioClick:(EditItemRadio *)obj {
    
    // 请求商品 在实体店的详情信息，查看是否下架
    if (obj.tag == STYLE_MICRO_EDIT_ISSALE) {
        if ([obj getVal]) {//在微店中销售开关打开
            if (self.goodsUpDownStatus == 2) {
                [AlertBox show:@"在商品详情中设为已下架的商品不能再微店中销售" client:self]; return;
            }
            
            [self showMicroInfo:YES];
            self.rdoIsSale.lblName.text = @"在微店销售";
            [self.rdoIsSale initHit:@"在微店中显示"];
        } else {
            self.rdoIsSale.lblName.text = @"未在微店销售";
            [self.rdoIsSale initHit:@"未在微店中显示"];
            [self showMicroInfo:NO];
        }
    }
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}



// 详情保存
- (void)save {
    
    
    __weak WechatGoodsDetailsView* weakSelf = self;
//    if (self.action == ACTION_CONSTANTS_EDIT) {
    
        if ([self.lsSalesStrategy getStrVal].intValue == 2) {
            if([NSString isBlank:[self.lsDiscount getStrVal]] && !self.lsDiscount.hidden) {
                [AlertBox show:@"请输入折扣率！"];
                return;
            }
        }
    
        if ([self.rdoIsSale getVal]) {
            //2是销售
            self.microGoodsVo.isSale = @"2";
        } else {
            //1是不销售
            self.microGoodsVo.isSale = @"1";
        }
        
        self.microGoodsVo.priority = @([self.lsPriority getStrVal].integerValue);
        self.microGoodsVo.salesStrategy = [self.lsSalesStrategy getStrVal].intValue;
        
        // 微店折扣只有在选择“按折扣价打折”策略时是必须上传，且小于100%
        if (self.microGoodsVo.salesStrategy == 2 && ![[self.lsDiscount getStrVal] isEqualToString:@""]) {
            self.microGoodsVo.weixinDiscount = [self.lsDiscount getStrVal].doubleValue;
        } else {
            self.microGoodsVo.weixinDiscount = 0.0;
        }
        
        if ([[self.lsSalesStrategy getStrVal] isEqualToString:@"1"]) {
            self.microGoodsVo.weixinPrice = self.microGoodsVo.retailPrice;
        } else {
            if (![[self.lsWeixinPrice getStrVal] isEqualToString:@""]) {
                self.microGoodsVo.weixinPrice = [self.lsWeixinPrice getStrVal].doubleValue;
            }
        }
        
        //获得原始路径
        NSMutableArray *oldPathList = [NSMutableArray array];
        for (MicroGoodsImageVo *microGoodsImageVo in self.microGoodsVo.mainImageVoList) {
            [oldPathList addObject:microGoodsImageVo.fileName];
        }
        
        self.microGoodsVo.details = [self.txtDetails getStrVal];
        self.microGoodsVo.mainImageVoList = [[NSMutableArray alloc] init];
        //存放图片对象
        NSMutableArray *imageVoList = [NSMutableArray array];
        //存放图片数据
        NSMutableArray *imageDataList = [NSMutableArray array];
        
        if ([self.boxPicture getFilePathList] != nil && [self.boxPicture getFilePathList].count > 0&&[self.boxPicture getFilePathList].count <= 5) {
            int idx = 0;
            for (NSString* img in [self.boxPicture getFilePathList]) {
                MicroGoodsImageVo *vo = [[MicroGoodsImageVo alloc] init];
                vo.opType = 0;
                vo.fileName = img;
                [self.microGoodsVo.mainImageVoList addObject:vo];
                SelectImgItem *selectImgItem = [[self.boxPicture getImageItemList] objectAtIndex:idx];
                NSString *oldPath = selectImgItem.oldPath;
                
                [oldPathList removeObject:oldPath];
                if (![oldPath isEqualToString:selectImgItem.path]) {
                    if (oldPath != nil) {
                        //删除图片
                        LSImageVo *imageVo = [LSImageVo imageVoWithFileName:oldPath opType:2 type:@"goods"];
                        [imageVoList addObject:imageVo];
                        
                    }
                    NSDictionary*dic=[self.boxPicture fileImageMap];
                    UIImage*PNG=[dic objectForKey:img];
                    //添加图片
                    if (PNG != nil) {
                        NSData *data = [ImageUtils dataOfImageAfterCompression:PNG];
                        LSImageDataVo *imageDataVo = [LSImageDataVo imageDataVoWithData:data file:img];
                        [imageDataList addObject:imageDataVo];
                        LSImageVo *imageVo = [LSImageVo imageVoWithFileName:img opType:1 type:@"goods"];
                        [imageVoList addObject:imageVo];
                    }
                }
                idx ++;
            }
        }
        
        for (NSString *oldPath in oldPathList) {
            LSImageVo *imageVo = [LSImageVo imageVoWithFileName:oldPath opType:2 type:@"goods"];
            [imageVoList addObject:imageVo];
        }
        
        NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
        //新接口加的参数标志 以后有可能被遗弃新接口传2 老接口传1
        [param setValue:@2 forKey:@"interface_version"];
        [param setValue:_synShopEntityId forKey:@"synShopEntityId"];
        [param setValue:[MicroGoodsVo getDictionaryData:self.microGoodsVo] forKey:@"microGoodsVo"];
    if (self.token == nil) {
        self.token = [[Platform Instance] getToken];
    }
    [param setValue:self.token forKey:@"token"];

        NSString *url = @"microGoods/save";
        __weak typeof(self) wself = self;
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            wself.token = nil;
            [weakSelf.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[LSWechatGoodListViewController class]]) {
                    LSWechatGoodListViewController *vc = (LSWechatGoodListViewController *)obj;
                    vc.createTime = 0;
                    vc.searchCode = @"";
                    [vc selectMicGoodsList];
                }
            }];
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popViewControllerAnimated:NO];
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
        //上传图片
        [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];
//    }
}

- (void)onConfirmImgClickWithTag:(NSInteger)btnIndex tag:(NSInteger)tag {
    if (btnIndex == 1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"]; return;
        }
        
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    //添加到集合中
    goodsImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    goodsImage = [ImageUtils scaleImageOfDifferentCondition:goodsImage
                                                  condition:[[Platform Instance] getkey:SHOP_MODE].intValue];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.png",self.unid,[NSString getUniqueStrByUUID]];
    self.imgFilePathTemp = filePath;
    [self uploadImgFinsh];
}

// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets {
    
    for (UIImage *img in photos) {
        goodsImage = [ImageUtils cropWeChatPhoto:img dispalyWidth:450.0f];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@.png",self.unid,[NSString getUniqueStrByUUID]];
        self.imgFilePathTemp = filePath;
        [self uploadImgFinsh];
    }
}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    [_selectedPhotos addObjectsFromArray:@[coverImage]];
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

- (void)uploadImgFinsh {
    [self.boxPicture changeImg:self.imgFilePathTemp img:goodsImage];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)updateViewSize {
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)onDelImgClickWithPath:(NSString *)path {
    [self.boxPicture removeFilePath:path];
}

#pragma mark - 查看商品详情 看是否和是哪个屁在实体店下架
- (void)getGoodDetailInfo {
    NSString* url = @"goods/goodsDetail";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:self.shopId forKey:@"shopId"];
    [param setValue:self.goodsId forKey:@"goodsId"];
    __weak WechatGoodsDetailsView *weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        
        id status = [json[@"goodsVo"] valueForKey:@"upDownStatus"];
        if ([status isKindOfClass:[NSNumber class]]) {
            weakSelf.goodsUpDownStatus = [status integerValue];
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


#pragma mark  - AlertBoxClient
- (void)understand {
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma notification 处理.
- (void)initNotifaction {
    [UIHelper initNotification:self.container event:Notification_UI_GoodsMicroEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_GoodsMicroEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification *)notification {
    
    if ( !_flg && [[self.rdoIsSale getStrVal] isEqualToString:@"0"]) {
        [self.titleBox editTitle:NO act:self.action];
    } else {
        [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
    }
}

#pragma mark 微店售价策略数据源
- (NSMutableArray *)microSaleStrategyList {
    if (!_microSaleStrategyList) {
        NameItemVO *itemVo = nil;
        _microSaleStrategyList = [NSMutableArray array];
        itemVo = [[NameItemVO alloc] initWithVal:@"自定义价格" andId:@"3"];
        [_microSaleStrategyList addObject:itemVo];
        itemVo = [[NameItemVO alloc] initWithVal:@"按零售价打折" andId:@"2"];
        [_microSaleStrategyList addObject:itemVo];
        itemVo = [[NameItemVO alloc] initWithVal:@"与零售价相同" andId:@"1"];
        [_microSaleStrategyList addObject:itemVo];
    }
    return _microSaleStrategyList;
}

#pragma mark 获得微店售价策略名称
- (NSString *)microSaleStrategyName:(NSString *)itemId {
    for (NameItemVO *itemVo in self.microSaleStrategyList) {
        if ([itemId isEqualToString:itemVo.itemId]) {
            return itemVo.itemName;
        }
    }
    return nil;
}

@end
