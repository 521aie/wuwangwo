//
//  WechatGoodsManagementStyleDetailViewViewController.m
//  retailapp
//
//  Created by zhangzt on 15/10/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatGoodsManagementStyleDetailViewViewController.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "FooterListView.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "EditItemRadio2.h"
#import "EditItemText.h"
#import "EditItemMemo.h"
#import "ItemTitle.h"
#import "EditImageBox.h"
#import "Wechat_MicroStyleVo.h"
#import "StyleGoodsVo.h"
#import "StyleVo.h"
#import "GoodsModuleEvent.h"
#import "MicroStyleGoodsVo.h"
#import "UIView+Sizes.h"
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AlertBox.h"
#import "WechatStylePictureView.h"
#import "WechatStyleColorImage.h"
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
#import "ImageUtils.h"
#import "GoodsSkuVo.h"
#import "AttributeValVo.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import "JSONKit.h"
#import "LSImageDataVo.h"
#import "LSImageVo.h"
#import "ObjectUtil.h"
#import "SelectImgItem.h"


//微店款式详情编辑页面设置
#define STYLE_MICRO_EDIT_ISSALE 1
//#define STYLE_MICRO_EDIT_ISUPDOWNSTATUS 2 // 服鞋-款式微店上下架

#define STYLE_MICRO_EDIT_PICTUREINFO 3
#define STYLE_MICRO_EDIT_PICTURECOLOUR 4

#define STYLE_MICRO_EDIT_SALESSTRATEGY 5
#define STYLE_MICRO_EDIT_PRIORITY 6
#define STYLE_MICRO_EDIT_DISCOUNT 7

#define STYLE_MICRO_EDIT_CUSTOMWAY 8

#define STYLE_MICRO_MEMO_STYLENAME 9
#define STYLE_MICRO_MEMO_DETAILS 10

#define STYLE_MICRO_PRICE 11


@interface WechatGoodsManagementStyleDetailViewViewController ()<TZImagePickerControllerDelegate>{
    UICollectionView *_collectionView;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    
    CGFloat _itemWH;
    CGFloat _margin;
    
    NSMutableArray *filePathList;
}

@property (nonatomic, strong) WechatService* wechatService;
@property (nonatomic, strong) GoodsService* goodsService;
@property (nonatomic, strong) MicroShopVo* microShopVo;

@property (nonatomic, strong) NSMutableArray *ColorArray;//存动态颜色text控件的数组

@property (nonatomic, strong) NSMutableArray *stylegoodsvolist;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic) NSInteger lastver;

@property (nonatomic) BOOL flg;

@property (nonatomic, copy) NSString *token;
/**关联图片和数据*/
@property (nonatomic, copy) NSString *unid;
/** <#注释#> */
@end

@implementation WechatGoodsManagementStyleDetailViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    filePathList = [NSMutableArray array];
    self.ColorArray = [NSMutableArray array];
    self.stylegoodsvolist = [NSMutableArray array];
    self.datas=[NSMutableArray array];
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    [UIHelper clearColor:self.container];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    _wechatService = [ServiceFactory shareInstance].wechatService;
    _goodsService = [ServiceFactory shareInstance].goodsService;
    self.microStyleVo = [[Wechat_MicroStyleVo alloc] init];
   
    if (self.detai == WECHAT_STYLE_MicroInfo) {
        [self selectMicroInfo];
    } else {
        [self selectStyleDetail];
    }
}

- (void)initHead {
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"微店款式详情" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)initMainView {
    //是否在微店中销售
    if ([self.microStyleVo.saleStatus isEqualToString:@"2"]) {
        _flg = YES;
        [self.rdoIsSale initData:@"1"];
        self.rdoIsSale.lblName.text = @"在微店中销售";
        [self.rdoIsSale initHit:@"在微店中显示"];
        [self showMicroInfo:YES];
    } else {
        _flg = NO;
        [self.rdoIsSale initData:@"0"];
        self.rdoIsSale.lblName.text = @"未在微店中销售";
        [self.rdoIsSale initHit:@"未在微店中显示"];
        [self showMicroInfo:NO];
    }
    
    [self.rdoIsSale initLabel:@"未在微店中销售" withHit:@"未在微店中显示" delegate:self];
    [self.rdoIsSale initData:@"0"];
    self.TitBaseInfo.lblName.text = @"基本信息";
    
    [self.meStyleName initLabel:@"款式名称" isrequest:NO delegate:self];
    self.meStyleName.lblVal.textColor = [UIColor grayColor];
    [self.txtBarcode initLabel:@"款号" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtBarcode.txtVal.enabled = NO;
    self.txtBarcode.txtVal.textColor = [UIColor grayColor];
    
    [self.txtBrand initLabel:@"品牌" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtBrand.txtVal.enabled = NO;
    self.txtBrand.txtVal.textColor = [UIColor grayColor];
    
    [self.txtHangTagPrice initLabel:@"吊牌价(元)" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtHangTagPrice.txtVal.enabled = NO;
    self.txtHangTagPrice.txtVal.textColor =[UIColor grayColor];
    
    [self.txtRetailPrice initLabel:@"零售价(元)" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtRetailPrice.txtVal.enabled = NO;
    self.txtRetailPrice.txtVal.textColor = [UIColor grayColor];
    
    [self.lsPriority initLabel:@"优先度" withHit:@"提示：优先度数值越小，在微店中显示越靠前" isrequest:YES delegate:self];
    [self.lsPriority initData:@"99" withVal:@"99"];
    [self.lsSalesStrategy initLabel:@"微店售价策略" withHit:nil isrequest:YES delegate:self];
    [self.lsDiscount initLabel:@"• 折扣率（%）" withHit:nil isrequest:YES delegate:self];
    [self.lsCustomWay initLabel:@"• 自定义方式" withHit:nil isrequest:YES delegate:self];
    [self.lsMicroPrice initLabel:@"• 微店售价(元)" withHit:nil isrequest:YES delegate:self];
   
    self.TitExtendInfo.lblName.text = @"扩展信息";
    [self.txtDetails initLabel:@"详情介绍" isrequest:NO delegate:self];
    [self.boxPicture initLabel:@"款式图片" delegate:self];
    [self.boxPicture initImgList:nil];
    self.TitColourImage.lblName.text = @"颜色图片";
    
    [self.lsColourImage initLabel:@"设置每个颜色图片" withHit:nil  delegate:self];
    self.lsColourImage.lblVal.placeholder = @"";
    self.TitPictureInfo.lblName.text = @"图文详情";
    [self.lsPictureInfo initLabel:@"图文详情" withHit:nil delegate:self];
    self.lsPictureInfo.lblVal.placeholder = @"";
    [self.lsColourImage.imgMore setImage:[UIImage imageNamed:@"ico_next"]];
    [self.lsPictureInfo.imgMore setImage:[UIImage imageNamed:@"ico_next"]];
    
    self.rdoIsSale.tag = STYLE_MICRO_EDIT_ISSALE;
    self.lsColourImage.tag = STYLE_MICRO_EDIT_PICTURECOLOUR;
    self.lsPictureInfo.tag = STYLE_MICRO_EDIT_PICTUREINFO;
    self.lsSalesStrategy.tag = STYLE_MICRO_EDIT_SALESSTRATEGY;
    self.lsPriority.tag = STYLE_MICRO_EDIT_PRIORITY;
    self.lsDiscount.tag = STYLE_MICRO_EDIT_DISCOUNT;
    self.lsCustomWay.tag = STYLE_MICRO_EDIT_CUSTOMWAY;
    self.meStyleName.tag = STYLE_MICRO_MEMO_STYLENAME;
    self.txtDetails.tag = STYLE_MICRO_MEMO_DETAILS;
    self.lsMicroPrice.tag = STYLE_MICRO_PRICE;
}


- (void)loadDatasFromStyleEditView:(wechatStyleDetailBack)callback {
    
    _viewTag = 1;
    _callback = callback;
}

- (void)selectMicroInfo {
    
    __weak WechatGoodsManagementStyleDetailViewViewController* weakSelf = self;
    [_wechatService selectWechatGoodsStyleDetail:self.shopId StyleId:self.styleId completionHandler:^(id json) {

        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json {
    
    self.microStyleVo = [Wechat_MicroStyleVo convertToMicroGoodsVo:[json objectForKey:@"microStyleVo"]];
    // 判断商品是否已经在微店上过架，没有上过价需要再次调用款式详情接口
    if(self.microStyleVo.saleStrategy != 0) {
        [self fillModel];
    } else {
        [self selectStyleDetail];
    }
}

- (void)fillModel {
    
    self.unid = self.microStyleVo.styleId;
    self.lastver = self.microStyleVo.lastVer;
    
    [self.meStyleName initData:self.microStyleVo.styleName];
    self.meStyleName.lblVal.textColor=[UIColor grayColor];
    [self.txtBarcode initData:self.microStyleVo.styleCode];
    [self.txtBrand initData:self.microStyleVo.brandName];
    [self.txtHangTagPrice initData:[NSString stringWithFormat:@"%.2f", self.microStyleVo.hangTagPrice]];
    [self.txtRetailPrice initData:[NSString stringWithFormat:@"%.2f", self.microStyleVo.retailPrice]];
    if (![[NSString stringWithFormat:@"%ld", (long)self.microStyleVo.priority] isEqualToString:@""]) {
        [self.lsPriority initData:[NSString stringWithFormat:@"%ld", (long)self.microStyleVo.priority] withVal:[NSString stringWithFormat:@"%ld", (long)self.microStyleVo.priority]];
    } else {
        [self.lsPriority initData:@"99" withVal:@"99"];
    }
    if (self.microStyleVo.attributeValVoList.count > 0) {
        NSString *colorName = @"";
        int i =0;
        for (AttributeValVo *attVo in self.microStyleVo.attributeValVoList) {
            colorName=attVo.attributeVal;
            EditItemList *txtcolor = [[EditItemList alloc]initWithFrame:CGRectMake(0 , 50, 320, 50)];
            txtcolor.tag = 100 + i;
            txtcolor.tag = 100 + i;
            i++;
            [txtcolor initLabel:colorName withHit:nil delegate:self];
            if (attVo.microGoodPrice == 0) {
                [txtcolor initData:[NSString stringWithFormat:@"0.00"] withVal:[NSString stringWithFormat:@"0.00"]];
            } else {
                [txtcolor initData:[NSString stringWithFormat:@"%.2f",attVo.microGoodPrice] withVal:[NSString stringWithFormat:@"%.2f",attVo.microGoodPrice]];
            }
            
            txtcolor.lblVal.textColor = [UIColor grayColor];
            [self.container insertSubview:txtcolor belowSubview:self.TitExtendInfo];
            [self.ColorArray addObject:txtcolor];
        }
    }
    
    if ([NSString stringWithFormat:@"%d", self.microStyleVo.saleStrategy] == nil || [[NSString stringWithFormat:@"%d", self.microStyleVo.saleStrategy] isEqualToString:@"0"]) {
        
        [self.lsSalesStrategy initData:[GoodsRender obtainMicroSaleStrategy:1] withVal:@"1"];
        [self.lsDiscount visibal:NO];
        [self.lsCustomWay visibal:NO];
        [self.lsMicroPrice visibal:NO];
        for(EditItemList *color in self.ColorArray){
            [color visibal:NO];
        }
    } else if ([[NSString stringWithFormat:@"%d", self.microStyleVo.saleStrategy] isEqualToString:@"1"]) {
        
        [self.lsSalesStrategy initData:[GoodsRender obtainMicroSaleStrategy:self.microStyleVo.saleStrategy] withVal:[NSString stringWithFormat:@"%d", self.microStyleVo.saleStrategy]];
        [self.lsDiscount visibal:NO];
        [self.lsCustomWay visibal:NO];
        [self.lsMicroPrice visibal:NO];
        for(EditItemList *color in self.ColorArray){
            [color visibal:NO];
        }
    } else if ([[NSString stringWithFormat:@"%d", self.microStyleVo.saleStrategy] isEqualToString:@"2"]) {
        
        // 按零售价打折
        [self.lsSalesStrategy initData:[GoodsRender obtainMicroSaleStrategy:self.microStyleVo.saleStrategy] withVal:[NSString stringWithFormat:@"%d", self.microStyleVo.saleStrategy]];
        [self.lsDiscount initData:[NSString stringWithFormat:@"%.2f",self.microStyleVo.microDiscountRate] withVal:[NSString stringWithFormat:@"%.2f",self.microStyleVo.microDiscountRate]];
        [self.lsMicroPrice initData:[NSString stringWithFormat:@"%0.2f",self.microStyleVo.microPrice] withVal:[NSString stringWithFormat:@"%0.2f",self.microStyleVo.microPrice]];
        
        if (self.ColorArray.count > 0) {
//            [self.lsMicroPrice visibal:NO];
//            for (EditItemList *color in self.ColorArray) {
//                [color visibal:YES];
//                [color editEnable:NO];
//            }
//        } else {
//            [self.lsMicroPrice visibal:YES];
            for (EditItemList *color in self.ColorArray) {
                [color visibal:NO];
                [color editEnable:NO];
            }
        }
        [self.lsDiscount visibal:YES];
        [self.lsCustomWay visibal:NO];
    } else if ([[NSString stringWithFormat:@"%d", self.microStyleVo.saleStrategy] isEqualToString:@"3"]) {
        // 按
        [self.lsSalesStrategy initData:[GoodsRender obtainMicroSaleStrategy:self.microStyleVo.saleStrategy] withVal:[NSString stringWithFormat:@"%d", self.microStyleVo.saleStrategy]];
        [self.lsCustomWay visibal:YES];
        [self.lsDiscount visibal:NO];
        if (self.microStyleVo.saleType==0 || self.microStyleVo.saleType==1) {
            [self.lsCustomWay initData:[GoodsRender obtainMicroSaleType:1] withVal:@"1"];
            [self.lsMicroPrice visibal:YES];
            for (EditItemList *color in self.ColorArray) {
                [color visibal:NO];
                [color editEnable:NO];
            }
        } else {
            [self.lsMicroPrice visibal:NO];
            [self.lsCustomWay initData:[GoodsRender obtainMicroSaleType:self.microStyleVo.saleType] withVal:[NSString stringWithFormat:@"%d",self.microStyleVo.saleType]];
            for (EditItemList *color in self.ColorArray) {
                [color visibal:YES];
                [color editEnable:YES];
            }
        }
    }
    
    
    [self.lsDiscount initData:[NSString stringWithFormat:@"%.2f", self.microStyleVo.microDiscountRate] withVal:[NSString stringWithFormat:@"%.2f", self.microStyleVo.microDiscountRate]];
    
    [self.lsMicroPrice initData:[NSString stringWithFormat:@"%.2f", self.microStyleVo.microPrice] withVal:[NSString stringWithFormat:@"%.2f", self.microStyleVo.microPrice]];
    
    [self.txtDetails initData:self.microStyleVo.details];
    
    if (self.microStyleVo.mainImageVoList != nil && self.microStyleVo.mainImageVoList.count > 0) {
        [self.boxPicture initImgList:self.microStyleVo.mainImageVoList];
    } else {
        [self.boxPicture initImgList:nil];
    }
    [filePathList addObjectsFromArray:[self.boxPicture getFilePathList]];
    
    if ([self.microStyleVo.saleStatus isEqualToString:@"2"]) {
        _flg = YES;
        [self.rdoIsSale initData:@"1"];
        self.rdoIsSale.lblName.text = @"在微店中销售";
        [self.rdoIsSale initHit:@"在微店中显示"];
        [self showMicroInfo:YES];
    }else {
        _flg = NO;
        [self.rdoIsSale initData:@"0"];
        self.rdoIsSale.lblName.text = @"未在微店中销售";
        [self.rdoIsSale initHit:@"未在微店中显示"];
        [self showMicroInfo:NO];
    }
    
    
    // 默认开微店修改
    if (_action == ACTION_CONSTANTS_EDIT && (!([[Platform Instance] isTopOrg] || [[Platform Instance] getShopMode] == 1))) {
        [self.boxPicture imageBoxUneditable];
        self.boxPicture.userInteractionEnabled = NO;
        [self.txtDetails editEnable:NO];
    }
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self initNotifaction];
}


- (void)showMicroInfo:(BOOL)flg {
    
    if (flg) {
        [self.TitBaseInfo visibal:YES];
//        [self.rdoIsUpDownStatus visibal:YES];
        [self.meStyleName visibal:YES];
        [self.txtBrand visibal:YES];
        [self.lsPriority visibal:YES];
        [self.txtBarcode visibal:YES];
        [self.txtRetailPrice visibal:YES];
        [self.lsSalesStrategy visibal:YES];
        if (self.microStyleVo.saleStrategy == 1 || self.styleVo.salesStrategy==1) {
            [self.lsDiscount visibal:NO];
            [self.lsCustomWay visibal:NO];
            [self.lsMicroPrice visibal:NO];
        }else if (self.microStyleVo.saleStrategy == 2 || self.styleVo.salesStrategy == 2) {
            [self.lsDiscount visibal:YES];
            [self.lsCustomWay visibal:NO];
            
//                [self.lsMicroPrice visibal:NO];
//                for (EditItemList *color in self.ColorArray) {
//                    [color visibal:YES];
//                    [color editEnable:NO];
//                }
//            }else{
            [self.lsMicroPrice visibal:YES];
            [self.lsMicroPrice editEnable:NO];
            if (self.ColorArray.count > 0 ) {
                for (EditItemList *color in self.ColorArray) {
                    [color visibal:NO];
                    [color editEnable:NO];
                }
            }
            
        } else if (self.microStyleVo.saleStrategy == 3 || self.styleVo.salesStrategy == 3) {
           
            [self.lsCustomWay visibal:YES];
            if(self.styleVo.salesType == 1 || self.microStyleVo.saleType == 1) {
                [self.lsMicroPrice visibal:YES];
                for (EditItemList *color in self.ColorArray) {
                    color.hidden=YES;
                    [color editEnable:NO];
                }
            } else if (self.styleVo.salesType == 2 || self.microStyleVo.saleType == 2 ) {
                for (EditItemList *color in self.ColorArray) {
                    [color visibal:YES];
                    [color editEnable:YES];
                }
                [self.lsMicroPrice visibal:NO];
            }
            [self.lsDiscount visibal:NO];
            
            
        }else{
            [self.lsDiscount visibal:NO];
        }
        
        [self.TitExtendInfo visibal:YES];
        [self.txtDetails visibal:YES];
        [self.boxPicture setHidden:NO];
        [self.TitColourImage visibal:YES];
        [self.lsColourImage visibal:YES];
        [self.TitPictureInfo visibal:YES];
        [self.lsPictureInfo visibal:YES];
        [self.txtHangTagPrice visibal:YES];
        
    }else{
        [self.TitBaseInfo visibal:NO];
//        [self.rdoIsUpDownStatus visibal:NO];
        [self.meStyleName visibal:NO];
        [self.txtBrand visibal:NO];
        [self.lsPriority visibal:NO];
        [self.txtBarcode visibal:NO];
        [self.txtRetailPrice visibal:NO];
        [self.lsSalesStrategy visibal:NO];
        [self.lsDiscount visibal:NO];
        [self.TitExtendInfo visibal:NO];
        [self.txtDetails visibal:NO];
        [self.boxPicture setHidden:YES];
        [self.TitPictureInfo visibal:NO];
        [self.lsPictureInfo visibal:NO];
        [self.TitColourImage visibal:NO];
        [self.lsColourImage visibal:NO];
        
        [self.txtHangTagPrice visibal:NO];
        [self.lsCustomWay visibal:NO];
        [self.lsMicroPrice visibal:NO];
        for (EditItemList *text in self.ColorArray) {
            [text visibal:NO];
            [text editEnable:NO];
        }
        
    }
}

#pragma mark - IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag == STYLE_MICRO_EDIT_PICTUREINFO) {
        
        WechatStylePictureView *wechatStylePictureView = [[WechatStylePictureView alloc]initWithNibName:[SystemUtil getXibName:@"WechatStylePictureView"] bundle:nil];
        wechatStylePictureView.action = ACTION_CONSTANTS_EDIT;
        wechatStylePictureView.microStyleVo = self.microStyleVo;
        wechatStylePictureView.shopId = self.shopId;
        wechatStylePictureView.styleId = self.styleId;
        [self.navigationController pushViewController:wechatStylePictureView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }else if (obj.tag == STYLE_MICRO_EDIT_SALESSTRATEGY) {
        
        [OptionPickerBox initData:[GoodsRender listMicroSaleStrategy]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        [OptionPickerBox changeImgManager:@"setting_data_clear"];
        
    } else if (obj.tag == STYLE_MICRO_EDIT_PRIORITY) {
        
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:2 digitLimit:0];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        
    } else if (obj.tag == STYLE_MICRO_EDIT_DISCOUNT) {
        
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        
    } else if (obj.tag == STYLE_MICRO_EDIT_PICTURECOLOUR) {
        
        WechatStyleColorImage *wechatStyleColorImage = [[WechatStyleColorImage alloc]initWithNibName:[SystemUtil getXibName:@"WechatStyleColorImage"] bundle:nil];
        wechatStyleColorImage.action = ACTION_CONSTANTS_EDIT;
        wechatStyleColorImage.microStyleVo = self.microStyleVo;
        wechatStyleColorImage.shopId = self.shopId;
        wechatStyleColorImage.styleId = self.styleId;
        [self.navigationController pushViewController:wechatStyleColorImage animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    } else if (obj.tag == STYLE_MICRO_EDIT_CUSTOMWAY) {
        
        [OptionPickerBox initData:[GoodsRender listMicroSaleType]itemId:[obj getStrVal]];
        [OptionPickerBox showManager:obj.lblName.text managerName:@"清空方式" client:self event:obj.tag];
        [OptionPickerBox changeImgManager:@"setting_data_clear"];
        
    } else if (obj.tag == STYLE_MICRO_PRICE) {
        
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        
    } else if (obj.tag > 99) {
        
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
    }
}

- (void)managerOption:(NSInteger)eventType {
    
    if (eventType == STYLE_MICRO_EDIT_SALESSTRATEGY) {
        [self.lsSalesStrategy initData:@"请选择" withVal:@""];
    } else if (eventType == STYLE_MICRO_EDIT_CUSTOMWAY) {
        [self.lsCustomWay initData:@"请选择" withVal:@""];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == STYLE_MICRO_EDIT_SALESSTRATEGY) {
       
        [self.lsSalesStrategy changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemId] isEqualToString:@"1"]) {
            [self.lsDiscount visibal:NO];
            [self.lsCustomWay visibal:NO];
            [self.lsMicroPrice visibal:NO];
            if (self.ColorArray.count>0) {
                for (EditItemList *text in self.ColorArray) {
                    [text visibal:NO];
                }
            }
        } else if ([[item obtainItemId] isEqualToString:@"2"]) {
            [self.lsDiscount visibal:YES];
            [self.lsDiscount initData:nil withVal:nil];
            [self.lsCustomWay visibal:NO];
//            if (self.ColorArray.count>0) {
//                [self.lsMicroPrice visibal:NO];
//                for (EditItemList *color in self.ColorArray) {
//                    [color visibal:YES];
//                    [color changeData:@"0.00" withVal:@"0.00"];
//                    [color editEnable:NO];
//                }
//            } else {
                [self.lsMicroPrice visibal:YES];
                [self.lsMicroPrice editEnable:NO];
                [self.lsMicroPrice initData:@"0.00" withVal:@"0.00"];
                for (EditItemList *color in self.ColorArray) {
                    [color visibal:NO];
                    [color editEnable:NO];
                }
//            }
        } else if ([[item obtainItemId] isEqualToString:@"3"]) {
            [self.lsDiscount visibal:NO];
            [self.lsCustomWay visibal:YES];
            [self.lsMicroPrice editEnable:YES];
            if (self.styleVo.retailPrice == nil) {
                [self.lsMicroPrice initData:[NSString stringWithFormat:@"%0.2f",self.microStyleVo.retailPrice] withVal:[NSString stringWithFormat:@"%0.2f",self.microStyleVo.retailPrice]];
            } else {
                [self.lsMicroPrice initData:[NSString stringWithFormat:@"%@",self.styleVo.retailPrice] withVal:[NSString stringWithFormat:@"%@",self.styleVo.retailPrice]];
            }
            
            if ([self.lsCustomWay getStrVal].integerValue == 2){
                if (self.ColorArray.count > 0) {
                    for (EditItemList *text in self.ColorArray) {
                        [text visibal:YES];
                        [text editEnable:YES];
                    }
                }
            } else {
                [self.lsCustomWay initData:[GoodsRender obtainMicroSaleType:1] withVal:@"1"];
                [self.lsMicroPrice visibal:YES];
                [self.lsMicroPrice editEnable:YES];
                if (self.ColorArray.count>0) {
                    for (EditItemList *text in self.ColorArray) {
                        [text visibal:NO];
                        [text editEnable:YES];
                    }
                }
            }
        }
    } else if (eventType == STYLE_MICRO_EDIT_CUSTOMWAY) {
        [self.lsCustomWay changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemId] isEqualToString:@"1"]) {
            if (self.ColorArray.count>0) {
                [self.lsMicroPrice visibal:NO];
            }else{
                [self.lsMicroPrice visibal:YES];
            }
            [self.lsMicroPrice visibal:YES];
            [self.lsMicroPrice editEnable:YES];
            if (self.ColorArray.count>0) {
                for (EditItemList *text in self.ColorArray) {
                    [text visibal:NO];
                    [text editEnable:YES];
                }
            }
        } else if ([[item obtainItemId] isEqualToString:@"2"]) {
            [self.lsMicroPrice visibal:NO];
            if (self.ColorArray.count>0) {
                for (EditItemList *text in self.ColorArray) {
                    [text visibal:YES];
                    [text editEnable:YES];
                }
            }
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
        
//        if (val.doubleValue > self.microStyleVo.retailPrice) {
//            val = [NSString stringWithFormat:@"%.2f",self.microStyleVo.retailPrice];
//        }
    } else if (eventType == STYLE_MICRO_EDIT_PRIORITY) {
        
        if (val.intValue > 99 || val.intValue <= 0) {
            
            val = @"99";
        } else {
            
            val = [NSString stringWithFormat:@"%d",val.intValue];
        }
        [self.lsPriority changeData:val withVal:val];
        
    } else if (eventType == STYLE_MICRO_EDIT_DISCOUNT) {
       
        if (val.doubleValue > 100.00) {
//            val = @"100.00";
            [AlertBox show:@"折扣率不能大于100"];
            return;
        } else {
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
        }
        
        [self.lsDiscount changeData:val withVal:val];
        [self.lsMicroPrice changeData:[NSString stringWithFormat:@"%.2f", self.microStyleVo.retailPrice*(val.doubleValue/100.00)] withVal:[NSString stringWithFormat:@"%.2f", self.microStyleVo.retailPrice*(val.doubleValue/100.00)]];

        
        if (self.ColorArray.count > 0) {
            NSInteger i = 0;
            for (EditItemList *text in self.ColorArray) {
                
                if (self.detai!=WECHAT_STYLE_MicroInfo) {
                    AttributeValVo *attVo=[_styleVo.attributeValVoList objectAtIndex:i];
                    [text changeData:[NSString stringWithFormat:@"%.2f",attVo.colorHangTagPrice*(val.doubleValue/100.00)] withVal:[NSString stringWithFormat:@"%.2f",attVo.colorHangTagPrice*(val.doubleValue/100.00)]];
                }else{
                    AttributeValVo *attVo=[self.microStyleVo.attributeValVoList objectAtIndex:i];
                    [text changeData:[NSString stringWithFormat:@"%.2f",attVo.colorHangTagPrice*(val.doubleValue/100.00)] withVal:[NSString stringWithFormat:@"%.2f",attVo.colorHangTagPrice*(val.doubleValue/100.00)]];
                }
                i = i+1;
            }
        } else {
            if (self.detai != WECHAT_STYLE_MicroInfo) {
                [self.lsMicroPrice changeData:[NSString stringWithFormat:@"%.2f",[_styleVo.retailPrice doubleValue]*(val.doubleValue/100.00)] withVal:[NSString stringWithFormat:@"%.2f",[_styleVo.hangTagPrice doubleValue]*(val.doubleValue/100.00)]];
            }else {
                [self.lsMicroPrice changeData:[NSString stringWithFormat:@"%.2f",self.microStyleVo.retailPrice*(val.doubleValue/100.00)] withVal:[NSString stringWithFormat:@"%.2f",self.microStyleVo.retailPrice*(val.doubleValue/100.00)]];
            }
        }
        
    }else if (eventType == STYLE_MICRO_PRICE){
        if (val.doubleValue < [self.txtRetailPrice getStrVal].doubleValue/2) {
            //            [AlertBox show:@"微店价格低于零售价一半"];
        }
        [self.lsMicroPrice changeData:val withVal:val];
    }else {
        [self.ColorArray[eventType-100] changeData:val withVal:val];
    }
    
}

- (void)onItemMemoListClick:(EditItemMemo *)obj {
    
    if (obj.tag == STYLE_MICRO_MEMO_STYLENAME) {
        // [MemoInputBox limitShow:STYLE_MICRO_MEMO_STYLENAME delegate:self title:@"款式名称" val:[self.meStyleName getStrVal] limit:50];
    } else if (obj.tag == STYLE_MICRO_MEMO_DETAILS) {
        
        MemoInputView *vc = [[MemoInputView alloc] init];
        [vc limitShow:STYLE_MICRO_MEMO_DETAILS delegate:self title:@"详情介绍" val:[self.txtDetails getStrVal] limit:50];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    }
}

//完成Memo输入.
- (void)finishInput:(int)event content:(NSString *)content {
    
    if (event == STYLE_MICRO_MEMO_STYLENAME) {
        [self.meStyleName changeData:content];
    } else if (event == STYLE_MICRO_MEMO_DETAILS ) {
        [self.txtDetails changeData:content];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)selectStyleDetail {
    
    __weak WechatGoodsManagementStyleDetailViewViewController *weakSelf = self;
    [_goodsService selectStyleDetail:_shopId styleId:_styleId distributionId:nil sourceId:@"2" completionHandler:^(id json) {
        [weakSelf responseSuccess1:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess1:(id)json {
    
    _styleVo = [StyleVo convertToStyleVo:[json objectForKey:@"styleVo"]];
    self.lastver = _styleVo.lastVer;
    self.categoryId = _styleVo.categoryId;
    [self fillModel11];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)fillModel11 {
    
    self.unid = self.microStyleVo.styleId;
    [self.txtDetails initData:_styleVo.details];
    if ([_styleVo.microSaleStatus isEqualToString:@"1"]) {
        _flg = NO;
        [self.rdoIsSale initData:@"0"];
        self.rdoIsSale.lblName.text = @"未在微店中销售";
        [self.rdoIsSale initHit:@"未在微店中显示"];
        [self showMicroInfo:NO];
    } else {
        _flg = YES;
        [self.rdoIsSale initData:@"1"];
        self.rdoIsSale.lblName.text = @"在微店中销售";
        [self.rdoIsSale initHit:@"在微店中显示"];
        [self showMicroInfo:YES];
    }
    
    [self.meStyleName initData:self.styleVo.styleName];
    self.meStyleName.lblVal.textColor = [UIColor grayColor];
    [self.txtBarcode initData:self.styleVo.styleCode];
    
    [self.txtBrand initData:self.styleVo.brandName];
    
    [self.txtHangTagPrice initData:[NSString stringWithFormat:@"%@", self.styleVo.hangTagPrice]];
    [self.txtRetailPrice initData:[NSString stringWithFormat:@"%@", self.styleVo.retailPrice]];
    
    if (self.styleVo.mainImageVoList != nil && self.styleVo.mainImageVoList.count > 0) {
        [self.boxPicture initImgList:self.styleVo.mainImageVoList];
    } else {
        [self.boxPicture initImgList:nil];
    }
    [filePathList addObjectsFromArray:[self.boxPicture getFilePathList]];
   
    // 款式按颜色
    if (self.styleVo.attributeValVoList.count > 0) {
        NSString *colorName = @"";
        int i = 0;
        for (AttributeValVo *attVo in self.styleVo.attributeValVoList) {
            colorName=attVo.attributeVal;
            EditItemList *txtcolor = [[EditItemList alloc]initWithFrame:CGRectMake(0 , 50, 320, 50)];
            txtcolor.tag = 100 + i;
            i++;
            [txtcolor initLabel:colorName withHit:nil delegate:self];
            if (attVo.microGoodPrice == 0) {
                [txtcolor initData:[NSString stringWithFormat:@"0.00"] withVal:[NSString stringWithFormat:@"0.00"]];
            } else {
                [txtcolor initData:[NSString stringWithFormat:@"%.2f",attVo.microGoodPrice] withVal:[NSString stringWithFormat:@"%.2f",attVo.microGoodPrice]];
            }
            
            txtcolor.lblVal.textColor = [UIColor grayColor];
            [self.container insertSubview:txtcolor belowSubview:self.TitExtendInfo];
            [self.ColorArray addObject:txtcolor];
        }
    }
    
    [self.lsSalesStrategy initData:[GoodsRender obtainMicroSaleStrategy:_styleVo.salesStrategy] withVal:[NSString stringWithFormat:@"%hd",_styleVo.salesStrategy]];
    
    [self.lsMicroPrice initData:[NSString stringWithFormat:@"%@",self.styleVo.retailPrice] withVal:[NSString stringWithFormat:@"%@",self.styleVo.retailPrice]];
    
    if ([NSString stringWithFormat:@"%d", self.styleVo.salesStrategy] == nil || [[NSString stringWithFormat:@"%d", self.styleVo.salesStrategy] isEqualToString:@"0"]) {
        [self.lsSalesStrategy initData:[GoodsRender obtainMicroSaleStrategy:1] withVal:@"1"];
        [self.lsCustomWay visibal:NO];
        [self.lsMicroPrice visibal:NO];
        [self.lsDiscount visibal:NO];
        for(EditItemList *color in self.ColorArray){
            [color visibal:NO];
        }
    } else if ([[NSString stringWithFormat:@"%d", self.styleVo.salesStrategy] isEqualToString:@"1"]) {
        [self.lsSalesStrategy initData:[GoodsRender obtainMicroSaleStrategy:self.styleVo.salesStrategy] withVal:[NSString stringWithFormat:@"%d", self.styleVo.salesStrategy]];
        [self.lsDiscount visibal:NO];
        [self.lsCustomWay visibal:NO];
        [self.lsMicroPrice visibal:NO];
        for(EditItemList *color in self.ColorArray){
            [color visibal:NO];
        }
    } else if ([[NSString stringWithFormat:@"%d", self.styleVo.salesStrategy] isEqualToString:@"2"]) {
        
        [self.lsSalesStrategy initData:[GoodsRender obtainMicroSaleStrategy:self.styleVo.salesStrategy] withVal:[NSString stringWithFormat:@"%d", self.styleVo.salesStrategy]];
        [self.lsDiscount initData:[NSString stringWithFormat:@"%0.2f",self.styleVo.weixinDiscountRate] withVal:[NSString stringWithFormat:@"%0.2f",self.styleVo.weixinDiscountRate]];
        [self.lsMicroPrice initData:[NSString stringWithFormat:@"%0.2f",self.styleVo.weixinPrice] withVal:[NSString stringWithFormat:@"%0.2f",self.styleVo.weixinPrice]];
        
        if (self.ColorArray.count>0) {
            [self.lsMicroPrice visibal:NO];
            for (EditItemList *color in self.ColorArray) {
                [color visibal:YES];
                [color editEnable:NO];
            }
        }else{
            [self.lsMicroPrice visibal:YES];
            for (EditItemList *color in self.ColorArray) {
                [color visibal:NO];
                [color editEnable:NO];
            }
        }
        [self.lsDiscount visibal:YES];
        [self.lsCustomWay visibal:NO];
    } else if ([[NSString stringWithFormat:@"%d", self.styleVo.salesStrategy] isEqualToString:@"3"]) {
        [self.lsSalesStrategy initData:[GoodsRender obtainMicroSaleStrategy:self.styleVo.salesStrategy] withVal:[NSString stringWithFormat:@"%d", self.styleVo.salesStrategy]];
        [self.lsMicroPrice initData:[NSString stringWithFormat:@"%0.2f",self.styleVo.weixinPrice] withVal:[NSString stringWithFormat:@"%0.2f",self.styleVo.weixinPrice]];
        if (self.styleVo.salesType == 0) {
            [self.lsCustomWay initData:[GoodsRender obtainMicroSaleType:1] withVal:@"1"];
        }else{
            [self.lsCustomWay initData:[GoodsRender obtainMicroSaleType:self.styleVo.salesType] withVal:[NSString stringWithFormat:@"%d",self.styleVo.salesType]];
        }
        
        [self.lsDiscount visibal:NO];
        [self.lsCustomWay visibal:YES];
        [self.lsMicroPrice visibal:NO];
    }
    
    //是否在微店中销售
    if ([_styleVo.microSaleStatus isEqualToString:@"2"]) {
        _flg = YES;
        [self.rdoIsSale initData:@"1"];
        self.rdoIsSale.lblName.text = @"在微店中销售";
        [self.rdoIsSale initHit:@"在微店中显示"];
        [self showMicroInfo:YES];
    }else {
        _flg = NO;
        [self.rdoIsSale initData:@"0"];
        self.rdoIsSale.lblName.text = @"未在微店中销售";
        [self.rdoIsSale initHit:@"未在微店中显示"];
        [self showMicroInfo:NO];
        [self.lsCustomWay visibal:NO];
        [self.lsMicroPrice visibal:NO];
    }
    
    // 默认开微店修改
    if (_action == ACTION_CONSTANTS_EDIT && (!([[Platform Instance] isTopOrg] || [[Platform Instance] getShopMode] == 1))) {
        [self.boxPicture imageBoxUneditable];
        self.boxPicture.userInteractionEnabled = NO;
        [self.txtDetails editEnable:NO];
    }
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self initNotifaction];
}

- (void)onItemRadioClick:(EditItemRadio *)obj {
    
    if (obj.tag == STYLE_MICRO_EDIT_ISSALE) {
        self.rdoIsSale.lblName.text = [self.rdoIsSale getVal]?@"在微店销售":@"未在微店销售";
        [self.rdoIsSale initHit:[self.rdoIsSale getVal]?@"在微店中显示":@"未在微店中显示"];
        if ([self.rdoIsSale getVal]) {
            if (self.styleVo.upDownStatus == 2) {
                [AlertBox show:@"该款式已在实体店下架，无法添加到微店销售！"];
            }
            [self showMicroInfo:YES];
        } else {
            [self showMicroInfo:NO];
        }
    }
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
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

- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == 1) {
        if (_viewTag == 1) {
            _callback(NO);
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        
        if ([self.rdoIsSale getVal]) {
            
            if (self.styleVo.upDownStatus == 2) {
                [self save];
            } else {
//                if([[Platform Instance] getShopMode]!=1){
//                    [self cheak1];
//                }else{
//                    [self save];
//                }
                [self cheak1];
            }
        } else {
            [self save];
        }
    }
}

- (void)cheak1 {
    
    double custom = 0;  //自定义最低折扣价
    double headquarters = 0; //总部设定的最低折扣价
    //获取款式最低折扣价
    if (self.detai == WECHAT_STYLE_MicroInfo) {
        headquarters = self.microStyleVo.singleDiscountConfigVal/100*_microStyleVo.hangTagPrice;
    } else {
        headquarters = _styleVo.singleDiscountConfigVal/100*[_styleVo.hangTagPrice doubleValue];
    }
    //最低折扣价为0时，判定为微店款式最低折扣价为不设置
    NSLog(@"%@",[self.lsSalesStrategy getStrVal]);
    if(headquarters == 0) {
        if ([self.lsSalesStrategy getStrVal].intValue == 1) {
            [self save];
        } else {
            
            if ([self.lsSalesStrategy getStrVal].intValue == 2) {
                if([NSString isBlank:[self.lsDiscount getStrVal]] && !self.lsDiscount.hidden) {
                    [AlertBox show:@"请输入折扣率！"];
                    return;
                }
            }
            [self cheak2];
        }
    } else {
        
        //按零售价打折时
        if ([self.lsSalesStrategy getStrVal].intValue == 2) {
            
            if([self.lsDiscount getStrVal].doubleValue == 0) {
                [AlertBox show:@"请输入折扣率！"];
                return;
            }
            if (self.detai==WECHAT_STYLE_MicroInfo) {
                custom=[[_lsDiscount getStrVal] doubleValue]/100*_microStyleVo.retailPrice;
            }else{
                custom=[[_lsDiscount getStrVal] doubleValue]/100*[_styleVo.retailPrice doubleValue];
            }
            if (custom >= headquarters) {
                [self cheak2];
            } else {
                [AlertBox show:@"微店售价低于总部设置的微店最低售价，无法保存!"];
            }
      
        } else if ([self.lsSalesStrategy getStrVal].intValue == 3) {
            
            //自定义价格时
            if ([self.lsCustomWay getStrVal].intValue == 1) {
                //自定义款式
                custom = [self.lsMicroPrice getStrVal].doubleValue;
                if (custom >= headquarters) {
                    [self cheak2];
                } else {
                    [AlertBox show:@"微店售价低于总部设置的微店最低售价，无法保存!"];
                }
            
            } else if ([self.lsCustomWay getStrVal].intValue == 2) {
                
                // 自定义颜色
                bool isYes = YES;
                for (int i = 0; i < self.ColorArray.count; i++) {
                    EditItemList *text = self.ColorArray[i];
                    
                    if (self.detai == WECHAT_STYLE_MicroInfo) {
                        custom=[text getStrVal].doubleValue;
                    } else {
                        custom=[text getStrVal].doubleValue;
                    }
                    if (custom<headquarters) {
                        isYes=NO;
                    }
                }
                
                if (isYes) {
                    [self cheak2];
                } else {
                    [AlertBox show:@"微店售价低于总部设置的微店最低售价，无法保存!"];
                }
            }
            
        } else {
            [self save];
        }
    }
}

- (void)cheak2 {
    
    double custom = 0;
    // 按零售价打折
    if ([self.lsSalesStrategy getStrVal].intValue == 2) {
        // 零售价
        if (self.detai == WECHAT_STYLE_MicroInfo ) {
            
            custom = [[_lsDiscount getStrVal] doubleValue]/100*_microStyleVo.retailPrice;
            if(custom<self.microStyleVo.retailPrice/2){
                [self showAlertView];
            }else{
                [self save];
            }
            
        } else {
            
            custom = [[_lsDiscount getStrVal] doubleValue]/100*[_styleVo.retailPrice doubleValue];
            if(custom<[_styleVo.retailPrice doubleValue]/2){
                [self showAlertView];
            }else{
                [self save];
            }
        }
        
    } else if ([self.lsSalesStrategy getStrVal].intValue == 3) {
        
        //自定义款式
        if ([self.lsCustomWay getStrVal].intValue == 1) {
            custom=[self.lsMicroPrice getStrVal].doubleValue;
             if (self.detai==WECHAT_STYLE_MicroInfo ) {
                 
                 if(custom < self.microStyleVo.retailPrice/2){
                     [self showAlertView];
                 } else {
                     [self save];
                 }
             } else {
                 if(custom<[_styleVo.retailPrice doubleValue]/2){
                     [self showAlertView];
                 }else{
                     [self save];
                 }
             }
            //自定义颜色
        }else if ([self.lsCustomWay getStrVal].intValue==2){
            bool isYes=YES;
            for (int i=0; i<self.ColorArray.count; i++) {
                EditItemList*text=self.ColorArray[i];
                custom=[text getStrVal].doubleValue;
                if (self.detai==WECHAT_STYLE_MicroInfo) {
                    if(custom<self.microStyleVo.retailPrice/2){
                        isYes=NO;
                    }
                }else{
                    if(custom<[_styleVo.retailPrice doubleValue]/2){
                        isYes=NO;
                    }
                }
            }
            if (isYes) {
                [self save];
            }else{
                [self showAlertView];
            }
        }
        
    }
}

- (void)showAlertView {
    NSString*str=[NSString stringWithFormat:@"微店售价低于零售价的二分之一,确定保存吗"];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:str
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确认", nil];
    alertView.tag = 301;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1 && alertView.tag==301) {
        [self save];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.token = nil;
}

- (void)save
{
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    if ([NSString isBlank:self.lsDiscount.lblVal.text] && self.lsDiscount.hidden == NO) {
        [AlertBox show:@"• 折扣率（%）不能为空！"];
        return;
    }
    
    __weak WechatGoodsManagementStyleDetailViewViewController* weakSelf = self;
//    if (self.action == ACTION_CONSTANTS_EDIT) {
        //        self.microStyleVo = [[Wechat_MicroStyleVo alloc] init];
        
        self.microStyleVo.styleId = self.styleId;
        
        self.microStyleVo.lastVer = self.lastver;
        
        self.microStyleVo.categoryId = self.categoryId;
        
        if ([self.rdoIsSale getVal]) {
            self.microStyleVo.saleStatus = @"2";
        }else{
            self.microStyleVo.saleStatus = @"1";
        }
        
        self.microStyleVo.priority = [self.lsPriority getStrVal].integerValue;
        
        self.microStyleVo.hangTagPrice = [self.txtHangTagPrice getStrVal].doubleValue;
        
        self.microStyleVo.retailPrice = [self.txtRetailPrice getStrVal].doubleValue;
        
        self.microStyleVo.saleStrategy = [self.lsSalesStrategy getStrVal].intValue;
        
        self.microStyleVo.microPrice = [self.lsMicroPrice getStrVal].doubleValue;
        if([[NSString stringWithFormat:@"%d", self.styleVo.salesStrategy] isEqualToString:@"3"]){
            
        }
        
        self.microStyleVo.microDiscountRate=[self.lsDiscount getStrVal].doubleValue;
        
        self.microStyleVo.styleCode = [self.txtBarcode getStrVal];
        
        self.microStyleVo.brandName = [self.txtBrand getStrVal];
        
        self.microStyleVo.styleName = [self.meStyleName getStrVal];
        
        self.microStyleVo.singleDiscountConfigVal=0;
        
        if ([[self.lsSalesStrategy getStrVal] isEqualToString:@"1"]) {
            self.microStyleVo.microPrice = self.microStyleVo.retailPrice;
        }else if ([[self.lsSalesStrategy getStrVal] isEqualToString:@"2"]) {
            self.microStyleVo.microDiscountRate = [self.lsDiscount getStrVal].doubleValue;
            self.microStyleVo.microPrice = [self.lsMicroPrice getStrVal].doubleValue;
        }
        self.microStyleVo.saleType = [self.lsCustomWay getStrVal].intValue;
        self.microStyleVo.details = [self.txtDetails getStrVal];
        
        NSMutableArray *attArry=[[NSMutableArray alloc] init];
        int j=0;
        if(self.detai==WECHAT_STYLE_MicroInfo){
            for(AttributeValVo *attValVo in self.microStyleVo.attributeValVoList) {
                for (int i=0; i<self.ColorArray.count; i++) {
                    EditItemList*text=self.ColorArray[i];
                    if(i==j){
                        attValVo.microGoodPrice=[text getStrVal].doubleValue;
                        [attArry addObject:attValVo];
                    }
                }
                j=j+1;
            }
        }else{
            for(AttributeValVo *attValVo in self.styleVo.attributeValVoList) {
                for (int i=0; i<self.ColorArray.count; i++) {
                    EditItemList*text=self.ColorArray[i];
                    if(i==j){
                        attValVo.microGoodPrice=[text getStrVal].doubleValue;
                        [attArry addObject:attValVo];
                    }
                }
                j=j+1;
            }
        }
        
        self.microStyleVo.attributeValVoList=attArry;
        //获得原始路径
        NSMutableArray *oldPathList = [NSMutableArray array];
        for (MicroGoodsImageVo *microGoodsImageVo in self.microStyleVo.mainImageVoList) {
            [oldPathList addObject:microGoodsImageVo.fileName];
        }
        self.microStyleVo.mainImageVoList = [[NSMutableArray alloc] init];
        //存放图片对象
        NSMutableArray *imageVoList = [NSMutableArray array];
        //存放图片数据
        NSMutableArray *imageDataList = [NSMutableArray array];
       
        if ([self.boxPicture getFilePathList] != nil && [self.boxPicture getFilePathList].count > 0) {
            int idx = 0;
            for (NSString* img in [self.boxPicture getFilePathList]) {
                MicroGoodsImageVo *vo = [[MicroGoodsImageVo alloc] init];
                vo.opType = 0;
                vo.fileName = img;
                [self.microStyleVo.mainImageVoList addObject:vo];
                SelectImgItem *selectImgItem = [[self.boxPicture getImageItemList] objectAtIndex:idx];
                NSString *oldPath = selectImgItem.oldPath;
                [oldPathList removeObject:oldPath];
                if (![oldPath isEqualToString:selectImgItem.path]) {
                    if (oldPath != nil) {
                        //删除图片
                        LSImageVo *imageVo = [LSImageVo imageVoWithFileName:oldPath opType:2 type:@"style"];
                        [imageVoList addObject:imageVo];
                        
                    }
                    NSDictionary*dic=[self.boxPicture fileImageMap];
                    UIImage*PNG=[dic objectForKey:img];
                    //添加图片
                    if (PNG != nil) {
                        NSData *data = [ImageUtils dataOfImageAfterCompression:PNG];
                        LSImageDataVo *imageDataVo = [LSImageDataVo imageDataVoWithData:data file:img];
                        [imageDataList addObject:imageDataVo];
                        LSImageVo *imageVo = [LSImageVo imageVoWithFileName:img opType:1 type:@"style"];
                        [imageVoList addObject:imageVo];
                    }
                }
                idx ++;
            }
        }
        for (NSString *oldPath in oldPathList) {
            LSImageVo *imageVo = [LSImageVo imageVoWithFileName:oldPath opType:2 type:@"style"];
            [imageVoList addObject:imageVo];
        }
        
    NSString *shopId = self.shopId;
        NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
        [param setValue:shopId?:[NSNull null] forKey:@"shopId"];
        [param setValue:_synShopEntityId forKey:@"synShopEntityId"];
        //新接口加的参数标志 以后有可能被遗弃新接口传2 老接口传1
        [param setValue:@2 forKey:@"interface_version"];
        [param setValue:[Wechat_MicroStyleVo getDictionaryData:self.microStyleVo] forKey:@"microStyleVo"];
        NSString *url = @"microStyle/save";
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            weakSelf.token = nil;
            if (_viewTag == 1) {
                _callback(YES);
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
             [AlertBox show:json];
        }];

        //上传图片
        [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];
//    }
}



#pragma mark - IEditItemImageEvent
// 款式图片添加
- (void)onConfirmImgClickWithTag:(NSInteger)btnIndex tag:(NSInteger)tag
{
    if (btnIndex == 1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"];
            return;
        }
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }else if(btnIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5-[self.boxPicture getFilePathList].count delegate:self];
        
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
            
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark TZImagePickerControllerDelegate
/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
    for (UIImage*img in photos) {
//        goodsImage = [ImageUtils scaleImageOfDifferentCondition:img condition:[[Platform Instance] getkey:SHOP_MODE].intValue];
        
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //添加到集合中
    goodsImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    NSString* entityId=[[Platform Instance] getkey:ENTITY_ID];
    goodsImage = [ImageUtils cropWeChatPhoto:goodsImage dispalyWidth:450.f];
   NSString* filePath = [NSString stringWithFormat:@"%@/%@.png",self.unid,[NSString getUniqueStrByUUID]];
    self.imgFilePathTemp = filePath;
    [self uploadImgFinsh];
    
}

-(void) uploadImgFinsh
{
    [self.boxPicture changeImg:self.imgFilePathTemp img:goodsImage];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)updateViewSize
{
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


- (void)onDelImgClickWithPath:(NSString *)path
{
    [self.boxPicture removeFilePath:path];
    if ([[self.boxPicture getFilePathList] isEqual:filePathList]) {
        [self.titleBox initWithName:@"微店款式详情" backImg:Head_ICON_BACK moreImg:nil];
        self.boxPicture.lblTip.hidden=YES;
    }
    
}


@end
